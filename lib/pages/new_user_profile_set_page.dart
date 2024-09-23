import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:sound/features/chat/view_model/auth_view_model.dart';
import 'package:sound/features/chat/view_model/global_user_view_model.dart';
import 'package:sound/generated/l10n.dart';
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: backgroundColor.withOpacity(0.8),
    ));
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
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppBar(
              backgroundColor: backgroundColor,
              scrolledUnderElevation: 0,
              leadingWidth: 45,
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                        3,
                        (int index) => Flexible(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    color: _tabController.index > index &&
                                            _tabController.index == 1
                                        ? customGreenColor
                                        : _tabController.index > index &&
                                                _tabController.index == 2
                                            ? primaryPurpleColor
                                            : lightGreyTextColor),
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, top: 5),
                                height: 4,
                              ),
                            )),
                  )),
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
                                    Text(S.of(context).continueButton,
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
                          S.of(context).translationLanguage,
                          style: GoogleFonts.jost(fontSize: 24),
                        ),
                        Text(S.of(context).pickLanguageDisplayedAsBasicLanguage,
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
                                  Text(S.of(context).back,
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
                                  Text(S.of(context).continueButton,
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
                        S.of(context).learningTargetLanguage,
                        style: GoogleFonts.jost(fontSize: 24),
                      ),
                      Text(S.of(context).pickLanguageYouWouldLikeToLearn,
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
                                    Text(S.of(context).back,
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
                                          Text(S.of(context).finish,
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
                          S.of(context).oneMoreQuestionHint,
                          style: GoogleFonts.jost(fontSize: 24),
                        ),
                        Text(
                            S
                                .of(context)
                                .tellUsALittleAboutYourselfyouCanSkipThis,
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
                                hintText: S.of(context).nameHint,
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
