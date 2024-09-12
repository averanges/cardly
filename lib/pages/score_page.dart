import 'package:flutter/material.dart';
import 'package:flutter_gradient_text/flutter_gradient_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sound/pages/entry_point.dart';
import 'package:sound/utils/colors.dart';

enum TrianglePointDirection { down, up }

class ScoreScreen extends StatefulWidget {
  const ScoreScreen(
      {super.key,
      required this.accuracy,
      required this.tasksCompletionScore,
      required this.engagementScore,
      required this.overallScore,
      required this.responsivenessRate});
  final double accuracy;
  final double engagementScore;
  final double responsivenessRate;
  final double tasksCompletionScore;
  final double overallScore;

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
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

class _ScoreScreenState extends State<ScoreScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final List<String> _tabs = ["Overall", "Details"];
  final _marks = ['0', '300', '600', '1000'];
  List _allScores = [];
  late AnimationController _controller;
  late Animation<double> _animationOverall;

  final List<Animation<double>> _animationScoresList = [];
  final List<String> _descr = [
    "Speaking Accuracy Score",
    "Task Completion Score",
    "Engagement ",
    "Responsiveness Rate"
  ];

  @override
  void initState() {
    _allScores = [
      widget.accuracy,
      widget.tasksCompletionScore,
      widget.engagementScore,
      widget.responsivenessRate
    ];

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..forward();
    _animationOverall = Tween<double>(begin: 0, end: widget.overallScore)
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: AppBar(
                  backgroundColor: Colors.white,
                  actions: [
                    CircleAvatar(
                      backgroundColor: customButtonColor,
                      child: IconButton(
                        icon: const Icon(
                          Icons.exit_to_app_outlined,
                          color: Colors.black,
                          weight: 6,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EntryPoint()));
                        },
                      ),
                    ),
                    // const SizedBox(
                    //   width: 10,
                    // )
                  ],
                ),
              )),
          backgroundColor: Colors.white,
          body: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              alignment: Alignment.centerLeft,
                              child: Text('Your Score',
                                  style: GoogleFonts.jost(
                                      textStyle:
                                          const TextStyle(fontSize: 30))),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                padding: const EdgeInsets.all(5),
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      style: BorderStyle.solid,
                                      color: Colors.white.withOpacity(0.8)),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.white,
                                      spreadRadius: -8.0,
                                      blurRadius: 10.0,
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                  color: semiGreyColor,
                                ),
                                child: TabBar(
                                    onTap: (value) => setState(() {
                                          _selectedIndex = value;
                                        }),
                                    labelPadding: const EdgeInsets.all(0),
                                    padding: const EdgeInsets.all(0),
                                    dividerColor: semiGreyColor,
                                    indicatorColor: semiGreyColor,
                                    tabs: _tabs.asMap().entries.map(
                                      (entry) {
                                        int index =
                                            entry.key; // The index in the list
                                        String value = entry.value;
                                        return Tab(
                                          child: _selectedIndex == index
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  constraints:
                                                      const BoxConstraints
                                                          .expand(),
                                                  // margin:
                                                  //     const EdgeInsets.only(right: 10),
                                                  decoration: BoxDecoration(
                                                      color: customButtonColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            blurRadius: 1,
                                                            spreadRadius: 1)
                                                      ]),
                                                  child: Text(value,
                                                      style: GoogleFonts.jost(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  letterSpacing:
                                                                      5))),
                                                )
                                              : Text(
                                                  value,
                                                  style: GoogleFonts.jost(),
                                                ),
                                        );
                                      },
                                    ).toList())),
                            GradientText(
                              Text(
                                  customToFloorAndToString(
                                      _animationOverall.value),
                                  style: GoogleFonts.jost(
                                      textStyle: const TextStyle(
                                          fontSize: 120,
                                          fontWeight: FontWeight.w300))),
                              colors: const [
                                primaryPurpleColor,
                                Colors.blue,
                                customGreenColor
                              ],
                              stops: const [0.3, 0.6, 0.8],
                            ),
                            Column(
                              children: [
                                Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Overall Score',
                                      style: GoogleFonts.jost(
                                          textStyle: const TextStyle(
                                              color: primaryPurpleColor)),
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          gradient: LinearGradient(stops: [
                                            0.3,
                                            0.6,
                                            0.8
                                          ], colors: [
                                            primaryPurpleColor,
                                            Colors.blue,
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
                                                  side: TrianglePointDirection
                                                      .down),
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
                                                  side: TrianglePointDirection
                                                      .up),
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: _marks
                                      .map((element) => Text(
                                            element,
                                            style: GoogleFonts.jost(
                                                textStyle: const TextStyle(
                                                    color: primaryPurpleColor)),
                                          ))
                                      .toList(),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      style: BorderStyle.solid,
                                      color: Colors.black12)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  spreadRadius: -8.0,
                                  blurRadius: 10.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              color: semiGreyColor,
                            ),
                            child: ListView.builder(
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
                                    trailing: Text(
                                      !isEnum
                                          ? "${(score as double).floor()}%"
                                          : scoreEnum!.scoresInfo,
                                      style: GoogleFonts.jost(
                                          fontSize: 18,
                                          textStyle: TextStyle(
                                              color: !isEnum &&
                                                      score as double < 50
                                                  ? Colors.red
                                                  : !isEnum &&
                                                          score as double > 50
                                                      ? customGreenColor
                                                      : scoreEnum!
                                                          .scoresColor)),
                                    ),
                                    title: Text(
                                      _descr[index],
                                      style: GoogleFonts.jost(
                                          textStyle: const TextStyle(
                                              color: lightGreyTextColor,
                                              fontSize: 16)),
                                    ),
                                  );
                                })),
                      )
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  final TrianglePointDirection side;
  TriangleClipper({required this.side});

  @override
  Path getClip(Size size) {
    if (side == TrianglePointDirection.up) {
      Path path = Path()
        ..moveTo(size.width / 2, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      return path;
    } else {
      Path path = Path()
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width / 2, size.height)
        ..close();
      return path;
    }
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TriangleWidget extends StatelessWidget {
  final double size;
  final Color color;
  final TrianglePointDirection side;

  const TriangleWidget(
      {super.key, required this.size, required this.color, required this.side});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TriangleClipper(side: side),
      child: Container(
        width: size,
        height: size,
        color: color,
      ),
    );
  }
}
