import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:sound/features/chat/view_model/auth_view_model.dart';
import 'package:sound/features/chat/view_model/main_screen_view_model.dart';
import 'package:sound/generated/l10n.dart';
import 'package:sound/pages/template_gallery/ui/widgets/animated_gradient_text.dart';
import 'package:sound/pages/template_gallery/ui/widgets/cards.dart';
import 'package:sound/pages/template_gallery/ui/widgets/perspective_list_view.dart';
import 'package:sound/utils/colors.dart';
import 'package:sound/utils/convert_string_to_time.dart';
import 'package:sound/utils/transform_list.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    required this.toggleSideMenu,
    required this.isSideMenuOpened,
  });
  final VoidCallback toggleSideMenu;
  final bool isSideMenuOpened;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => MainScreenViewModel())
          ],
          child: SafeArea(
            child: Container(
                color: const Color(0xFF4A5367),
                child: MainScreenCardList(
                  toggleSideMenu: widget.toggleSideMenu,
                  isSideMenuOpened: widget.isSideMenuOpened,
                )),
          ),
        ),
      ),
    );
  }
}

class MainScreenCardList extends StatefulWidget {
  const MainScreenCardList({
    super.key,
    required this.toggleSideMenu,
    required this.isSideMenuOpened,
  });

  final VoidCallback toggleSideMenu;
  final bool isSideMenuOpened;

  @override
  State<MainScreenCardList> createState() => _MainScreenCardListState();
}

class _MainScreenCardListState extends State<MainScreenCardList>
    with TickerProviderStateMixin {
  final bool _isRotated = false;

  int get _number => _isRotated ? 1 : 6;
  bool translateAnimation = false;

  final bool _isCardChosen = false;
  int _cardChosenIndex = 0;

  late AnimationController _controller;
  late AnimationController _locaLcontroller;
  late Animation<Offset> _cardsAnimation;
  late Animation<double> _opacity;
  late Animation<double> _cardDetailsAnimation;
  late Animation<Color?> _backgroundColorAnimation;
  Color _endColor = Colors.lightBlue.withOpacity(0.9);
  int? _visibleItems;
  double? _itemExtent;

  late MainScreenViewModel mainScreenViewModel;

  final List<String> _filterDifficultiesList = [
    'Beginner',
    'Intermediate',
    'Advanced'
  ];

  final List<Color> _levelDifficultiesColorsList = [
    customGreenColor,
    customButtonColor,
    primaryPurpleColor
  ];
  @override
  void initState() {
    _visibleItems = 8;
    _itemExtent = 240.0;
    _locaLcontroller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    _opacity = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _setColorTween();
    super.initState();
  }

  void _setColorTween() {
    _backgroundColorAnimation = ColorTween(
      begin: backgroundColor,
      end: _endColor, // Dynamic end color
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didChangeDependencies() {
    mainScreenViewModel = Provider.of<MainScreenViewModel>(context);

    double height = MediaQuery.of(context).size.height;
    _cardDetailsAnimation = Tween<double>(begin: -height, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _cardsAnimation = Tween<Offset>(
            begin: Offset.zero, end: const Offset(0, -120))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut))
      ..addListener(() {
        if (!mainScreenViewModel.isOpened) {
          mainScreenViewModel.setIsOpened = true;
        }
        if (_cardsAnimation.status == AnimationStatus.reverse) {
          Timer(const Duration(milliseconds: 200),
              () => mainScreenViewModel.setIsOpened = false);
        }
        setState(() {});
      });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = Provider.of<AuthViewModel>(context);
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient:
                      RadialGradient(center: Alignment.topCenter, stops: const [
                    0.1,
                    1
                  ], colors: [
                    Colors.white,
                    _backgroundColorAnimation.value!,
                  ]),
                ),
                padding: const EdgeInsets.all(
                  10.0,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          minRadius: 20,
                          maxRadius: 25,
                          backgroundColor: customButtonColor,
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: IconButton(
                                icon: const Icon(Icons.sort),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              child: Stack(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          'Filter',
                                                          style: GoogleFonts.jost(
                                                              textStyle: const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Text('Difficulty Level',
                                                            style: GoogleFonts.jost(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color:
                                                                            lightGreyTextColor))),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        ConstrainedBox(
                                                          constraints:
                                                              const BoxConstraints(
                                                                  maxHeight:
                                                                      30),
                                                          child:
                                                              ListView.builder(
                                                                  itemCount:
                                                                      _filterDifficultiesList
                                                                          .length,
                                                                  scrollDirection:
                                                                      Axis
                                                                          .horizontal,
                                                                  itemBuilder:
                                                                      (context,
                                                                              index) =>
                                                                          Container(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            padding:
                                                                                const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                                                                            margin:
                                                                                const EdgeInsets.only(right: 10),
                                                                            decoration:
                                                                                BoxDecoration(color: _levelDifficultiesColorsList[index], borderRadius: const BorderRadius.all(Radius.circular(20))),
                                                                            child:
                                                                                Text(
                                                                              _filterDifficultiesList[index],
                                                                              style: GoogleFonts.jost(textStyle: const TextStyle(color: Colors.black)),
                                                                            ),
                                                                          )),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        icon: const Icon(
                                                            Icons.close)),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ));
                                },
                              )),
                        ),
                        Transform.scale(
                          scale: 2,
                          child: Image.asset(
                            'assets/images/cardly.png',
                            height: 50,
                          ),
                        ),
                        CircleAvatar(
                            minRadius: 20,
                            maxRadius: 25,
                            backgroundColor: customButtonColor,
                            child: IconButton(
                                onPressed: () {
                                  widget.toggleSideMenu();
                                },
                                icon: const Icon(
                                    Icons.settings_suggest_outlined)))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Opacity(
                      opacity: _opacity.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(left: 20, top: 30),
                              child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      style: GoogleFonts.amiri(
                                        textStyle: const TextStyle(
                                            fontSize: 45,
                                            color: Colors.black,
                                            height: 0.3),
                                      ),
                                      children: [
                                        TextSpan(
                                            text: S.of(context).mainSloganWord1,
                                            style: GoogleFonts.amiri()),
                                        const WidgetSpan(
                                            child: SizedBox(
                                          width: 10,
                                        )),
                                        TextSpan(
                                          style: GoogleFonts.amiri(
                                            textStyle: const TextStyle(
                                                color: lightGreyTextColor,
                                                fontStyle: FontStyle.italic),
                                          ),
                                          text: S.of(context).mainSloganWord2,
                                        ),
                                        const WidgetSpan(
                                            child: SizedBox(
                                          width: 20,
                                        )),
                                        TextSpan(
                                            text: S.of(context).mainSloganWord3,
                                            style: GoogleFonts.amiri()),
                                      ]))),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          AnimatedGradientText(
                            isVisible: true,
                            color: Colors.grey.withOpacity(0.1),
                            text: S
                                .of(context)
                                .clickOnCardToStartYourLearningJourney,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      // Use Expanded to fill the remaining space
                      child: Transform.translate(
                        offset: _cardsAnimation.value,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: GestureDetector(
                            // onVerticalDragStart: (details) {
                            //   setState(() {
                            //     _dragStartY = details.localPosition.dy;
                            //   });
                            // },
                            // onVerticalDragUpdate: (details) {
                            //   setState(() {
                            //     _dragEndY = details.localPosition.dy;
                            //   });
                            // },
                            // onVerticalDragEnd: (details) {
                            //   final dragDistance = _dragEndY - _dragStartY;
                            //   if (dragDistance.abs() > _dragThreshold) {
                            //     // _startAnimation();
                            //     setState(() {
                            //       if (dragDistance < 0) {
                            //         final first = transformListData.removeAt(0);
                            //         transformListData.add(first);
                            //       } else if (dragDistance > 0) {
                            //         final last = transformListData.removeLast();
                            //         transformListData.insert(0, last);
                            //       }
                            //     });
                            //   }
                            // },
                            child: PerspectiveListView(
                              isOpened: mainScreenViewModel.isOpened,
                              controller: _controller,
                              visualizedItems: _visibleItems,
                              itemExtent: _itemExtent,
                              initialIndex: transformListData.length - 1,
                              enableBackItemsShadow: true,
                              backItemsShadowColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              padding: const EdgeInsets.all(10),
                              onTapFrontItem: (index) {
                                if (index != null) {
                                  _cardChosenIndex = index;
                                  _endColor = (transformListData[index]
                                          ['colors'][1] as Color)
                                      .withOpacity(0.8);
                                  _setColorTween();
                                }
                                _controller.forward();
                              },
                              children: List.generate(transformListData.length,
                                  (index) {
                                return ContactCard(
                                  scenarioType: (transformListData[index]
                                      ['scenarioType'] as ScenarioTypes),
                                  level: transformListData[index]['level'],
                                  isOpened: mainScreenViewModel.isOpened,
                                  cardIndex: _cardChosenIndex,
                                  voidCallback: () {
                                    print(index);
                                  },
                                  gradientColors: transformListData[index]
                                      ['colors'],
                                  circleColor: transformListData[index]
                                      ['circleColor'],
                                  title: transformListData[index]['title'],
                                  image: transformListData[index]['imageIcon'],
                                  descr: transformListData[index]['descr'],
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CardDetailsPositionedScreen(
                index: _cardChosenIndex,
                controller: _controller,
                cardDetailsAnimation: _cardDetailsAnimation,
              )
            ],
          );
        });
  }
}

class CardDetailsPositionedScreen extends StatefulWidget {
  const CardDetailsPositionedScreen(
      {super.key,
      required this.cardDetailsAnimation,
      required this.index,
      required this.controller});
  final Animation<double> cardDetailsAnimation;

  final AnimationController controller;
  final int index;

  @override
  State<CardDetailsPositionedScreen> createState() =>
      _CardDetailsPositionedScreenState();
}

class _CardDetailsPositionedScreenState
    extends State<CardDetailsPositionedScreen>
    with SingleTickerProviderStateMixin {
  final int _dragThreshold = 100;
  double _dragStartY = 0.0;
  double _dragEndY = 0.0;
  Map<dynamic, dynamic> _cardData = {};

  final List<Map<String, dynamic>> _tabs = [
    {
      'title': "Card Description",
      'icon': Iconsax.card,
    },
    {
      'title': "Card Tasks",
      'icon': Iconsax.task,
    },
    {
      'title': "AI Personality",
      'icon': Icons.add_reaction_outlined,
    },
  ];

  @override
  void initState() {
    _cardData = transformListData[widget.index];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: widget.cardDetailsAnimation.value,
        left: 0,
        right: 0,
        child: GestureDetector(
            onVerticalDragStart: (details) {
              setState(() {
                _dragStartY = details.localPosition.dy;
              });
            },
            onVerticalDragUpdate: (details) {
              setState(() {
                _dragEndY = details.localPosition.dy;
              });
            },
            onVerticalDragEnd: (details) {
              final dragDistance = _dragEndY - _dragStartY;
              if (dragDistance.abs() > _dragThreshold) {
                widget.controller.reverse();
              }
            },
            child: ClipPath(
              clipper: CustomCardDetailsClipper(),
              child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                      gradient:
                          RadialGradient(center: Alignment.topCenter, colors: [
                        Colors.white,
                        backgroundColor,
                      ]),
                      color: backgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  height: 520,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Card Details',
                        style: GoogleFonts.jost(
                            fontSize: 25,
                            color: Colors.black54,
                            fontWeight: FontWeight.w300,
                            shadows: [
                              const Shadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, 2))
                            ],
                            letterSpacing: 2),
                      ),
                      const Divider(
                        thickness: 0.4,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                              blurRadius: 1,
                                              spreadRadius: 1,
                                              color: Colors.black12,
                                              offset: Offset(0, 1))
                                        ],
                                        shape: BoxShape.circle,
                                        color: transformListData[widget.index]
                                            ['colors'][1]),
                                    child: const Icon(
                                      Icons.timer,
                                      size: 30,
                                      color: Colors.white,
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  convertIntegerToTime(
                                      transformListData[widget.index]['time']),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.jost(
                                      color: customGreenColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      letterSpacing: 3,
                                      shadows: [
                                        Shadow(
                                            blurRadius: 5,
                                            offset: const Offset(0, 2),
                                            color:
                                                Colors.white.withOpacity(0.15))
                                      ]),
                                )
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                              blurRadius: 1,
                                              spreadRadius: 1,
                                              color: Colors.black12,
                                              offset: Offset(0, 1))
                                        ],
                                        shape: BoxShape.circle,
                                        color: transformListData[widget.index]
                                            ['colors'][1]),
                                    child: const Icon(
                                      Icons.gamepad,
                                      size: 30,
                                      color: Colors.white,
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  (transformListData[widget.index]
                                          ['scenarioType'] as ScenarioTypes)
                                      .type,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.jost(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      letterSpacing: 3,
                                      shadows: [
                                        Shadow(
                                            blurRadius: 5,
                                            offset: const Offset(0, 2),
                                            color:
                                                Colors.white.withOpacity(0.15))
                                      ]),
                                )
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                              blurRadius: 1,
                                              spreadRadius: 1,
                                              color: Colors.black12,
                                              offset: Offset(0, 1))
                                        ],
                                        shape: BoxShape.circle,
                                        color: transformListData[widget.index]
                                            ['colors'][1]),
                                    child: const Icon(
                                      Iconsax.category,
                                      size: 30,
                                      color: Colors.white,
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  (transformListData[widget.index]['level']
                                          as ChatDifficultLevels)
                                      .level,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.jost(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      letterSpacing: 3,
                                      shadows: [
                                        Shadow(
                                            blurRadius: 5,
                                            offset: const Offset(0, 2),
                                            color:
                                                Colors.white.withOpacity(0.15))
                                      ]),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ..._tabs.map((el) => CardDetailsItem(
                            index: widget.index,
                            icon: el['icon'],
                            title: el['title'],
                          ))
                    ],
                  ))),
            )));
  }
}

class CardDetailsItem extends StatefulWidget {
  const CardDetailsItem({
    required this.title,
    required this.icon,
    required this.index,
    super.key,
  });

  final String title;
  final IconData icon;
  final int index;
  @override
  State<CardDetailsItem> createState() => _CardDetailsItemState();
}

class _CardDetailsItemState extends State<CardDetailsItem> {
  bool _isAdditionalInfoOpened = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            _isAdditionalInfoOpened = !_isAdditionalInfoOpened;
            setState(() {});
          },
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  backgroundColor,
                  transformListData[widget.index]['colors'][1]
                ]),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: backgroundColor,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 1,
                      spreadRadius: 1,
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, 1))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  widget.icon,
                  color: Colors.black54,
                ),
                Text(widget.title,
                    style: GoogleFonts.jost(
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        letterSpacing: 3,
                        shadows: [
                          Shadow(
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                              color: Colors.white.withOpacity(0.15))
                        ])),
                Icon(
                  _isAdditionalInfoOpened
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black54,
                )
              ],
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _isAdditionalInfoOpened
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'You’re visiting a small grocery store in a village and need help finding some basic items. ',
                    style: GoogleFonts.jost(color: lightGreyTextColor),
                  ),
                )
              : const SizedBox.shrink(),
        )
      ],
    );
  }
}

class CustomCardDetailsClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.3, 0)
      ..lineTo(size.width * 0.3 + 20, 20)
      ..lineTo(size.width * 0.7 - 20, 20)
      ..lineTo(size.width * 0.7, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}

class StatsWidget extends StatelessWidget {
  const StatsWidget({
    required this.color,
    required this.text,
    required this.stats,
    this.size = 30,
    this.index,
    super.key,
  });
  final Color color;
  final int stats;
  final double size;
  final String text;
  final int? index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: index != 0 ? 8.0 : 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: GoogleFonts.jost(textStyle: const TextStyle(fontSize: 10)),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: size,
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: semiGreyColor,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: double.infinity,
                ),
                Container(
                  width: stats * 15,
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20))),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
