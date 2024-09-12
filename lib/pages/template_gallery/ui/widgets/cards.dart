import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sound/pages/new_chat_screen.dart';
import 'package:sound/pages/template_gallery/ui/widgets/animated_icon_button.dart';
import 'package:sound/utils/colors.dart';
import 'package:sound/utils/transform_list.dart';

class ContactCard extends StatelessWidget {
  const ContactCard(
      {super.key,
      required this.voidCallback,
      required this.gradientColors,
      required this.title,
      required this.descr,
      required this.cardIndex,
      required this.level,
      required this.circleColor,
      required this.image,
      required this.scenarioType,
      required this.isOpened});

  final VoidCallback voidCallback;
  final ChatDifficultLevels level;
  final List<Color> gradientColors;
  final String title;
  final String descr;
  final Color circleColor;
  final String image;
  final bool isOpened;
  final int cardIndex;
  final ScenarioTypes scenarioType;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                                color: customButtonColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 1,
                                      spreadRadius: 1,
                                      offset: Offset(0, 2))
                                ]),
                            child: Icon(
                              scenarioType.icon,
                              size: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 5),
                            decoration: BoxDecoration(
                                color: level.color,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black12,
                                      spreadRadius: 1.0,
                                      blurRadius: 1.0,
                                      offset: Offset(0, 1))
                                ]),
                            child: Text(
                              level.level,
                              style: GoogleFonts.jost(
                                  textStyle: TextStyle(
                                      color: level ==
                                              ChatDifficultLevels.intermediate
                                          ? lightGreyTextColor
                                          : Colors.white,
                                      letterSpacing: 5)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        title,
                        style: GoogleFonts.amiri(
                            textStyle: const TextStyle(
                          fontSize: 20,
                        )),
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 0.1,
                      ),
                      Stack(
                        children: [
                          AnimatedOpacity(
                            opacity: isOpened ? 0 : 1,
                            duration: const Duration(milliseconds: 150),
                            child: Text(
                              descr,
                              style: GoogleFonts.jost(color: Colors.black54),
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: isOpened ? 1 : 0,
                            duration: const Duration(milliseconds: 150),
                            child: AnimatedIconButton(
                                title: 'Start Conversation',
                                nextPage: NewChatScreen(
                                  cardIndex: cardIndex,
                                  scenarioType: scenarioType,
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                // Container(
                //   height: 100,
                //   width: 100.0,
                //   padding: const EdgeInsets.all(5),
                //   decoration: BoxDecoration(
                //       image: const DecorationImage(
                //           image: AssetImage('assets/images/cafe1.png')),
                //       border: Border.all(
                //           style: BorderStyle.solid,
                //           color: Colors.white.withOpacity(0.2)),
                //       shape: BoxShape.circle,
                //       color: circleColor),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
