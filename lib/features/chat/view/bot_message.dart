import 'dart:io';
import 'dart:typed_data';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sound/features/chat/view/user_message.dart';
import 'package:sound/features/chat/view_model/global_chat_settings_view_model.dart';
import 'package:sound/features/chat/view_model/global_user_view_model.dart';
import 'package:sound/features/chat/view_model/messages_view_model.dart';
import 'package:sound/utils/colors.dart';
import 'package:voice_message_package/voice_message_package.dart';

class BotMessage extends StatefulWidget {
  final String originalMessage;
  final GlobalKey messageKey;
  final bool isNewMessageLoading;
  final List<String> paragraphs;
  final Uint8List audioBytes;
  final Function(File) callback;
  final bool isLast;
  final bool isStreamStart;

  const BotMessage(
      {super.key,
      required this.messageKey,
      required this.isNewMessageLoading,
      required this.originalMessage,
      required this.callback,
      required this.audioBytes,
      required this.paragraphs,
      required this.isLast,
      required this.isStreamStart});

  @override
  State<BotMessage> createState() => _BotMessageState();
}

class _BotMessageState extends State<BotMessage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  final AudioPlayer audioPlayer = AudioPlayer();
  final FlutterSoundPlayer _myPlayer = FlutterSoundPlayer();
  final PlayerController _audioController = PlayerController();

  late SingleMessageViewModel _singleMessageViewModel;

  late bool _localMessageLoading;
  String _newChosenWord = '';
  late File _currentFile;
  final String _filePath = '';
  bool _mPlayerIsInited = false;

  OverlayEntry? _previousOverlayEntry;

  @override
  void didChangeDependencies() {
    GlobalUserViewModel globalUserViewModel =
        Provider.of<GlobalUserViewModel>(context);
    _singleMessageViewModel =
        SingleMessageViewModel(globalUserViewModel: globalUserViewModel);
    super.didChangeDependencies();
  }

  void _setNewOverlayEntry(OverlayEntry entry, String newChosenWord) {
    if (_previousOverlayEntry != null && _previousOverlayEntry!.mounted) {
      _previousOverlayEntry!.remove();
    }
    _newChosenWord = newChosenWord;
    update();
    _previousOverlayEntry = entry;
  }

  void _previousOverlayEntryClose() {
    if (_previousOverlayEntry != null && _previousOverlayEntry!.mounted) {
      _previousOverlayEntry!.remove();
    }
  }

  void update() => setState(() {});

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _localMessageLoading = widget.originalMessage == '';
    _fileCreation();
    _myPlayer.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    super.initState();
  }

  @override
  void didUpdateWidget(covariant BotMessage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // if (widget.audioBytes != oldWidget.audioBytes) {
    //   if (widget.audioBytes.isNotEmpty) {
    //     _fileWriteAsBytes();
    //     update();
    //   }
    // }
    if (widget.originalMessage != oldWidget.originalMessage) {
      _localMessageLoading = false;
      update();
    }
    // if (widget.isStreamStart != oldWidget.isStreamStart) {
    //   if (widget.audioBytes.isNotEmpty && widget.isStreamStart) {
    //     _localMessageLoading = false;
    //     update();
    //   }
    // }
  }

  void _fileWriteAsBytes() async {
    await _currentFile.writeAsBytes(widget.audioBytes);
    if (_currentFile.existsSync() && _filePath.isNotEmpty) {
      widget.callback(_currentFile);
    }
  }

  void _audioPlay() async {
    // if (_currentFile.existsSync() && _filePath.isNotEmpty && _mPlayerIsInited) {
    //   await _myPlayer.startPlayer(
    //       fromURI: _filePath,
    //       codec: Codec.pcm16,
    //       whenFinished: () {
    //         update();
    //       });
    // }
  }

  void _fileCreation() async {
    // final Directory directory = await getApplicationDocumentsDirectory();
    // final DateTime dateTime = DateTime.now();
    // _filePath = '${directory.path}/temp_audio_$dateTime.mp3';
    // _currentFile = File(_filePath);
  }

  @override
  void dispose() {
    _singleMessageViewModel.removeListener(update);
    _animationController.dispose();
    _previousOverlayEntry?.remove();
    _myPlayer.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: customButtonColor,
            child: Image.asset('assets/images/chatbot.png'),
          ),
          const SizedBox(width: 10),
          _localMessageLoading
              ? Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(25),
                    ),
                    color: customButtonColor,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, i) => AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        _animation = Tween<Offset>(
                          begin: Offset.zero,
                          end: Offset(0, (-10 / (i + 1))),
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeInOut,
                          ),
                        );
                        return Transform.translate(
                          offset: _animation.value,
                          child: Container(
                            margin: const EdgeInsets.only(left: 5),
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Container(
                  constraints: const BoxConstraints(maxWidth: 250),
                  decoration: const BoxDecoration(
                    color: customButtonColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    children: [
                      Consumer<GlobalChatSettingsViewModel>(
                          builder: (context, globalSettings, child) {
                        return globalSettings.isAudioModeOnly
                            ? Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: VoiceMessageView(
                                  backgroundColor: customButtonColor,
                                  circlesColor: customGreenColor,
                                  activeSliderColor: customGreenColor,
                                  controller: VoiceController(
                                      onComplete: () {},
                                      onPause: () {},
                                      onPlaying: () {},
                                      audioSrc: _currentFile.path,
                                      maxDuration: const Duration(seconds: 10),
                                      isFile: true),
                                ))
                            : Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: _singleMessageViewModel.isTextTranslated
                                    ? Text(_singleMessageViewModel
                                        .translatedMessageContent)
                                    : Consumer<GlobalChatSettingsViewModel>(
                                        builder:
                                            (context, globalSettings, child) {
                                          if (globalSettings
                                              .isEachWordTranslationActive) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: widget.paragraphs
                                                  .map((paragraph) {
                                                List<String> words =
                                                    paragraph.split(' ');
                                                return Wrap(
                                                  children: words.map((word) {
                                                    return SingleWordElement(
                                                      singleMessageViewModel:
                                                          _singleMessageViewModel,
                                                      voidCallback:
                                                          _previousOverlayEntryClose,
                                                      setOverlayEntry:
                                                          _setNewOverlayEntry,
                                                      word: word,
                                                      newChosenWord:
                                                          _newChosenWord,
                                                    );
                                                  }).toList(),
                                                );
                                              }).toList(),
                                            );
                                          } else {
                                            return Text(widget.originalMessage);
                                          }
                                        },
                                      ),
                              );
                      }),
                      Container(
                        alignment: Alignment.topCenter,
                        child: const Divider(
                          thickness: 0.8,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SpinningTranslateButton(
                              singleMessageViewModel: _singleMessageViewModel,
                              message: widget.originalMessage,
                            ),
                            IconButton(
                                onPressed: () async {
                                  _audioPlay();
                                },
                                icon: const Icon(
                                  Icons.volume_up_outlined,
                                ))
                          ],
                        ),
                      ),
                    ],
                  ))
        ],
      ),
    );
  }
}

class SingleWordElement extends StatefulWidget {
  final String word;
  final String newChosenWord;
  final Function(OverlayEntry, String) setOverlayEntry;
  final VoidCallback voidCallback;
  final SingleMessageViewModel singleMessageViewModel;
  const SingleWordElement({
    super.key,
    required this.word,
    required this.singleMessageViewModel,
    required this.newChosenWord,
    required this.voidCallback,
    required this.setOverlayEntry,
  });

  @override
  State<SingleWordElement> createState() => _SingleWordElementState();
}

class _SingleWordElementState extends State<SingleWordElement> {
  final LayerLink link = LayerLink();
  late SingleMessageViewModel _singleMessageViewModel;

  late OverlayEntry overlayEntry;
  bool _chosenWord = false;

  final RegExp nonLetterPattern = RegExp(r'[^a-zA-Z]');

  @override
  void didUpdateWidget(covariant SingleWordElement oldWidget) {
    if (widget.newChosenWord != widget.word) {
      _chosenWord = false;
    }
    super.didUpdateWidget(oldWidget);
  }

  void _showOverlay(String word, LayerLink link) {
    overlayEntry = OverlayEntry(
      builder: (context) {
        return CompositedTransformFollower(
          targetAnchor: Alignment.center,
          followerAnchor: Alignment.topCenter,
          link: link,
          showWhenUnlinked: false,
          offset: const Offset(0, -90),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 1.0,
                        blurRadius: 1.0,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                  child: _singleMessageViewModel.isLoading
                      ? Transform.scale(
                          scale: 0.6,
                          child: const CircularProgressIndicator(
                            color: primaryPurpleColor,
                          ),
                        )
                      : Stack(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'In context of translation: ',
                                      style: GoogleFonts.jost(
                                          textStyle: const TextStyle(
                                              color: lightGreyTextColor)),
                                    ),
                                    Text(_singleMessageViewModel
                                        .translatedMessageContent)
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {
                                      print('clicked2');
                                    },
                                    icon: const Icon(
                                      Icons.volume_up,
                                      color: Colors.black45,
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            Positioned(
                              top: -20,
                              right: -20,
                              child: IconButton(
                                iconSize: 16,
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  widget.voidCallback();
                                  setState(() {});
                                  _chosenWord = false;
                                },
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(overlayEntry);
    widget.setOverlayEntry(overlayEntry, widget.word);

    // Start translation
    _startTranslation(word, link);
  }

  void _startTranslation(String word, LayerLink link) async {
    String cleanWord = word.replaceAll(nonLetterPattern, '');
    await _singleMessageViewModel.translate(cleanWord);
    overlayEntry.markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: link,
      child: GestureDetector(
        onTap: () {
          _chosenWord ? widget.voidCallback() : _showOverlay(widget.word, link);
          setState(() {});
          _chosenWord = !_chosenWord;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Text(widget.word,
              style: GoogleFonts.jost(
                textStyle: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor:
                        _chosenWord ? customGreenColor : Colors.black,
                    color: _chosenWord ? customGreenColor : Colors.black),
              )),
        ),
      ),
    );
  }
}
