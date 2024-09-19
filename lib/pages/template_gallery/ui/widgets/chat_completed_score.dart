import 'package:flutter/material.dart';
import 'package:flutter_gradient_text/flutter_gradient_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sound/pages/entry_point.dart';
import 'package:sound/pages/new_chat_screen.dart';
import 'package:sound/pages/score_page.dart';
import 'package:sound/pages/template_gallery/ui/widgets/custom_page_route_build.dart';
import 'package:sound/utils/colors.dart';
import 'package:sound/utils/transform_list.dart';

class ChatCompletedScore extends StatefulWidget {
  const ChatCompletedScore(
      {super.key,
      required this.accuracy,
      required this.tasksCompletionScore,
      this.scenarioType = ScenarioTypes.question,
      required this.engagementScore,
      this.correctGuess = 0,
      this.overallScore = 0,
      required this.cardIndex,
      required this.chatDifficultLevel,
      required this.responsivenessRate});
  final double accuracy;
  final double engagementScore;
  final double responsivenessRate;
  final double tasksCompletionScore;
  final double overallScore;
  final ScenarioTypes scenarioType;
  final int correctGuess;
  final int cardIndex;
  final ChatDifficultLevels chatDifficultLevel;

  @override
  State<ChatCompletedScore> createState() => _ChatCompletedScoreState();
}

enum Scores { veryLow, low, good, high, veryHigh }

extension ScoresData on Scores {
  String get scoresInfo {
    switch (this) {
      case Scores.veryLow:
        return "Very Low";
      case Scores.low:
        return "Low";
      case Scores.good:
        return "Good";
      case Scores.high:
        return "Very High";
      case Scores.veryHigh:
        return "High";
      default:
        return "Good";
    }
  }

  Color get scoresColor {
    switch (this) {
      case Scores.veryLow:
        return Colors.redAccent;
      case Scores.low:
        return Colors.red;
      case Scores.good:
        return Colors.amber;
      case Scores.high:
        return Colors.green;
      case Scores.veryHigh:
        return Colors.greenAccent;
      default:
        return Colors.amber;
    }
  }
}

class _ChatCompletedScoreState extends State<ChatCompletedScore>
    with SingleTickerProviderStateMixin {
  final int _selectedIndex = 0;
  final List<String> _tabs = ["Overall", "Details"];
  final _marks = ['0', '300', '600', '1000'];
  List _allScores = [];
  late AnimationController _controller;
  late Animation<double> _animationOverall;
  double? _overallScore = 0;

  final List<Animation<double>> _animationScoresList = [];
  final List<String> _descr = [
    "Speaking Accuracy Score",
    "Task Completion Score",
    "Engagement ",
    "Responsiveness Rate"
  ];
  double calculateOverallScore({
    double accuracyWeight = 0.4,
    double responsivenessWeight = 0.3,
    double taskCompletionWeight = 0.2,
    double engagementWeight = 0.1,
  }) {
    double accuracyScore = widget.accuracy;
    double responsivenessScore = widget.responsivenessRate;
    double taskCompletionScore = widget.tasksCompletionScore;
    double engagementScore = widget.engagementScore;

    double weightedSum = (accuracyScore * accuracyWeight) +
        (responsivenessScore * responsivenessWeight) +
        (taskCompletionScore * taskCompletionWeight) +
        (engagementScore * engagementWeight);
    return weightedSum * 10;
  }

  @override
  void initState() {
    _allScores = [
      widget.accuracy,
      widget.tasksCompletionScore,
      widget.engagementScore,
      widget.responsivenessRate
    ];

    _overallScore = widget.scenarioType == ScenarioTypes.question
        ? calculateOverallScore()
        : widget.correctGuess.toDouble();

    if (_overallScore != null) {
      _controller =
          AnimationController(vsync: this, duration: const Duration(seconds: 3))
            ..forward();
      _animationOverall = Tween<double>(begin: 0, end: _overallScore).animate(
          CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    for (double score in _allScores) {
      final Animation<double> animationScore =
          Tween<double>(begin: 0, end: score).animate(
              CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));
      _animationScoresList.add(animationScore);
    }
    super.didChangeDependencies();
  }

  String customToFloorAndToString(double value) {
    var splittedElements = value.toString().split('');
    if (splittedElements.any((element) => element == '.')) {
      splittedElements.removeRange(
          splittedElements.indexOf('.'), splittedElements.length);
      return splittedElements.join('');
    } else {
      return value.toString();
    }
  }

  Scores getScoresEnum(double score) {
    if (score < 20) {
      return Scores.veryLow;
    } else if (score < 40) {
      return Scores.low;
    } else if (score < 60) {
      return Scores.good;
    } else if (score < 80) {
      return Scores.high;
    } else if (score < 100) {
      return Scores.veryHigh;
    }
    return Scores.good;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              color: backgroundColor, // Lighter background for harmony
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.scenarioType == ScenarioTypes.question
                        ? 'Successfully Completed!'
                        : 'Card Finished!',
                    style: GoogleFonts.jost(
                      textStyle: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                GradientText(
                  Text(
                    customToFloorAndToString(_animationOverall.value),
                    style: GoogleFonts.jost(
                      textStyle: const TextStyle(
                          fontSize: 68, fontWeight: FontWeight.w300),
                    ),
                  ),
                  colors: const [
                    primaryPurpleColor,
                    customGreenColor
                  ], // Simplified gradient
                  stops: const [0.5, 1.0],
                ),
                widget.scenarioType == ScenarioTypes.question
                    ? Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 30,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                gradient: LinearGradient(stops: [
                                  0.3,
                                  0.6,
                                  0.8
                                ], colors: [
                                  customButtonColor,
                                  primaryPurpleColor,
                                  customGreenColor,
                                ])),
                          ),
                          Positioned(
                              left: _animationOverall.value * 0.38,
                              child: SizedBox(
                                height: 50,
                                child: Column(
                                  children: [
                                    const TriangleWidget(
                                        size: 10,
                                        color: Colors.white,
                                        side: TrianglePointDirection.down),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const TriangleWidget(
                                        size: 10,
                                        color: Colors.white,
                                        side: TrianglePointDirection.up),
                                  ],
                                ),
                              ))
                        ],
                      )
                    : const SizedBox.shrink(),
                const SizedBox(
                  height: 10,
                ),
                widget.scenarioType == ScenarioTypes.question
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _marks
                            .map((element) => Text(
                                  element,
                                  style: GoogleFonts.jost(
                                      textStyle: const TextStyle(
                                          color: primaryPurpleColor)),
                                ))
                            .toList(),
                      )
                    : const SizedBox.shrink(),
                widget.scenarioType == ScenarioTypes.question
                    ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              style: BorderStyle.solid, color: Colors.black12),
                          borderRadius: BorderRadius.circular(15),
                          color: semiGreyColor, // Softer container background
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _descr.length,
                          itemBuilder: (context, index) {
                            var score = index < 2
                                ? _animationScoresList[index].value
                                : getScoresEnum(
                                    _animationScoresList[index].value);
                            bool isEnum = score is Scores;
                            Scores? scoreEnum;
                            if (isEnum) {
                              scoreEnum = score;
                            }
                            return ListTile(
                              minTileHeight: 30,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              leading: const Icon(Icons.done_all,
                                  color: customGreenColor), // Added icon
                              title: Text(
                                _descr[index],
                                style: GoogleFonts.jost(
                                  textStyle: const TextStyle(
                                      color: Colors.black87, fontSize: 13),
                                ),
                              ),
                              trailing: Text(
                                !isEnum
                                    ? "${(score as double).floor()}%"
                                    : scoreEnum!.scoresInfo,
                                style: GoogleFonts.jost(
                                  textStyle: TextStyle(
                                      fontSize: 14,
                                      color: !isEnum && score as double < 50
                                          ? Colors.red
                                          : !isEnum && score as double > 50
                                              ? customGreenColor
                                              : scoreEnum!.scoresColor),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
                SizedBox(
                  height:
                      widget.scenarioType == ScenarioTypes.question ? 10 : 0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(customPageRouteBuild(const EntryPoint()));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: customButtonColor,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                  color: semiGreyColor,
                                  offset: Offset(0, 2))
                            ]),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.keyboard_double_arrow_left_outlined,
                              color: lightGreyTextColor,
                            ),
                            Text(
                              'Go back to Main',
                              style:
                                  GoogleFonts.jost(color: lightGreyTextColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            customPageRouteBuild(NewChatScreen(
                                cardIndex: widget.cardIndex,
                                scenarioType: widget.scenarioType,
                                chatDifficultLevel:
                                    widget.chatDifficultLevel)));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              style: BorderStyle.solid, color: Colors.black12),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Iconsax.activity,
                              color: lightGreyTextColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.scenarioType == ScenarioTypes.question
                                  ? 'See Details'
                                  : 'Try Again',
                              style:
                                  GoogleFonts.jost(color: lightGreyTextColor),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
  }
}
