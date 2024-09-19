import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:sound/features/chat/view_model/auth_view_model.dart';
import 'package:sound/features/chat/view_model/global_user_view_model.dart';
import 'package:sound/utils/colors.dart';

class NewUserProfileSetPage extends StatefulWidget {
  const NewUserProfileSetPage({super.key});

  @override
  State<NewUserProfileSetPage> createState() => _NewUserProfileSetPageState();
}

class _NewUserProfileSetPageState extends State<NewUserProfileSetPage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _tabsList = [
    {'title': 'Interface', 'icon': Iconsax.language_circle},
    {'title': 'Target', 'icon': Icons.language},
    {'title': 'Profile', 'icon': Iconsax.user},
  ];
  String _translationLang = '';
  String _targetLang = '';
  String _name = '';
  late TabController _tabController;
  final int _selectedIndex = 0;
  int _translationIndex = -1;
  int _targetIndex = -1;
  late GlobalUserViewModel _globalUserViewModel;
  bool _isFinishLoading = false;
  @override
  void initState() {
    _tabController = TabController(length: _tabsList.length, vsync: this)
      ..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _globalUserViewModel = Provider.of<GlobalUserViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = Provider.of<AuthViewModel>(context);
    return SafeArea(
        child: DefaultTabController(
      length: _tabsList.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppBar(
              backgroundColor: backgroundColor,
              scrolledUnderElevation: 0,
              leadingWidth: 45,
              leading: CircleAvatar(
                backgroundColor: customButtonColor,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
              title: Image.asset(
                'assets/images/cardly.png',
                width: 100,
              ),
              bottom: PreferredSize(
                preferredSize: Size.zero,
                child: IgnorePointer(
                  child: TabBar(
                      controller: _tabController,
                      indicatorColor: _tabController.index == 0
                          ? customButtonColor
                          : _tabController.index == 1
                              ? customGreenColor
                              : primaryPurpleColor,
                      tabs: _tabsList
                          .map((element) => Tab(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      element['icon'],
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      element['title'],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.jost(
                                          color: lightGreyTextColor,
                                          shadows: [
                                            Shadow(
                                                blurRadius: 5.0,
                                                color: Colors.white
                                                    .withOpacity(0.15),
                                                offset: const Offset(0, 2))
                                          ]),
                                    ),
                                  ],
                                ),
                              ))
                          .toList()),
                ),
              ),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
            child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  Tab(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_translationIndex < 0) {
                                  return;
                                }

                                _tabController
                                    .animateTo(_tabController.index + 1);
                              },
                              child: Container(
                                width: 100,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        style: BorderStyle.solid,
                                        color: Colors.white),
                                    boxShadow: const [
                                      BoxShadow(
                                          blurRadius: 1.0,
                                          spreadRadius: 1.0,
                                          offset: Offset(0, 2),
                                          color: Colors.black12)
                                    ],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    color: _translationIndex < 0
                                        ? lightGreyTextColor.withOpacity(0.6)
                                        : Colors.black),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Continue',
                                        style: GoogleFonts.jost(
                                          color: Colors.white,
                                        )),
                                    const Icon(
                                      Iconsax.arrow_right,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Translation Language',
                          style: GoogleFonts.jost(fontSize: 24),
                        ),
                        Text('Pick language displayed as basic language',
                            style: GoogleFonts.jost(color: lightGreyTextColor)),
                        Expanded(
                          child: ListView.builder(
                              itemCount: _globalUserViewModel
                                  .languageModelsList.length,
                              itemBuilder: (context, i) => GestureDetector(
                                    onTap: () {
                                      _translationIndex = i;
                                      _translationLang = _globalUserViewModel
                                          .languageModelsList[_translationIndex]
                                          .name;
                                      setState(() {});
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            border: Border.all(
                                                style: BorderStyle.solid,
                                                color: Colors.black12),
                                            gradient: LinearGradient(colors: [
                                              Colors.white,
                                              _translationIndex < 0 ||
                                                      _translationIndex == i
                                                  ? customButtonColor
                                                  : lightGreyTextColor
                                            ])),
                                        child: Row(
                                          children: [
                                            CountryFlag.fromCountryCode(
                                                width: 30,
                                                height: 30,
                                                shape: const Circle(),
                                                _globalUserViewModel
                                                    .languageModelsList[i]
                                                    .countryCode),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              _globalUserViewModel
                                                  .languageModelsList[i].name,
                                              style: GoogleFonts.jost(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        )),
                                  )),
                        )
                      ],
                    ),
                  ),
                  Tab(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _tabController
                                  .animateTo(_tabController.index - 1);
                            },
                            child: Container(
                              width: 100,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    style: BorderStyle.solid,
                                    color: Colors.black),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Icon(Iconsax.arrow_left),
                                  Text('Back',
                                      style: GoogleFonts.jost(
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_targetIndex < 0) {
                                return;
                              }
                              _tabController
                                  .animateTo(_tabController.index + 1);
                            },
                            child: Container(
                              width: 100,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      style: BorderStyle.solid,
                                      color: Colors.white),
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 1.0,
                                        spreadRadius: 1.0,
                                        offset: Offset(0, 2),
                                        color: Colors.black12)
                                  ],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  color: _targetIndex < 0
                                      ? lightGreyTextColor.withOpacity(0.6)
                                      : Colors.black),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Continue',
                                      style: GoogleFonts.jost(
                                        color: Colors.white,
                                      )),
                                  const Icon(
                                    Iconsax.arrow_right,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Learning Target Language',
                        style: GoogleFonts.jost(fontSize: 24),
                      ),
                      Text('Pick language you would like to learn',
                          style: GoogleFonts.jost(color: lightGreyTextColor)),
                      Expanded(
                        child: ListView.builder(
                            itemCount:
                                _globalUserViewModel.languageModelsList.length,
                            itemBuilder: (context, i) => GestureDetector(
                                  onTap: () {
                                    _targetIndex = i;
                                    _targetLang = _globalUserViewModel
                                        .languageModelsList[_targetIndex].name;
                                    setState(() {});
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          border: Border.all(
                                              style: BorderStyle.solid,
                                              color: Colors.black12),
                                          gradient: LinearGradient(colors: [
                                            Colors.white,
                                            _targetIndex < 0 ||
                                                    _targetIndex == i
                                                ? customGreenColor
                                                : lightGreyTextColor
                                          ])),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            _globalUserViewModel
                                                .languageModelsList[i].name,
                                            style: GoogleFonts.jost(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          CountryFlag.fromCountryCode(
                                              width: 30,
                                              height: 30,
                                              shape: const Circle(),
                                              _globalUserViewModel
                                                  .languageModelsList[i]
                                                  .countryCode),
                                        ],
                                      )),
                                )),
                      )
                    ],
                  )),
                  Tab(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _tabController
                                    .animateTo(_tabController.index - 1);
                              },
                              child: Container(
                                width: 100,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      style: BorderStyle.solid,
                                      color: Colors.black),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Icon(Iconsax.arrow_left),
                                    Text('Back',
                                        style: GoogleFonts.jost(
                                          color: Colors.black,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (_targetIndex < 0 || _translationIndex < 0) {
                                  return;
                                }
                                _isFinishLoading = true;
                                setState(() {});
                                await authViewModel.authAddAdditionalInfo(
                                    context,
                                    translationLang: _translationLang,
                                    targetLang: _targetLang,
                                    name: _name);
                                _isFinishLoading = false;
                              },
                              child: Container(
                                width: 100,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        style: BorderStyle.solid,
                                        color: Colors.white),
                                    boxShadow: const [
                                      BoxShadow(
                                          blurRadius: 1.0,
                                          spreadRadius: 1.0,
                                          offset: Offset(0, 2),
                                          color: Colors.black12)
                                    ],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    color: _targetIndex < 0
                                        ? lightGreyTextColor.withOpacity(0.6)
                                        : Colors.black),
                                child: _isFinishLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text('Finish',
                                              style: GoogleFonts.jost(
                                                color: Colors.white,
                                              )),
                                          const Icon(
                                            FontAwesomeIcons.locationArrow,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'One more question...',
                          style: GoogleFonts.jost(fontSize: 24),
                        ),
                        Text(
                            'Tell us a little about yourself...you can skip this(:',
                            style: GoogleFonts.jost(color: lightGreyTextColor)),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: const BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 255, 255, 255),
                              spreadRadius: -8.0,
                              blurRadius: 10.0,
                              offset: Offset(0, 2),
                            )
                          ]),
                          child: TextFormField(
                            onChanged: (value) {
                              _name = value;
                            },
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.05),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        style: BorderStyle.solid,
                                        color: primaryPurpleColor)),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.black12,
                                )),
                                hintText: 'Your Name...',
                                hintStyle: GoogleFonts.jost(
                                    color: lightGreyTextColor)),
                          ),
                        )
                      ],
                    ),
                  )
                ]),
          ),
        ),
      ),
    ));
  }
}
