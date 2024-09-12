import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:sound/features/chat/view_model/global_chat_settings_view_model.dart';
import 'package:sound/features/chat/view_model/global_user_view_model.dart';
import 'package:sound/features/chat/view_model/messages_view_model.dart';
import 'package:sound/utils/colors.dart';

class UserMessage extends StatefulWidget {
  final String message;
  final GlobalKey messageKey;
  final String? mistakes;
  final bool? isCorrect;
  const UserMessage(
      {super.key,
      required this.message,
      required this.messageKey,
      this.isCorrect,
      this.mistakes});

  @override
  State<UserMessage> createState() => _UserMessageState();
}

class _UserMessageState extends State<UserMessage> {
  late SingleMessageViewModel _singleMessageViewModel;
  bool _openMistakeSubWindow = false;

  void _update() => setState(() {});

  @override
  void didChangeDependencies() {
    GlobalUserViewModel globalUserViewModel =
        Provider.of<GlobalUserViewModel>(context);
    _singleMessageViewModel =
        SingleMessageViewModel(globalUserViewModel: globalUserViewModel);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _singleMessageViewModel.removeListener(_update);
  }

  @override
  Widget build(BuildContext context) {
    final globalSettings = Provider.of<GlobalChatSettingsViewModel>(context);
    return Padding(
      // key: widget.messageKey,
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(188, 196, 255, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    _singleMessageViewModel.isTextTranslated
                        ? _singleMessageViewModel.translatedMessageContent
                        : widget.message,
                    style: GoogleFonts.jost(),
                  ),
                ),
                Container(
                    alignment: Alignment.centerRight,
                    child: SpinningTranslateButton(
                      singleMessageViewModel: _singleMessageViewModel,
                      message: widget.message,
                    )),
                widget.mistakes != null &&
                        widget.isCorrect != null &&
                        globalSettings.isShowCorrectionAlwaysOn
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: widget.isCorrect! ? 10 : 0),
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromRGBO(188, 196, 255, 1),
                                  Colors.white
                                ]),
                            boxShadow: [
                              BoxShadow(
                                  color: lightGreyTextColor,
                                  spreadRadius: 0.2,
                                  blurRadius: 1)
                            ],
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25))),
                        width: 250,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Row(
                                  children: [
                                    Icon(
                                      widget.isCorrect!
                                          ? FontAwesomeIcons.checkDouble
                                          : FontAwesomeIcons.check,
                                      size: 20,
                                      color: widget.isCorrect!
                                          ? Colors.greenAccent
                                          : lightGreyTextColor,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      widget.isCorrect!
                                          ? 'Exellent!'
                                          : _openMistakeSubWindow
                                              ? "Did you want to say this?"
                                              : 'Suggestion',
                                      style: GoogleFonts.jost(
                                          textStyle:
                                              const TextStyle(fontSize: 12)),
                                    )
                                  ],
                                )),
                                widget.isCorrect!
                                    ? const SizedBox()
                                    : IconButton(
                                        onPressed: () {
                                          _openMistakeSubWindow =
                                              !_openMistakeSubWindow;
                                          _update();
                                        },
                                        icon: Icon(
                                          _openMistakeSubWindow
                                              ? Icons.keyboard_arrow_up_outlined
                                              : Icons
                                                  .keyboard_arrow_down_outlined,
                                          size: 25,
                                        ),
                                      )
                              ],
                            ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            widget.mistakes != null && _openMistakeSubWindow
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      widget.mistakes!,
                                      style: GoogleFonts.jost(
                                          textStyle:
                                              const TextStyle(fontSize: 12)),
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 20,
            backgroundColor: primaryPurpleColor,
            child: Image.asset('assets/images/abstract_avatar.png', width: 20),
          ),
        ],
      ),
    );
  }
}

class SpinningTranslateButton extends StatefulWidget {
  final SingleMessageViewModel singleMessageViewModel;
  final String message;
  final double size;
  final Color color;
  const SpinningTranslateButton(
      {super.key,
      required this.singleMessageViewModel,
      required this.message,
      this.color = Colors.black,
      this.size = 20});

  @override
  State<SpinningTranslateButton> createState() =>
      _SpinningTranslateButtonState();
}

class _SpinningTranslateButtonState extends State<SpinningTranslateButton>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  final double pi = 3.14;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
    super.initState();
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
      builder: (context, child) => Transform.rotate(
        angle: _animation.value * 2 * pi,
        child: IconButton(
          splashRadius: 20,
          highlightColor: customGreenColor,
          icon: Icon(
            Iconsax.translate,
            size: widget.size,
            color: widget.color,
          ),
          onPressed: () async {
            _animationController.repeat();
            await widget.singleMessageViewModel.translate(widget.message);
            _animationController.stop();
            // widget.voidCallback();
          },
        ),
      ),
    );
  }
}
