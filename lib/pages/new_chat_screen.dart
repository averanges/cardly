import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'package:flutter_gradient_text/flutter_gradient_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:sound/features/chat/model/groq_base_config.dart';
import 'package:sound/features/chat/model/groq_chat_role_setting_model.dart';
import 'package:sound/features/chat/provider/all_message_inherited_notifier.dart';
import 'package:sound/features/chat/provider/chat_inherited.dart';
import 'package:sound/features/chat/provider/record_inherited_notifier.dart';
import 'package:sound/features/chat/view/bot_message.dart';
import 'package:sound/features/chat/view/user_message.dart';
import 'package:sound/features/chat/view_model/all_message_view_model.dart';
import 'package:sound/features/chat/view_model/controller_view_model.dart';
import 'package:sound/features/chat/view_model/global_chat_settings_view_model.dart';
import 'package:sound/features/chat/view_model/global_user_view_model.dart';
import 'package:sound/features/chat/view_model/groq_handle_view_model.dart';
import 'package:sound/features/chat/view_model/messages_view_model.dart';
import 'package:sound/features/chat/view_model/record_view_model.dart';
import 'package:sound/features/chat/view_model/tasks_completed_view_model.dart';
import 'package:sound/models/message_model.dart';
import 'package:sound/models/score_model.dart';
import 'package:sound/pages/score_page.dart';
import 'package:sound/pages/template_gallery/ui/widgets/animated_gradient_text.dart';
import 'package:sound/pages/template_gallery/ui/widgets/animated_icon_button.dart';
import 'package:sound/pages/template_gallery/ui/widgets/chat_completed_score.dart';
import 'package:sound/utils/colors.dart';
import 'package:sound/utils/convert_string_to_time.dart';
import 'package:sound/utils/transform_list.dart';
import 'package:sound_stream/sound_stream.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';
import 'package:volume_watcher/volume_watcher.dart';

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({
    super.key,
    required this.cardIndex,
    required this.scenarioType,
    required this.chatDifficultLevel,
  });
  final int cardIndex;
  final ScenarioTypes scenarioType;
  final ChatDifficultLevels chatDifficultLevel;

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  int count = 0;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _messageListScrollController = ScrollController();
  double _currentVolume = 0;
  final Map<int, GlobalKey> _itemsKey = {};
  final SpeechToText _speech = SpeechToText();
  final GoogleTranslator _translator = GoogleTranslator();
  late RecordViewModel _recordViewModel;

  Map<GrogBaseConfigChoice, GroqChatRoleSettingModel> mapOfInitGroqChats = {};

  final PlayerStream _playerNew = PlayerStream();
  bool _isStreamStart = false;

  final bool _isTextFieldReadOnly = true;

  final AllMessageViewModel _allMessageViewModel = AllMessageViewModel();
  final GroqHandleViewModel _groqHandleViewModel = GroqHandleViewModel();

  late TasksCompletedViewModel _tasksCompletedViewModel;

  final bool _isNewMessageLoading = false;

  Uint8List adjustVolume(Uint8List audioChunk, double volumeFactor) {
    try {
      if (audioChunk.length % 2 != 0) {
        throw Exception('Invalid audio chunk length');
      }

      Uint8List adjustedChunk = Uint8List.fromList(audioChunk);
      Int16List samples = adjustedChunk.buffer.asInt16List();

      for (int i = 0; i < samples.length; i++) {
        samples[i] = (samples[i] * volumeFactor).clamp(-32768, 32767).toInt();
      }

      return adjustedChunk;
    } catch (e) {
      print('Error adjusting volume: $e');
      return Uint8List(0);
    }
  }

  // GroqChatRoleSettingModel initGroq(GrogBaseConfigChoice groqChoice) {
  //   return GroqBaseConfig(groqConfigChoice: groqChoice).groqChatRoleModel;
  // }

  Future<void> getCurrentVolume() async {
    VolumeWatcher.addListener((double volume) {
      setState(() {
        _currentVolume = volume * 0.2;
      });
    });
  }

  void playChunks(Uint8List audioChunk) async {
    try {
      if (!_isStreamStart) {
        await _playerNew.start();
        setState(() {
          _isStreamStart = true;
        });
      }

      double volumeFactor = _currentVolume;
      Uint8List adjustedChunk = adjustVolume(audioChunk, volumeFactor);

      if (adjustedChunk.isNotEmpty) {
        await _playerNew.writeChunk(adjustedChunk).then((_) => setState(() {
              _isStreamStart = false;
            }));
      } else {
        print('Skipped a corrupted chunk');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    GlobalUserViewModel globalUserViewModel =
        Provider.of<GlobalUserViewModel>(context);
    _tasksCompletedViewModel = TasksCompletedViewModel(
        tasksList: transformListData[widget.cardIndex]['tasks']);
    _recordViewModel = RecordViewModel(
        controllerViewModel: ControllerViewModel(),
        globalUserViewModel: globalUserViewModel);
    _recordViewModel.textController.addListener(() => _recordViewModel
        .controllerViewModel
        .scrollToBottomAlways(_scrollController));

    String tasksToString = _tasksCompletedViewModel.tasksToString();

    _groqHandleViewModel.initializeGroqChats(
        level: widget.chatDifficultLevel,
        scenarioType: widget.scenarioType,
        tasksString: tasksToString,
        aiRole: transformListData[widget.cardIndex]['aiRole']);
    super.didChangeDependencies();
  }

  void update() => setState(() {});
  @override
  void initState() {
    super.initState();

    _playerNew.initialize(sampleRate: 16000);
    getCurrentVolume();
    // getVoices();
    Future<void> initSpeechToText() async {
      try {
        await _speech.initialize();
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    initSpeechToText();
  }

  @override
  void dispose() {
    super.dispose();
  }

// ko_KR
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GlobalChatSettingsViewModel()),
          ChangeNotifierProvider(create: (_) => _tasksCompletedViewModel)
        ],
        child: ChatInherited(
          allMessageViewModel: _allMessageViewModel,
          groqHandleViewModel: _groqHandleViewModel,
          child: AllMessageInheritedNotifier(
            notifier: _allMessageViewModel,
            child: RecordInheritedNotifier(
              notifier: _recordViewModel,
              child: ChatWidget(
                  chatDifficultLevel: widget.chatDifficultLevel,
                  scenarioType: widget.scenarioType,
                  cardIndex: widget.cardIndex,
                  taskListLength: (transformListData[widget.cardIndex]['tasks']
                          as List<Map<String, dynamic>>)
                      .length,
                  playChunks: playChunks,
                  isStreamStart: _isStreamStart,
                  isNewMessageLoading: _isNewMessageLoading,
                  messageListScrollController: _messageListScrollController,
                  itemsKey: _itemsKey,
                  scrollController: _scrollController,
                  isTextFieldReadOnly: _isTextFieldReadOnly,
                  groqHandleViewModel: _groqHandleViewModel,
                  translator: _translator),
            ),
          ),
        ),
      ),
    );
  }
}

class ChatWidget extends StatefulWidget {
  const ChatWidget(
      {super.key,
      required ScrollController messageListScrollController,
      required this.cardIndex,
      required Map<int, GlobalKey<State<StatefulWidget>>> itemsKey,
      required ScrollController scrollController,
      required bool isTextFieldReadOnly,
      required GroqHandleViewModel groqHandleViewModel,
      required bool isNewMessageLoading,
      required this.playChunks,
      required this.isStreamStart,
      required GoogleTranslator translator,
      required this.scenarioType,
      required this.chatDifficultLevel,
      required this.taskListLength})
      : _messageListScrollController = messageListScrollController,
        _itemsKey = itemsKey,
        _scrollController = scrollController,
        _groqHandleViewModel = groqHandleViewModel,
        _translator = translator,
        _isNewMessageLoading = isNewMessageLoading;

  final bool isStreamStart;
  final ScrollController _messageListScrollController;
  final Map<int, GlobalKey<State<StatefulWidget>>> _itemsKey;
  final ScrollController _scrollController;
  final GroqHandleViewModel _groqHandleViewModel;
  final GoogleTranslator _translator;
  final bool _isNewMessageLoading;
  final Function(Uint8List) playChunks;
  final int cardIndex;
  final int taskListLength;
  final ScenarioTypes scenarioType;
  final ChatDifficultLevels chatDifficultLevel;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> with TickerProviderStateMixin {
  final String xiApiKey = dotenv.env['XI_API_KEY']!;
  final FocusNode _focusNode = FocusNode();
  final List<File> _allTempFiles = [];
  int _responseTime = 0;
  late AllMessageViewModel allMessageViewModel;
  bool _isFirstBotMessageArrived = false;
  int _countOfRequest = 0;
  final int _maxCountRequest = 20;
  final List<int> _allResponseTimeData = [];
  Timer? _responseSpeedTimer;
  final List<int> _taskCompletionIndexes = [];
  MessageModel? firstMessage;
  late int _globalChatTime;
  late Timer _globalTimeCountTimer;
  late AnimationController _timerAnimationController;
  late AnimationController _likeScoreAnimationController;
  bool _isAddedNumberIsVisible = false;
  int _correctGuessAmount = 0;
  late AnimationController _chatCompletionAnimationController;
  late TasksCompletedViewModel tasksCompletedViewModel;

  late ScoreModel _scoreModel;
  int likeScore = 0;

  // List<Color> _gradientColors = [lightGreyTextColor, primaryPurpleColor, lightGreyTextColor];

  Future<void> getVoices() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.elevenlabs.io/v1/voices'), headers: {
        "Accept": "application/json",
        "xi-api-key": xiApiKey,
        "Content-Type": "application/json"
      }).then((value) => jsonDecode(value.body));

      for (var voice in response['voices']) {
        print('${voice['name']} of this id : ${voice['voice_id']}');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    _likeScoreAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _chatCompletionAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _chatCompletionAnimationController.addListener(() {
      if (_chatCompletionAnimationController.status ==
          AnimationStatus.completed) {
        Future.delayed(
            const Duration(seconds: 2),
            () => _chatCompletionAnimationController.reverse().then((_) {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => PopScope(
                            canPop: false,
                            child: Dialog(
                                child: ChatCompletedScore(
                              cardIndex: widget.cardIndex,
                              chatDifficultLevel: widget.chatDifficultLevel,
                              correctGuess: _correctGuessAmount,
                              scenarioType: widget.scenarioType,
                              responsivenessRate: _scoreModel
                                  .calculateOverallResponsivenessScore(),
                              accuracy: _scoreModel.getUserAccuracy(),
                              engagementScore:
                                  _scoreModel.calculateEngagementScore(),
                              tasksCompletionScore:
                                  _scoreModel.calculateTaskCompletionRatio(),
                            )),
                          ));
                }));
      }
      setState(() {});
    });

    _globalChatTime = transformListData[widget.cardIndex]['time'] as int;
    _timerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        if (_timerAnimationController.status == AnimationStatus.forward) {
          _isAddedNumberIsVisible = true;
          setState(() {});
        } else if (_timerAnimationController.status ==
            AnimationStatus.completed) {
          _isAddedNumberIsVisible = false;
          _timerAnimationController.reset();
          setState(() {});
        }
      });

    _globalTimeCountTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_globalChatTime > 0) {
        setState(() {
          _globalChatTime--;
        });
      } else {
        timer.cancel();
        tasksCompletedViewModel.isChatCompletedSuccess = false;
        _chatCompletionAnimationController.forward();
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // getVoices();
    super.didChangeDependencies();
    tasksCompletedViewModel = Provider.of<TasksCompletedViewModel>(context);
    allMessageViewModel = AllMessageInheritedNotifier.of(context);
    if (firstMessage == null) {
      firstMessage = MessageModel(type: MessageTypes.botMessage);
      if (widget.scenarioType == ScenarioTypes.observation ||
          (widget.scenarioType == ScenarioTypes.charades &&
              widget.chatDifficultLevel == ChatDifficultLevels.newbie)) {
        MessageModel image = MessageModel(type: MessageTypes.image);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          allMessageViewModel.addMessage(image);
          Timer(
              const Duration(seconds: 5),
              () => image.setImage =
                  transformListData[widget.cardIndex]['imageIcon']);
        });
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        allMessageViewModel.addMessage(firstMessage!);

        Timer(
            const Duration(seconds: 2),
            () => firstMessage!.messageContent =
                transformListData[widget.cardIndex]['firstMessage']);
      });
    }

    if (allMessageViewModel.allMessages.any((MessageModel element) =>
            element.type == MessageTypes.botMessage) &&
        !_isFirstBotMessageArrived) {
      _responseSpeedTimer = Timer.periodic(
          const Duration(seconds: 1),
          (_) => setState(() {
                _responseTime++;
              }));

      _isFirstBotMessageArrived = true;
    }
    _scoreModel = ScoreModel(
        allMessages: allMessageViewModel.allMessages,
        allResponseTimeData: _allResponseTimeData,
        totalEvents: _countOfRequest,
        completionIndexes: _taskCompletionIndexes,
        allTasks: widget.taskListLength,
        completedTasks: tasksCompletedViewModel.completedTasksNumber());
  }

  bool getTaskCompletionCase(String result) {
    switch (result) {
      case '[0]':
        return true;
      case '0':
        return true;
      case '[1]':
        return true;
      case '1':
        return true;
      case '[2]':
        return true;
      case '2':
        return true;
      default:
        return false;
    }
  }

  void _addNewFileToList(File file) {
    _allTempFiles.add(file);
  }

  void _update() => setState(() {});

  void _deleteTempFiles() async {
    for (File file in _allTempFiles) {
      await file.delete();
    }
  }

  @override
  void dispose() {
    if (_responseSpeedTimer != null) _responseSpeedTimer?.cancel();
    _globalTimeCountTimer.cancel();
    _timerAnimationController.dispose();
    _chatCompletionAnimationController.dispose();
    _deleteTempFiles();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthOfScreen = MediaQuery.of(context).size.width;
    final globalSettings = Provider.of<GlobalChatSettingsViewModel>(context);
    final RecordViewModel recordViewModel = RecordInheritedNotifier.of(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Column(
          children: [
            AppBar(
              backgroundColor: backgroundColor,
              scrolledUnderElevation: 0,
              leadingWidth: 45,
              leading: Container(
                margin: const EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  backgroundColor: customButtonColor,
                  child: IconButton(
                    onPressed: () async {
                      final bool shouldPop =
                          await _showBackConfirmDialog() ?? false;
                      if (context.mounted && shouldPop) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => SettingsModalWindow(
                              globalSettings: globalSettings,
                            ));
                  },
                  icon: const CircleAvatar(
                    radius: 23,
                    backgroundColor: customButtonColor,
                    child: Icon(
                      Icons.settings_outlined,
                    ),
                  ),
                ),
              ],
              title: Column(
                children: [
                  AppBarTimer(
                    controller: _timerAnimationController,
                    globalChatTime: _globalChatTime,
                  ),
                  Text(
                    transformListData[widget.cardIndex]['title'],
                    style: GoogleFonts.jost(
                        textStyle: const TextStyle(
                            fontSize: 13, color: lightGreyTextColor)),
                  ),
                ],
              ),
              centerTitle: true,
            ),
            const SizedBox(
              height: 5,
            ),
            // Container(
            //   height: 2,
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     color: lightGreyTextColor.withOpacity(0.5),
            //     borderRadius: const BorderRadius.all(Radius.circular(20)),
            //   ),
            //   child: Row(
            //       children: List.generate(_maxCountRequest, (int index) {
            //     bool isFilled = false;
            //     for (var i = 1; i < _countOfRequest + 1; i++) {
            //       if (i - 1 == index) {
            //         isFilled = true;
            //       }
            //     }
            //     return Flexible(
            //         flex: 1,
            //         child: Container(
            //           decoration: BoxDecoration(
            //             color:
            //                 !isFilled ? Colors.transparent : primaryPurpleColor,
            //             border: const Border.symmetric(
            //                 vertical: BorderSide(
            //                     style: BorderStyle.solid, color: Colors.white)),
            //           ),
            //         ));
            //   })),
            // ),
            const Divider(
              height: 1,
              thickness: 0.4,
            ),
            TaskCompletenessBar(
              likeScore: likeScore,
              controller: _likeScoreAnimationController,
              chatDifficultLevel: widget.chatDifficultLevel,
              correctGuess: _correctGuessAmount,
              scenarioType: widget.scenarioType,
              allTasks: tasksCompletedViewModel.tasksCompletionMapsList.length,
              completedTasks: tasksCompletedViewModel.completedTasksNumber(),
              isCompleted: tasksCompletedViewModel.isChatCompletedSuccess,
              progress: tasksCompletedViewModel.progress,
              voidCallback: () {
                _globalTimeCountTimer.cancel();
                _chatCompletionAnimationController.forward();
              },
            )
          ],
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }
          final bool shouldPop = await _showBackConfirmDialog() ?? false;
          if (context.mounted && shouldPop) {
            Navigator.pop(context);
          }
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: widget._messageListScrollController,
                        itemCount: allMessageViewModel.allMessages.length,
                        itemBuilder: (context, index) {
                          final MessageModel messageObj =
                              allMessageViewModel.allMessages[index];
                          final GlobalKey messageKey = GlobalKey();
                          widget._itemsKey[index] = messageKey;
                          if (messageObj.type == MessageTypes.botMessage) {
                            final List<String> paragraphs =
                                messageObj.messageContent.split("\n");
                            return BotMessage(
                              isLast: index ==
                                  allMessageViewModel.allMessages.length - 1,
                              isStreamStart: widget.isStreamStart,
                              callback: _addNewFileToList,
                              audioBytes: messageObj.audioBytes == null
                                  ? Uint8List(0)
                                  : messageObj.audioBytes!,
                              isNewMessageLoading: widget._isNewMessageLoading,
                              originalMessage: messageObj.messageContent,
                              messageKey: messageKey,
                              paragraphs: paragraphs,
                            );
                          } else if (messageObj.type ==
                              MessageTypes.userMessage) {
                            return UserMessage(
                                isCorrect: messageObj.isCorrect,
                                mistakes: messageObj.mistakes,
                                message: messageObj.messageContent,
                                messageKey: messageKey);
                          } else if (messageObj.type ==
                              MessageTypes.taskCompleteMessage) {
                            return TaskCompletedMessage(
                              id: messageObj.id!,
                              count: messageObj.messageContent,
                              widthOfScreen: widthOfScreen,
                            );
                          } else if (messageObj.type == MessageTypes.image) {
                            return ImageMessage(
                              image: messageObj.image ?? '',
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          AnimatedGradientText(
                              text:
                                  'Say "Finish Conversation" to complete chat and see your results',
                              isVisible: globalSettings.isChatCompleted == true
                                  ? false
                                  : _maxCountRequest <= _countOfRequest),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RecordButton(
                                isChatCompleted: globalSettings.isChatCompleted,
                                voidCallback: _update,
                                recordViewModel: recordViewModel,
                                color: customGreenColor,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Container(
                                alignment: Alignment.bottomCenter,
                                height: 70,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(60)),
                                      border: Border.all(
                                          style: BorderStyle.solid,
                                          color: Colors.white.withOpacity(0.8)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromARGB(
                                                  255, 255, 255, 255)
                                              .withOpacity(0.8),
                                          spreadRadius: -8.0,
                                          blurRadius: 10.0,
                                          offset: const Offset(0, 2),
                                        )
                                      ]),
                                  child: Scrollbar(
                                    controller: widget._scrollController,
                                    thickness: 2,
                                    child: TextField(
                                      enabled:
                                          globalSettings.isChatCompleted == true
                                              ? globalSettings.isChatCompleted
                                              : recordViewModel
                                                  .controllerViewModel
                                                  .isTextFieldReadOnly,
                                      scrollController:
                                          recordViewModel.isRecording
                                              ? widget._scrollController
                                              : null,
                                      maxLines: null,
                                      minLines: null,
                                      keyboardType: TextInputType.multiline,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      onChanged: (value) {
                                        recordViewModel.controllerViewModel
                                            .setTextController = value;
                                        recordViewModel.completeSpeech.clear();
                                        recordViewModel.completeSpeech
                                            .add(value);
                                      },
                                      focusNode: _focusNode,
                                      controller:
                                          recordViewModel.textController,
                                      style: GoogleFonts.jost(
                                          textStyle:
                                              const TextStyle(fontSize: 12)),
                                      decoration: InputDecoration(
                                          suffixIcon: recordViewModel
                                                  .textController
                                                  .value
                                                  .text
                                                  .isNotEmpty
                                              ? IconButton(
                                                  onPressed: () {
                                                    recordViewModel
                                                        .textController
                                                        .clear();
                                                    recordViewModel
                                                        .completeSpeech
                                                        .clear();
                                                  },
                                                  icon: const Icon(
                                                    Icons.close,
                                                    size: 14,
                                                  ),
                                                )
                                              : null,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 20),
                                          filled: true,
                                          fillColor:
                                              Colors.black.withOpacity(0.05),
                                          border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(60)),
                                              borderSide: BorderSide.none)),
                                    ),
                                  ),
                                ),
                              )),
                              const SizedBox(
                                width: 5,
                              ),
                              recordViewModel.textController.value.text
                                      .trim()
                                      .isNotEmpty
                                  ? CircleAvatar(
                                      backgroundColor: const Color.fromRGBO(
                                          174, 219, 207, 1),
                                      maxRadius: 30,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.send,
                                          color: Colors.white,
                                        ),
                                        onPressed: () async {
                                          final String userInputContent =
                                              recordViewModel
                                                  .textController.value.text;

                                          _focusNode.unfocus();
                                          recordViewModel.textController
                                              .clear();
                                          recordViewModel.completeSpeech
                                              .clear();

                                          if (_maxCountRequest <=
                                                  _countOfRequest &&
                                              userInputContent
                                                      .trim()
                                                      .toLowerCase() ==
                                                  "finish conversation") {
                                            allMessageViewModel.addMessage(
                                                MessageModel(
                                                    type: MessageTypes
                                                        .chatCompleteMessage));
                                            globalSettings.setIsChatCompleted =
                                                true;
                                            return;
                                          }
                                          if (userInputContent.isNotEmpty) {
                                            MessageModel
                                                userRequestMessageModel =
                                                MessageModel(
                                                    messageContent:
                                                        userInputContent,
                                                    type: MessageTypes
                                                        .userMessage);
                                            allMessageViewModel.addMessage(
                                                userRequestMessageModel);
                                            MessageModel lastBotMessageModel =
                                                MessageModel(
                                                    type: MessageTypes
                                                        .botMessage);
                                            MessageModel taskCompletedModel =
                                                MessageModel(
                                                    id: Random().nextInt(100),
                                                    type: MessageTypes
                                                        .taskCompleteMessage);
                                            allMessageViewModel
                                                .addMessage(taskCompletedModel);
                                            allMessageViewModel.addMessage(
                                                lastBotMessageModel);
                                            _countOfRequest++;

                                            String taskCompletionResponse = '';

                                            setState(() {});
                                            List<Future<dynamic>> waitMethods =
                                                [
                                              widget._groqHandleViewModel
                                                  .sendMessage(
                                                      userInputContent,
                                                      GrogBaseConfigChoice
                                                          .groqForUserRequestResponse),
                                              widget._groqHandleViewModel
                                                  .sendMessage(
                                                      userInputContent,
                                                      GrogBaseConfigChoice
                                                          .groqForUserMistakesCorrect)
                                            ];
                                            if (widget.scenarioType ==
                                                ScenarioTypes.question) {
                                              waitMethods.add(widget
                                                  ._groqHandleViewModel
                                                  .sendMessage(
                                                      userInputContent,
                                                      GrogBaseConfigChoice
                                                          .groqForUserCompletedTasks));
                                            }
                                            final results =
                                                await Future.wait(waitMethods);
                                            // WidgetsBinding.instance
                                            //     .addPostFrameCallback((_) {
                                            //   recordViewModel.controllerViewModel
                                            //       .scrollToBottomOfListView(widget
                                            //           ._messageListScrollController);
                                            // });
                                            final String userRequestResponse =
                                                results[0];
                                            final String
                                                mistakesInRequestResponse =
                                                results[1];

                                            if (widget.scenarioType !=
                                                ScenarioTypes.question) {
                                              taskCompletionResponse = await widget
                                                  ._groqHandleViewModel
                                                  .sendMessage(
                                                      userRequestResponse,
                                                      GrogBaseConfigChoice
                                                          .groqForUserCompletedTasks);
                                            } else {
                                              taskCompletionResponse =
                                                  results[2];
                                            }

                                            print(
                                                'Task $taskCompletionResponse');

                                            if (taskCompletionResponse
                                                    .contains('[correct]') &&
                                                widget.scenarioType ==
                                                    ScenarioTypes.charades) {
                                              _globalChatTime += 10;
                                              _timerAnimationController.forward(
                                                  from: 0.0);
                                              _correctGuessAmount++;
                                              setState(() {});
                                            }
                                            if (widget.scenarioType ==
                                                    ScenarioTypes.question &&
                                                widget.chatDifficultLevel ==
                                                    ChatDifficultLevels
                                                        .advanced) {
                                              List<String> taskCompletionList =
                                                  taskCompletionResponse
                                                      .split('');
                                              String temp = '';

                                              for (var i = 0;
                                                  i < taskCompletionList.length;
                                                  i++) {
                                                if (int.tryParse(
                                                        taskCompletionList[
                                                            i]) !=
                                                    null) {
                                                  if (i != 0 &&
                                                      taskCompletionList[
                                                              i - 1] ==
                                                          '-') {
                                                    temp += taskCompletionList[
                                                        i - 1];
                                                    temp +=
                                                        taskCompletionList[i];
                                                  } else {
                                                    temp +=
                                                        taskCompletionList[i];
                                                  }

                                                  if (i ==
                                                          taskCompletionList
                                                                  .length -
                                                              1 ||
                                                      int.tryParse(
                                                              taskCompletionList[
                                                                  i + 1]) ==
                                                          null) {
                                                    likeScore = int.parse(temp);
                                                  }
                                                }
                                              }
                                            } else {
                                              List<String> taskCompletionList =
                                                  taskCompletionResponse
                                                      .split('');
                                              for (var i = 0;
                                                  i < taskCompletionList.length;
                                                  i++) {
                                                if (taskCompletionList[i] ==
                                                        '[' &&
                                                    int.tryParse(
                                                            taskCompletionList[
                                                                i + 1]) !=
                                                        null &&
                                                    taskCompletionList[i + 2] ==
                                                        ']') {
                                                  taskCompletionResponse =
                                                      taskCompletionList[i + 1];
                                                } else if (int.tryParse(
                                                            taskCompletionList[
                                                                i]) !=
                                                        null &&
                                                    taskCompletionList[i - 1] !=
                                                        "-" &&
                                                    int.parse(
                                                            taskCompletionList[
                                                                i]) >=
                                                        0 &&
                                                    int.parse(
                                                            taskCompletionList[
                                                                i]) <
                                                        3) {
                                                  taskCompletionResponse =
                                                      taskCompletionList[i];
                                                }
                                              }
                                              final bool successedTask =
                                                  getTaskCompletionCase(
                                                      taskCompletionResponse);
                                              if (successedTask) {
                                                int indexOfSuccessedTask =
                                                    int.parse(
                                                        taskCompletionResponse
                                                            .replaceAll(
                                                                RegExp(
                                                                    r'[\[\]]'),
                                                                ''));
                                                if (widget.scenarioType ==
                                                    ScenarioTypes.question) {
                                                  tasksCompletedViewModel
                                                      .toggleProgress();
                                                }
                                                final Map<String, dynamic>
                                                    element =
                                                    tasksCompletedViewModel
                                                            .tasksCompletionMapsList[
                                                        indexOfSuccessedTask];

                                                recordViewModel
                                                    .controllerViewModel
                                                    .scrollToBottomOfListView(widget
                                                        ._messageListScrollController);

                                                if (!element['completed']) {
                                                  element['completed'] = true;
                                                  taskCompletedModel
                                                          .messageContent =
                                                      tasksCompletedViewModel
                                                          .completedTasksNumber()
                                                          .toString();

                                                  _taskCompletionIndexes
                                                      .add(_countOfRequest - 1);
                                                } else {
                                                  allMessageViewModel
                                                      .removeMessage(
                                                          taskCompletedModel);
                                                }
                                              }
                                              if (!successedTask) {
                                                allMessageViewModel
                                                    .removeMessage(
                                                        taskCompletedModel);
                                              }
                                            }
                                            setState(() {});
                                            userRequestMessageModel
                                                    .addMistakes =
                                                mistakesInRequestResponse;
                                            userRequestMessageModel
                                                    .setIsCorrect =
                                                mistakesInRequestResponse;

                                            await Future.delayed(Duration.zero);
                                            if (userRequestResponse
                                                .trim()
                                                .isNotEmpty) {
                                              // final Directory directory =
                                              //     await getApplicationDocumentsDirectory();
                                              // final DateTime dateTime = DateTime.now();
                                              // final String filePath =
                                              //     '${directory.path}/temp_audio_$dateTime.wav';
                                              if (_isFirstBotMessageArrived) {
                                                _allResponseTimeData
                                                    .add(_responseTime);
                                                _responseTime = 0;
                                              }
                                              lastBotMessageModel
                                                      .messageContent =
                                                  userRequestResponse;

                                              if (_maxCountRequest <=
                                                      _countOfRequest &&
                                                  _countOfRequest -
                                                          _maxCountRequest >=
                                                      2) {
                                                Timer(
                                                    const Duration(seconds: 5),
                                                    () {
                                                  allMessageViewModel
                                                      .addMessage(MessageModel(
                                                          type: MessageTypes
                                                              .chatCompleteMessage));
                                                  globalSettings
                                                          .setIsChatCompleted =
                                                      true;
                                                  _responseSpeedTimer?.cancel();
                                                });
                                              }

                                              setState(() {});

                                              if (globalSettings
                                                  .isAutoRecordingStart) {
                                                recordViewModel.onRecordTap();
                                              }
                                              // const String voiceId =
                                              //     'cgSgspJ2msm6clMCkdW9';
                                              // final speechResponse = await http.post(
                                              //     Uri.parse(
                                              //       'https://api.elevenlabs.io/v1/text-to-speech/$voiceId/stream?output_format=pcm_16000',
                                              //     ),
                                              //     headers: {
                                              //       'Content-Type': 'application/json',
                                              //       'xi-api-key': xiApiKey
                                              //     },
                                              //     body: jsonEncode({
                                              //       "text": userRequestResponse,
                                              //       "model_id":
                                              //           "eleven_multilingual_v2",
                                              //     }));

                                              // Uint8List audioBytes =
                                              //     speechResponse.bodyBytes;
                                              // lastBotMessageModel.audioBytes =
                                              //     audioBytes;
                                              // widget.playChunks(audioBytes);
                                              // File currentFile = File(filePath);
                                              // await currentFile
                                              //     .writeAsBytes(audioBytes);
                                              // lastBotMessageModel.file = currentFile;
                                            }
                                          }
                                        },
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Divider(
                            thickness: 0.2,
                          ),
                          SizedBox(
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomChatSmallButton(
                                  buttonText:
                                      "Tasks ${tasksCompletedViewModel.completedTasksNumber()}/${widget.taskListLength}",
                                  icon: Iconsax.task,
                                  toOpenWidget:
                                      Consumer<TasksCompletedViewModel>(
                                    builder: (_, tasksCompletedViewModel, __) =>
                                        TasksSubModal(
                                      tasksCompletedViewModel:
                                          tasksCompletedViewModel,
                                    ),
                                  ),
                                ),
                                const CustomChatSmallButton(
                                  buttonText: "Translate",
                                  icon: Iconsax.translate,
                                  toOpenWidget: LanguageTranslateModal(),
                                ),
                                CustomChatSmallButton(
                                  buttonText: "Hints",
                                  icon: Iconsax.bubble,
                                  toOpenWidget: HintsModal(
                                    translator: widget._translator,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AddedTimeWidget(
                isVisible: _isAddedNumberIsVisible,
                controller: _timerAnimationController,
              ),
              Center(
                child: AnimatedTextDisplay(
                  scenarioType: widget.scenarioType,
                  controller: _chatCompletionAnimationController,
                  isCompleted: tasksCompletedViewModel.isChatCompletedSuccess,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showBackConfirmDialog() {
    return showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 245, 180, 161),
                            child: Icon(
                              Iconsax.warning_2,
                              color: Colors.white,
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Text('Are you sure you want to leave?',
                            style: GoogleFonts.jost(
                                textStyle: const TextStyle(fontSize: 20))),
                        Text('Your conversation will be permanently lost.',
                            style: GoogleFonts.jost(
                                textStyle: const TextStyle(
                                    color: lightGreyTextColor))),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context, true);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    style: BorderStyle.solid,
                                    color: Colors.black45),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                color: Colors.white),
                            child: Text(
                              'Leave',
                              style: GoogleFonts.jost(
                                  textStyle:
                                      const TextStyle(color: Colors.black45)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context, false);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: customButtonColor),
                            child: Text('Cancel',
                                style: GoogleFonts.jost(
                                    textStyle: const TextStyle(
                                        color: lightGreyTextColor))),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      ))
                ],
              ),
            ));
  }
}

class AnimatedTextDisplay extends StatefulWidget {
  final bool isCompleted;
  final ScenarioTypes scenarioType;
  final AnimationController controller;

  const AnimatedTextDisplay(
      {super.key,
      required this.isCompleted,
      required this.controller,
      this.scenarioType = ScenarioTypes.question});

  @override
  State<AnimatedTextDisplay> createState() => _AnimatedTextDisplayState();
}

class _AnimatedTextDisplayState extends State<AnimatedTextDisplay>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animation = Tween<double>(begin: 1, end: 0).animate(widget.controller);
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -100),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AnimatedSlide(
            offset: Offset(_animation.value, 0),
            duration: const Duration(seconds: 1),
            curve: Curves.easeOut,
            child: AnimatedOpacity(
              opacity: widget.controller.value,
              duration: const Duration(seconds: 1),
              child: GradientText(
                colors: widget.scenarioType == ScenarioTypes.charades
                    ? [Colors.yellowAccent, Colors.yellow]
                    : widget.isCompleted
                        ? [customGreenColor, Colors.green]
                        : [
                            const Color.fromARGB(255, 247, 110, 100),
                            Colors.red
                          ],
                Text(
                  'Card'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    // color: widget.scenarioType == ScenarioTypes.charades ? Colors. widget.isCompleted ? Colors.green : Colors.red,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black87,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedSlide(
            offset: Offset(-_animation.value, 0),
            duration: const Duration(seconds: 1),
            curve: Curves.easeOut,
            child: AnimatedOpacity(
              opacity: widget.controller.value,
              duration: const Duration(seconds: 1),
              child: GradientText(
                colors: widget.scenarioType == ScenarioTypes.charades
                    ? [Colors.yellowAccent, Colors.yellow]
                    : widget.isCompleted
                        ? [Colors.green, customGreenColor]
                        : [
                            const Color.fromARGB(255, 247, 110, 100),
                            Colors.red
                          ],
                Text(
                  widget.scenarioType == ScenarioTypes.charades
                      ? "Over".toUpperCase()
                      : widget.isCompleted
                          ? "Completed!".toUpperCase()
                          : "Failed".toUpperCase(),
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    // color: widget.isCompleted ? Colors.green : Colors.red,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black87,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskCompletenessBar extends StatefulWidget {
  final VoidCallback voidCallback;
  final bool isCompleted;
  final int completedTasks;
  final int allTasks;
  final ScenarioTypes scenarioType;
  final double progress;
  final int correctGuess;
  final int likeScore;
  final AnimationController controller;
  final ChatDifficultLevels chatDifficultLevel;
  const TaskCompletenessBar({
    this.scenarioType = ScenarioTypes.question,
    this.correctGuess = 0,
    required this.chatDifficultLevel,
    required this.likeScore,
    required this.controller,
    required this.voidCallback,
    required this.isCompleted,
    required this.allTasks,
    this.completedTasks = 0,
    required this.progress,
    super.key,
  });

  @override
  State<TaskCompletenessBar> createState() => _TaskCompletenessBarState();
}

class _TaskCompletenessBarState extends State<TaskCompletenessBar> {
  late Animation<double> _translateAnimation;

  @override
  void initState() {
    _translateAnimation =
        Tween<double>(begin: 0, end: 0).animate(widget.controller);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TaskCompletenessBar oldWidget) {
    if (oldWidget.likeScore != widget.likeScore) {
      _translateAnimation =
          Tween<double>(begin: 0, end: widget.likeScore.toDouble())
              .animate(widget.controller);
      widget.controller.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.chatDifficultLevel == ChatDifficultLevels.advanced
            ? Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 30,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Colors.redAccent, Colors.greenAccent]),
                  border:
                      Border.all(style: BorderStyle.solid, color: Colors.white),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: Colors.black.withOpacity(0.2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.8),
                      spreadRadius: -8.0,
                      blurRadius: 10.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: double.infinity,
                              width: 1,
                              color: Colors.white),
                          Container(
                              height: double.infinity,
                              width: 1,
                              color: Colors.white),
                        ],
                      ),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: AnimatedBuilder(
                            animation: widget.controller,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(_translateAnimation.value, 0),
                                child: const Icon(
                                  Iconsax.arrow_up,
                                  size: 20,
                                ),
                              );
                            }))
                  ],
                ),
              )
            : ClipPath(
                clipper: CustomClippedRectangle(),
                child: widget.isCompleted
                    ? GestureDetector(
                        onTap: () {
                          widget.voidCallback();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: customGreenColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber,
                                spreadRadius: 6,
                                blurRadius: 2,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: GradientAnimationText(
                            duration: const Duration(seconds: 1),
                            text: Text(
                              'Complete Chat'.toUpperCase(),
                              style: GoogleFonts.jost(
                                  fontSize: 15, letterSpacing: 2),
                            ),
                            colors: const [Colors.white, Colors.amberAccent],
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          // Background layer for progress bar (empty state)
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.05),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255)
                                          .withOpacity(0.8),
                                  spreadRadius: -8.0,
                                  blurRadius: 10.0,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),

                          AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            width: MediaQuery.of(context).size.width *
                                0.5 *
                                widget.progress,
                            height: 30,
                            decoration: BoxDecoration(
                              color: customGreenColor.withOpacity(0.8),
                            ),
                          ),

                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 30,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  widget.scenarioType == ScenarioTypes.question
                                      ? Iconsax.task
                                      : FontAwesomeIcons.lightbulb,
                                  size: 14,
                                  color: lightGreyTextColor,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  widget.scenarioType == ScenarioTypes.question
                                      ? 'Tasks ${widget.completedTasks}/${widget.allTasks}'
                                      : "Correct guesses: ${widget.correctGuess}",
                                  style: GoogleFonts.jost(
                                      fontSize: 14, color: lightGreyTextColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
      ],
    );
  }
}

class CustomClippedRectangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path()
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - 25, size.height)
      ..lineTo(25, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}

class AddedTimeWidget extends StatefulWidget {
  const AddedTimeWidget({
    required this.controller,
    required this.isVisible,
    super.key,
  });
  final AnimationController controller;
  final bool isVisible;

  @override
  State<AddedTimeWidget> createState() => _AddedTimeWidgetState();
}

class _AddedTimeWidgetState extends State<AddedTimeWidget> {
  late Animation<Offset> _animationTranslate;
  late Animation<double> _animationScale;
  late Animation<double> _animationOpacity;

  @override
  void initState() {
    _animationOpacity =
        Tween<double>(begin: 1, end: 0).animate(widget.controller);
    _animationScale =
        Tween<double>(begin: 1, end: 4).animate(widget.controller);
    _animationTranslate =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -500))
            .animate(widget.controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        top: 0,
        bottom: 0,
        right: 0,
        left: 0,
        child: Center(
            child: AnimatedBuilder(
                animation: widget.controller,
                builder: (context, child) {
                  return Visibility(
                    visible: widget.isVisible,
                    child: Opacity(
                      opacity: _animationOpacity.value,
                      child: Transform.translate(
                        offset: _animationTranslate.value,
                        child: Transform.scale(
                          scale: _animationScale.value,
                          child: Text(
                            '+10',
                            style: GoogleFonts.jost(
                                textStyle: const TextStyle(shadows: [
                              Shadow(
                                  color: Colors.black54,
                                  blurRadius: 5.0,
                                  offset: Offset(0, 2))
                            ], color: Colors.green, fontSize: 30)),
                          ),
                        ),
                      ),
                    ),
                  );
                })));
  }
}

class AppBarTimer extends StatefulWidget {
  const AppBarTimer(
      {super.key, required this.globalChatTime, required this.controller});
  final int globalChatTime;
  final AnimationController controller;

  @override
  State<AppBarTimer> createState() => _AppBarTimerState();
}

class _AppBarTimerState extends State<AppBarTimer> {
  late int _remainingTime;
  late Animation<int> _animationCount;
  late Animation<Color?> _animationColor;
  late Animation<double> _animationScale;

  @override
  void didUpdateWidget(covariant AppBarTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.globalChatTime != widget.globalChatTime) {
      setState(() {
        _remainingTime = widget.globalChatTime;
      });

      _animationCount =
          IntTween(begin: oldWidget.globalChatTime, end: widget.globalChatTime)
              .animate(widget.controller);
    }
  }

  @override
  void initState() {
    super.initState();

    _remainingTime = widget.globalChatTime;

    _animationColor = ColorTween(begin: customGreenColor, end: Colors.yellow)
        .animate(widget.controller);
    _animationScale = Tween<double>(begin: 1, end: 1.4).animate(
        CurvedAnimation(parent: widget.controller, curve: Curves.linear));
    _animationCount = IntTween(
            begin: widget.globalChatTime, end: widget.globalChatTime)
        .animate(
            CurvedAnimation(parent: widget.controller, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _animationScale.value,
          child: Text(
            convertIntegerToTime(_animationCount.value),
            style: GoogleFonts.jost(
              textStyle: TextStyle(
                  color: (_remainingTime >= 60)
                      ? customGreenColor
                      : (_remainingTime < 60 && _remainingTime >= 20)
                          ? Colors.orangeAccent
                          : Colors.redAccent,
                  fontSize: 20),
            ),
          ),
        );
      },
    );
  }
}

class ImageMessage extends StatefulWidget {
  const ImageMessage({
    required this.image,
    super.key,
  });
  final String image;

  @override
  State<ImageMessage> createState() => _ImageMessageState();
}

class _ImageMessageState extends State<ImageMessage>
    with SingleTickerProviderStateMixin {
  bool _isImageLoading = false;
  @override
  void initState() {
    _isImageLoading = widget.image == "";
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ImageMessage oldWidget) {
    if (oldWidget.image != widget.image && widget.image != '') {
      _isImageLoading = false;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          constraints: BoxConstraints.loose(const Size(300, 300)),
          decoration: BoxDecoration(
            color: lightGreyTextColor,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
                style: BorderStyle.solid, color: Colors.white.withOpacity(0.2)),
          ),
          child: !_isImageLoading
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                          image: AssetImage(
                        widget.image,
                      ))))
              : Lottie.asset(
                  repeat: true,
                  'assets/animations/imageLoading.json',
                ),
        ),
      ],
    );
  }
}

class ChatCompleteMessage extends StatefulWidget {
  final ScoreModel scoreModel;
  const ChatCompleteMessage({
    required this.scoreModel,
    super.key,
  });

  @override
  State<ChatCompleteMessage> createState() => _ChatCompleteMessageState();
}

class _ChatCompleteMessageState extends State<ChatCompleteMessage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..forward();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    double widthOfScreen = MediaQuery.of(context).size.width;
    _animation =
        Tween<Offset>(begin: Offset(widthOfScreen, 0), end: Offset.zero)
            .animate(CurvedAnimation(
                parent: _animationController, curve: Curves.linear));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Transform.translate(
        offset: _animation.value,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 150),
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 1,
                      color: Colors.white,
                      offset: Offset(0, 2))
                ],
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [customButtonColor, primaryPurpleColor],
                )),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/confetti_new.png',
                  fit: BoxFit.contain,
                ),
                Row(
                  children: [
                    const Expanded(child: SizedBox.shrink()),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Great work!',
                                  style: GoogleFonts.jost(
                                      textStyle: const TextStyle(
                                          color: Colors.white, fontSize: 30)),
                                ),
                                Text(
                                  'This Conversation was successfully completed. Click on button to see detailed statisics.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.jost(
                                      textStyle: const TextStyle(
                                          color: Colors.black54, fontSize: 12)),
                                )
                              ],
                            ),
                            AnimatedIconButton(
                              title: 'See Score',
                              nextPage: ScoreScreen(
                                responsivenessRate: widget.scoreModel
                                    .calculateOverallResponsivenessScore(),
                                accuracy: widget.scoreModel.getUserAccuracy(),
                                engagementScore: widget.scoreModel
                                    .calculateEngagementScore(),
                                tasksCompletionScore: widget.scoreModel
                                    .calculateTaskCompletionRatio(),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TaskCompletedMessage extends StatefulWidget {
  final double widthOfScreen;
  final String count;
  final int id;
  const TaskCompletedMessage({
    super.key,
    required this.id,
    required this.count,
    required this.widthOfScreen,
  });

  @override
  State<TaskCompletedMessage> createState() => _TaskCompletedMessageState();
}

class _TaskCompletedMessageState extends State<TaskCompletedMessage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _lottieAnimationController;
  late Animation<Offset> _animation;

  late Offset _offset;

  late Map<int, bool> animationCompletedMap;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _lottieAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    animationCompletedMap =
        Provider.of<TasksCompletedViewModel>(context).animationCompletedMap;
    if (!animationCompletedMap.containsKey(widget.id)) {
      animationCompletedMap[widget.id] = false;
    }
    if (animationCompletedMap[widget.id] == true) {
      _offset = const Offset(0, 0);
    } else {
      _offset = Offset(-widget.widthOfScreen, 0);
    }

    _animation = Tween<Offset>(begin: _offset, end: const Offset(0, 0)).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant TaskCompletedMessage oldWidget) {
    if (oldWidget.count != widget.count) {
      if (widget.count.isNotEmpty) {
        if (animationCompletedMap[widget.id] == false) {
          _animationController.forward().then((_) {
            _lottieAnimationController.forward();
            animationCompletedMap[widget.id] = true;
          });
        }
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _lottieAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.count.isEmpty
        ? const SizedBox()
        : AnimatedBuilder(
            animation: _animationController,
            builder: (context, snapshot) {
              return Transform.translate(
                offset: _animation.value,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 35),
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colors.white,
                                customGreenColor,
                                customGreenColor,
                                customGreenColor,
                                Colors.white
                              ]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 2,
                                    spreadRadius: 1.5,
                                    color: Colors.black12)
                              ]),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(
                              Icons.add_task,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text('Task ${widget.count}/3 Completed',
                                style: GoogleFonts.jost(
                                  textStyle:
                                      const TextStyle(color: Colors.white),
                                )),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.thumb_up_alt,
                              color: Colors.amber,
                            )
                          ]),
                        ),
                        Positioned.fill(
                          child: Transform.scale(
                            scale: 5.0,
                            child: Lottie.asset(
                              repeat: true,
                              'assets/animations/confetti.json',
                              controller: _lottieAnimationController,
                              onLoaded: (composition) {
                                _lottieAnimationController.duration =
                                    composition.duration;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            });
  }
}

class SettingsModalWindow extends StatefulWidget {
  final GlobalChatSettingsViewModel globalSettings;
  const SettingsModalWindow({super.key, required this.globalSettings});

  @override
  State<SettingsModalWindow> createState() => _SettingsModalWindowState();
}

class _SettingsModalWindowState extends State<SettingsModalWindow> {
  void update() => setState(() {});

  @override
  void initState() {
    widget.globalSettings.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    widget.globalSettings.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Chat Settings',
                  style: GoogleFonts.jost(
                      textStyle:
                          const TextStyle(fontSize: 25, letterSpacing: 5)),
                ),
                const SizedBox(
                  height: 10,
                ),
                settingsOptionChoice(
                    text: 'Audio Only Mode',
                    getter: widget.globalSettings.isAudioModeOnly,
                    setter: (value) =>
                        widget.globalSettings.setIsAudioModeOnly = value),
                settingsOptionChoice(
                    text: 'Show correction',
                    getter: widget.globalSettings.isShowCorrectionAlwaysOn,
                    setter: (value) => widget
                        .globalSettings.setIsShowCorrectionAlwaysOn = value),
                settingsOptionChoice(
                    text: 'Active each word translation',
                    getter: widget.globalSettings.isEachWordTranslationActive,
                    setter: (value) => widget
                        .globalSettings.setIsEachWordTranslationActive = value),
                settingsOptionChoice(
                    text: 'Auto Recording Start',
                    getter: widget.globalSettings.isAutoRecordingStart,
                    setter: (value) =>
                        widget.globalSettings.setIsAutoRecordingStart = value,
                    hintText:
                        'If the microphone should start recording right after the AI has stopped talking.'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Auto Submit'),
                          Slider(
                            thumbColor: Colors.white,
                            value: widget.globalSettings.autoSubmitTime,
                            activeColor: customGreenColor,
                            min: 0,
                            max: 60,
                            label: widget.globalSettings.autoSubmitTime
                                .round()
                                .toString(),
                            onChanged: (double value) {
                              widget.globalSettings.setAutoSubmitTime = value;
                            },
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.globalSettings.autoSubmitTime == 0
                              ? 'Don`t send message automatically'
                              : widget.globalSettings.autoSubmitTime == 60
                                  ? "Send message automatically after ONE minute"
                                  : "Send message automatically after ${widget.globalSettings.autoSubmitTime.round()} seconds",
                          style: GoogleFonts.jost(
                              textStyle: const TextStyle(
                                  fontSize: 12, color: lightGreyTextColor)),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -5,
            right: 0,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                size: 20,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget settingsOptionChoice(
      {required String text,
      String? hintText,
      required void Function(dynamic) setter,
      required bool getter}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text, style: GoogleFonts.jost()),
              Transform.scale(
                scale: 0.6,
                child: CupertinoSwitch(
                  activeColor: customGreenColor,
                  value: getter,
                  onChanged: setter,
                ),
              ),
            ],
          ),
          hintText != null
              ? Text(
                  hintText,
                  style: GoogleFonts.jost(
                      textStyle: const TextStyle(
                          fontSize: 12, color: lightGreyTextColor)),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}

class RecordButton extends StatefulWidget {
  final Color color;
  final VoidCallback voidCallback;
  final int size;
  final RecordViewModel recordViewModel;
  final bool isChatCompleted;
  const RecordButton(
      {super.key,
      required this.isChatCompleted,
      required this.voidCallback,
      required this.recordViewModel,
      this.color = customGreenColor,
      this.size = 60});

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer;
  int count = 0;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 130), (timer) {
      setState(() {
        count++;
        if (count == 12) {
          count = 0;
        }
      });
    });

    widget.recordViewModel.addListener(_recordingStatusChanged);
  }

  void _recordingStatusChanged() {
    if (widget.recordViewModel.isRecording) {
      _controller.repeat(reverse: false);
    } else {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void didUpdateWidget(covariant RecordButton oldWidget) {
    if (oldWidget.isChatCompleted != widget.isChatCompleted) {
      if (widget.isChatCompleted) {
        _timer.cancel();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.recordViewModel.removeListener(_recordingStatusChanged);
    super.dispose();
    _controller.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.isChatCompleted) {
          widget.recordViewModel.onRecordTap();
        }
        // widget.voidCallback();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildCircle(1.0),
          _buildCircle(0.8),
          _buildCircle(0.6),
          _buildCircle(0.4),
          Container(
            padding: const EdgeInsets.all(8),
            width: widget.size.toDouble(),
            height: widget.size.toDouble(),
            decoration: BoxDecoration(
              border: Border.all(
                style: BorderStyle.solid,
                color: Colors.white,
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  spreadRadius: 0.8,
                  blurRadius: 2,
                ),
              ],
              gradient: LinearGradient(
                transform: GradientRotation(count / 2),
                colors: widget.isChatCompleted
                    ? [Colors.grey[400]!, Colors.grey[300]!]
                    : [
                        widget.color,
                        widget.color,
                        widget.color,
                        widget.color,
                        widget.color,
                        Colors.white,
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
              ),
              shape: BoxShape.circle,
            ),
            child: widget.recordViewModel.isRecording
                ? Icon(Icons.mic_off,
                    color: Colors.white, size: widget.size.toDouble() * 0.5)
                : Icon(Icons.mic,
                    size: widget.size.toDouble() * 0.5, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(double scale) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: scale + _animation.value * 1.2,
        child: Container(
          width: widget.size.toDouble(),
          height: widget.size.toDouble(),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                  color: widget.color.withOpacity((1 - _animation.value) * 0.3),
                  style: BorderStyle.solid,
                  width: 10)),
        ),
      ),
    );
  }
}

class CustomChatSmallButton extends StatelessWidget {
  final IconData? icon;
  final String buttonText;
  final Widget toOpenWidget;
  const CustomChatSmallButton({
    required this.buttonText,
    required this.toOpenWidget,
    this.icon,
    super.key,
  });

  void showBottomModalWindow(BuildContext context, Widget widget) {
    showBottomSheet(
        context: context,
        builder: (context) =>
            CustomButtomModalWindow(toOpenWidget: toOpenWidget));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showBottomModalWindow(context, toOpenWidget);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        height: 30,
        decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(blurRadius: 1, spreadRadius: 0.4, color: Colors.black12)
            ],
            color: customButtonColor,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: Colors.black54,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              buttonText,
              style: GoogleFonts.jost(
                  textStyle: const TextStyle(color: Colors.black54)),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButtomModalWindow extends StatelessWidget {
  final Widget toOpenWidget;
  const CustomButtomModalWindow({
    required this.toOpenWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            gradient: RadialGradient(center: Alignment.topCenter, colors: [
              Colors.white,
              customButtonColor,
            ]),
            boxShadow: [
              BoxShadow(blurRadius: 1, spreadRadius: 0.5, color: Colors.black12)
            ],
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        width: double.infinity,
        height: 200,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close)),
            ),
            toOpenWidget
          ],
        ));
  }
}

class HintsModal extends StatefulWidget {
  final GoogleTranslator translator;
  const HintsModal({super.key, required this.translator});

  @override
  State<HintsModal> createState() => _HintsModalState();
}

class _HintsModalState extends State<HintsModal> {
  final String hintMessage = '[default]';
  GroqHandleViewModel? _groqHandleViewModel;
  AllMessageViewModel? _allMessageViewModel;
  final ScrollController _scrollController = ScrollController();

  ChatInherited? _chatInherited;
  bool _isNewHintMessageLoading = false;

  String lastMessageContent = "[default]";
  Future<void> _scrollToBottom() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> getListOfHints(GroqHandleViewModel? groqHandleViewModel,
      String lastMessageContent) async {
    try {
      if (groqHandleViewModel != null && _allMessageViewModel != null) {
        _isNewHintMessageLoading = true;
        setState(() {});
        final String response = await groqHandleViewModel.sendMessage(
            lastMessageContent, GrogBaseConfigChoice.groqForUserRequestHints);
        _allMessageViewModel!.addMessageToListOfHints(response);
        _isNewHintMessageLoading = false;
        await _scrollToBottom();
      } else {
        throw "GroqHandleViewModel not initialized";
      }
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _chatInherited = ChatInherited.of(context);

    if (_chatInherited != null) {}
    _allMessageViewModel = _chatInherited!.allMessageViewModel;
    _groqHandleViewModel = _chatInherited!.groqHandleViewModel;

    lastMessageContent =
        _allMessageViewModel!.findLastOneByType(MessageTypes.botMessage);
    if (_allMessageViewModel != null &&
        _allMessageViewModel!.listOfHints.isEmpty) {
      getListOfHints(_groqHandleViewModel, lastMessageContent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _allMessageViewModel != null &&
            _allMessageViewModel!.listOfHints.isNotEmpty
        ? Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _allMessageViewModel!.listOfHints.length + 1,
              itemBuilder: (context, i) {
                if (i < _allMessageViewModel!.listOfHints.length) {
                  return _isNewHintMessageLoading &&
                          i == _allMessageViewModel!.listOfHints.length - 1
                      ? SkeletonEffectExample(
                          index: i,
                        )
                      : SingleHintModule(
                          index: i,
                          originalText: _allMessageViewModel!.listOfHints[i],
                        );
                } else {
                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: lightGreyTextColor,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.add,
                          size: 15,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          getListOfHints(
                              _groqHandleViewModel, lastMessageContent);
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}

class SkeletonEffectExample extends StatelessWidget {
  final int index;
  const SkeletonEffectExample({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
        shimmerColor: Colors.grey[100]!,
        shimmerDuration: 800,
        child: Container(
          constraints: const BoxConstraints(minHeight: 60),
          margin: index != 0
              ? const EdgeInsets.only(top: 10)
              : const EdgeInsets.only(top: 0),
          decoration: BoxDecoration(
            // color: Colors.grey[300],
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            border: Border.all(
              style: BorderStyle.solid,
              color: lightGreyTextColor,
            ),
          ),
        ));
  }
}

class SingleHintModule extends StatefulWidget {
  final String originalText;
  final int index;
  const SingleHintModule({
    super.key,
    required this.index,
    required this.originalText,
  });

  @override
  State<SingleHintModule> createState() => _SingleHintModuleState();
}

class _SingleHintModuleState extends State<SingleHintModule> {
  String lastMessageContent = "[default]";
  late SingleMessageViewModel _singleMessageViewModel;
  late GlobalUserViewModel globalUserViewModel;

  void _update() => setState(() {});

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _singleMessageViewModel.removeListener(_update);
  }

  @override
  void didChangeDependencies() {
    globalUserViewModel = Provider.of<GlobalUserViewModel>(context);
    _singleMessageViewModel =
        SingleMessageViewModel(globalUserViewModel: globalUserViewModel)
          ..addListener(_update);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final RecordViewModel recordViewModel = RecordInheritedNotifier.of(context);
    final GlobalChatSettingsViewModel globalChatSettingsViewModel =
        Provider.of<GlobalChatSettingsViewModel>(context);
    return Container(
        constraints: const BoxConstraints(minHeight: 60),
        margin: widget.index != 0
            ? const EdgeInsets.only(top: 10)
            : const EdgeInsets.only(top: 0),
        decoration: BoxDecoration(
          color: customButtonColor,
          boxShadow: const [
            BoxShadow(blurRadius: 0.4, spreadRadius: 1.4, color: Colors.white)
          ],
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          border: Border.all(
            style: BorderStyle.solid,
            color: lightGreyTextColor,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 20,
          ),
          title: Text(
            _singleMessageViewModel.isTextTranslated
                ? _singleMessageViewModel.translatedMessageContent
                : widget.originalText,
            style: GoogleFonts.jost(textStyle: const TextStyle(fontSize: 12)),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinningTranslateButton(
                singleMessageViewModel: _singleMessageViewModel,
                message: widget.originalText,
                size: 18,
                color: customGreenColor,
              ),
              IconButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                            isChatCompleted:
                                globalChatSettingsViewModel.isChatCompleted,
                            voidCallback: _update,
                            recordViewModel: recordViewModel,
                            singleMessageViewModel: _singleMessageViewModel,
                            originText: widget.originalText,
                          ));
                },
                icon: const Icon(
                  Icons.mic,
                  color: customGreenColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ));
  }
}

class CustomDialog extends StatefulWidget {
  final String originText;
  final RecordViewModel recordViewModel;
  final SingleMessageViewModel singleMessageViewModel;
  final VoidCallback voidCallback;
  final bool isChatCompleted;
  const CustomDialog({
    super.key,
    required this.isChatCompleted,
    required this.voidCallback,
    required this.recordViewModel,
    required this.singleMessageViewModel,
    required this.originText,
  });

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  void _update() => setState(() {});
  late List<String> _textByWords;
  final List<String> _correctlyPronouncedElements = [];

  double _correctPercentageTotal = -1;
  bool _hasAttempted = false;

  final RegExp regex = RegExp(r'^[a-zA-Z]+$');

  @override
  void initState() {
    _textByWords = widget.originText.split(' ');
    widget.recordViewModel.addListener(_pronounceComparison);
    super.initState();
  }

  @override
  void dispose() {
    widget.recordViewModel.removeListener(_pronounceComparison);
    super.dispose();
  }

  void _correctPercentage(
      int totalOriginLength, int totalCorrectlyPronouncedWords) {
    _correctPercentageTotal =
        totalCorrectlyPronouncedWords / totalOriginLength * 100;
    setState(() {});
  }

  void _pronounceComparison() {
    if (widget.recordViewModel.completeSpeech.isNotEmpty) {
      List<String> separatedCompleteSpeech =
          widget.recordViewModel.completeSpeech.last.split(' ');
      setState(() {
        _correctlyPronouncedElements.clear();
        for (String word in _textByWords) {
          String updatedWord = word
              .toLowerCase()
              .split('')
              .where((element) => regex.hasMatch(element))
              .join('');
          if (separatedCompleteSpeech.isNotEmpty &&
              separatedCompleteSpeech
                  .map((el) => el.toLowerCase())
                  .contains(updatedWord)) {
            _correctlyPronouncedElements.add(word);
          }
          String normalizedWord = word.toLowerCase();
          if (normalizedWord.contains(RegExp(r"[`']"))) {
            List<String> splitParts = normalizedWord.split(RegExp(r"[`']"));
            String firstPart = splitParts[0];
            String secondPart = splitParts[1];
            int firstPartIndex =
                separatedCompleteSpeech.indexWhere((el) => el == firstPart);
            if (firstPartIndex != -1 &&
                firstPartIndex + 1 < separatedCompleteSpeech.length) {
              String nextPronouncedWord =
                  separatedCompleteSpeech[firstPartIndex + 1].toLowerCase();

              if (nextPronouncedWord.endsWith(secondPart)) {
                _correctlyPronouncedElements.add(word);
              }
            }
          }
          if (normalizedWord.contains('-')) {
            List<String> splitParts = normalizedWord.split('-');
            String firstPart = splitParts[0];
            String secondPart = splitParts[1];
            if (separatedCompleteSpeech.contains(firstPart) &&
                separatedCompleteSpeech.contains(secondPart)) {
              _correctlyPronouncedElements.add(word);
            }
          }
        }
        if (!widget.recordViewModel.isRecording) {
          _hasAttempted = true;
          _correctPercentage(
              _textByWords.length, _correctlyPronouncedElements.length);
        }
      });
    }
  }

  bool _colorSwitch(String word) {
    if (_correctlyPronouncedElements.contains(word)) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 5,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                size: 22,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.volume_up,
                          color: Colors.black54,
                          size: 20,
                        ),
                        onPressed: () {},
                      ),
                      Text(
                        "Say...",
                        style: GoogleFonts.amiri(
                            textStyle: const TextStyle(
                                fontSize: 18,
                                letterSpacing: 5,
                                color: Colors.black54)),
                      ),
                    ],
                  ),
                ),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        children: _textByWords
                            .map((word) => WidgetSpan(
                                    child: SingleColoredWordInHintsModal(
                                  isWordPronounced: _colorSwitch(word),
                                  word: word,
                                )))
                            .toList())),
                const SizedBox(
                  height: 10,
                ),
                _correctPercentageTotal != -1
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 3),
                        decoration: BoxDecoration(
                            color: _correctPercentageTotal > 60
                                ? customButtonColor.withOpacity(0.3)
                                : Colors.red.withOpacity(0.3),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            border: Border.all(
                                style: BorderStyle.solid,
                                color: customButtonColor)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Correctly pronounced: ${_correctPercentageTotal.round().toString()} %",
                              style: GoogleFonts.jost(
                                  textStyle: TextStyle(
                                      color: _correctPercentageTotal > 60
                                          ? Colors.black38
                                          : Colors.white)),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              _correctPercentageTotal > 60
                                  ? FontAwesomeIcons.faceSmileWink
                                  : FontAwesomeIcons.faceSadTear,
                              color: _correctPercentageTotal > 60
                                  ? Colors.black38
                                  : Colors.white,
                            )
                          ],
                        ),
                      )
                    : const SizedBox(),
                widget.singleMessageViewModel.isTextTranslated
                    ? Text(
                        widget.singleMessageViewModel.translatedMessageContent,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.jost(
                            textStyle: const TextStyle(
                                fontSize: 13, color: Colors.black54)))
                    : const SizedBox(),
                const SizedBox(
                  height: 10,
                ),
                _hasAttempted
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _hasAttempted = false;
                              widget.recordViewModel.completeSpeech.clear();
                              widget.recordViewModel.controllerViewModel
                                  .textController
                                  .clear();
                              _correctPercentageTotal = -1;
                              _correctlyPronouncedElements.clear();
                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  color: primaryPurpleColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 1,
                                        spreadRadius: 1,
                                        color: Colors.black12)
                                  ]),
                              child: Row(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.arrowsRotate,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Try again?',
                                    style: GoogleFonts.jost(
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  color: primaryPurpleColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 1,
                                        spreadRadius: 1,
                                        color: Colors.black12)
                                  ]),
                              child: Row(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.message,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Continue',
                                    style: GoogleFonts.jost(
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    : RecordButton(
                        isChatCompleted: widget.isChatCompleted,
                        voidCallback: _update,
                        recordViewModel: widget.recordViewModel,
                        size: 45,
                        color: primaryPurpleColor,
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SingleColoredWordInHintsModal extends StatefulWidget {
  final String word;
  final bool isWordPronounced;
  const SingleColoredWordInHintsModal({
    super.key,
    required this.word,
    required this.isWordPronounced,
  });

  @override
  State<SingleColoredWordInHintsModal> createState() =>
      _SingleColoredWordInHintsModalState();
}

class _SingleColoredWordInHintsModalState
    extends State<SingleColoredWordInHintsModal> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = ColorTween(begin: lightGreyTextColor, end: customGreenColor)
        .animate(_animationController);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SingleColoredWordInHintsModal oldWidget) {
    if (oldWidget.isWordPronounced != widget.isWordPronounced) {
      if (widget.isWordPronounced) {
        _animationController.forward();
      } else if (!widget.isWordPronounced) {
        _animationController.reset();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              widget.word,
              style: GoogleFonts.kalnia(
                  textStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: _animation.value,
                fontSize: 20,
                wordSpacing: 2,
              )),
            ),
          );
        });
  }
}

class TasksSubModal extends StatelessWidget {
  final TasksCompletedViewModel tasksCompletedViewModel;
  const TasksSubModal({super.key, required this.tasksCompletedViewModel});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: tasksCompletedViewModel.tasksCompletionMapsList.length,
          itemBuilder: (context, i) => Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 16,
                      backgroundColor: tasksCompletedViewModel
                                  .tasksCompletionMapsList[i]["completed"] ==
                              true
                          ? customGreenColor
                          : lightGreyTextColor,
                      child: const Icon(
                        FontAwesomeIcons.check,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                    title: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: (tasksCompletedViewModel
                                          .tasksCompletionMapsList[i]["type"]
                                      as QuestionScenarioTypeOptions) ==
                                  QuestionScenarioTypeOptions.inquiry
                              ? "Ask question: "
                              : "Type answer: ",
                          style: GoogleFonts.jost(
                              textStyle: const TextStyle(
                                  fontSize: 14,
                                  color: primaryPurpleColor,
                                  fontWeight: FontWeight.w600))),
                      TextSpan(
                          text: tasksCompletedViewModel
                              .tasksCompletionMapsList[i]["visibleTask"],
                          style: GoogleFonts.jost(
                              textStyle: const TextStyle(
                                  fontSize: 14, color: Colors.black)))
                    ])),
                    trailing: (tasksCompletedViewModel
                                        .tasksCompletionMapsList[i]["type"]
                                    as QuestionScenarioTypeOptions) ==
                                QuestionScenarioTypeOptions.response &&
                            !tasksCompletedViewModel.tasksCompletionMapsList[i]
                                ["completed"]
                        ? GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                        child: TaskResponseTypeCompleteWindow(
                                          index: i,
                                          voidCallback: (index) {
                                            tasksCompletedViewModel
                                                .toggleProgress();
                                            tasksCompletedViewModel
                                                .completeManuallyTask(index);
                                          },
                                          question: tasksCompletedViewModel
                                                  .tasksCompletionMapsList[i]
                                              ["visibleTask"],
                                          answer: tasksCompletedViewModel
                                                  .tasksCompletionMapsList[i]
                                              ["answer"],
                                        ),
                                      ));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: semiGreyColor,
                                  border: Border.all(
                                      style: BorderStyle.solid,
                                      color: Colors.black12)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Type'.toUpperCase(),
                                    style: GoogleFonts.jost(
                                        color: lightGreyTextColor,
                                        letterSpacing: 2),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(
                                    Icons.keyboard_double_arrow_right,
                                    color: lightGreyTextColor,
                                  )
                                ],
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const Divider()
                ],
              )),
    );
  }
}

class TaskResponseTypeCompleteWindow extends StatefulWidget {
  const TaskResponseTypeCompleteWindow({
    required this.question,
    required this.answer,
    required this.voidCallback,
    required this.index,
    super.key,
  });
  final String question;
  final int index;
  final String answer;
  final Function(int) voidCallback;

  @override
  State<TaskResponseTypeCompleteWindow> createState() =>
      _TaskResponseTypeCompleteWindowState();
}

class _TaskResponseTypeCompleteWindowState
    extends State<TaskResponseTypeCompleteWindow>
    with SingleTickerProviderStateMixin {
  late List<TextEditingController> _textEditingControllersList;
  late List<FocusNode> _focusNodesList;
  late AnimationController _animationController;
  bool _isAnswerCorrect = false;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..addListener(() => setState(() {}));
    _textEditingControllersList = List.generate(
        widget.answer.split('').length, (int index) => TextEditingController());
    _focusNodesList = List.generate(
        widget.answer.split('').length, (int index) => FocusNode());
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.question,
                  style: GoogleFonts.jost(
                    color: Colors.black,
                    fontWeight: FontWeight.w200,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      widget.answer.split('').length,
                      (int index) => Container(
                            width: 30,
                            height: 40,
                            margin: EdgeInsets.only(left: index != 0 ? 10 : 0),
                            child: TextField(
                              onChanged: (value) {
                                if (value.isNotEmpty &&
                                    index !=
                                        widget.answer.split('').length - 1) {
                                  FocusScope.of(context)
                                      .requestFocus(_focusNodesList[index + 1]);
                                }
                              },
                              controller: _textEditingControllersList[index],
                              focusNode: _focusNodesList[index],
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1)
                              ],
                              scrollPadding: const EdgeInsets.all(0),
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 10),
                                  filled: true,
                                  fillColor:
                                      lightGreyTextColor.withOpacity(0.3),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          style: BorderStyle.solid,
                                          color: Colors.white))),
                            ),
                          )),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    final String typedAnswer = _textEditingControllersList
                        .map((element) => element.text)
                        .toList()
                        .join('');
                    if (typedAnswer == widget.answer) {
                      _isAnswerCorrect = true;
                      _animationController.forward().whenComplete(() {
                        Future.delayed(const Duration(seconds: 1), () {
                          widget.voidCallback(widget.index);
                          Navigator.of(context).pop();
                          _animationController.reset();
                        });
                      });
                    } else {
                      _animationController
                          .forward()
                          .whenComplete(() => _animationController.reset());
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                        color: customButtonColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                            style: BorderStyle.solid, color: Colors.black12)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'TRY',
                          style: GoogleFonts.jost(
                              color: lightGreyTextColor, letterSpacing: 4),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.done_outline,
                          color: lightGreyTextColor,
                          size: 16,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              top: -2,
              right: -2,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )),
          Visibility(
            visible: _animationController.value == 0 ? false : true,
            child: Positioned.fill(
              child: Center(
                child: Lottie.asset(
                    _isAnswerCorrect
                        ? 'assets/animations/success.json'
                        : 'assets/animations/failure.json',
                    width: 150,
                    repeat: false,
                    controller: _animationController),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LanguageTranslateModal extends StatefulWidget {
  const LanguageTranslateModal({
    super.key,
  });

  @override
  State<LanguageTranslateModal> createState() => _LanguageTranslateModalState();
}

class _LanguageTranslateModalState extends State<LanguageTranslateModal> {
  final TextEditingController _translateFromController =
      TextEditingController();
  final TextEditingController _translateToController = TextEditingController();
  late SingleMessageViewModel _singleMessageViewModel;
  late GlobalUserViewModel _globalUserViewModel;

  @override
  void initState() {
    super.initState();

    _translateFromController.addListener(() async {
      if (_translateFromController.text.trim().isNotEmpty) {
        _singleMessageViewModel.translate(_translateFromController.text);
        _translateToController.text =
            _singleMessageViewModel.translatedMessageContent;
      }
    });
  }

  @override
  void didChangeDependencies() {
    _globalUserViewModel = Provider.of<GlobalUserViewModel>(context);
    _singleMessageViewModel =
        SingleMessageViewModel(globalUserViewModel: _globalUserViewModel);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();

    _translateFromController.dispose();
    _translateToController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 40,
            child: Row(
              children: [
                CountryFlag.fromCountryCode(
                  _globalUserViewModel.targetLanguage.countryCode.toLowerCase(),
                  width: 30,
                  height: 30,
                  shape: const Circle(),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: TextFormField(
                  controller: _translateFromController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 0.6,
                              color: Colors.black38))),
                )),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 40,
            width: double.infinity,
            child: IconButton(
              icon: const Icon(
                Icons.compare_arrows_outlined,
                color: customGreenColor,
              ),
              onPressed: () {},
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 40,
            child: Row(
              children: [
                CountryFlag.fromCountryCode(
                  _globalUserViewModel.translationLanguage.countryCode
                      .toLowerCase(),
                  width: 30,
                  height: 30,
                  shape: const Circle(),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: TextFormField(
                  controller: _translateToController,
                  readOnly: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 0.6,
                              color: Colors.black38))),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
