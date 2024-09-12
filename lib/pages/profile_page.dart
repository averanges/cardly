import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sound/features/chat/view_model/global_user_view_model.dart';
import 'package:sound/models/language_model.dart';
import 'package:sound/utils/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<String> _languageTitles = [
    'Target Language',
    "Translation Language"
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: List.generate(
            _languageTitles.length,
            (index) => LanguageDropdownWidget(
                  title: _languageTitles[index],
                  index: index,
                )),
      ),
    );
  }
}

class LanguageDropdownWidget extends StatefulWidget {
  const LanguageDropdownWidget(
      {super.key, required this.title, required this.index});
  final int index;
  final String title;

  @override
  State<LanguageDropdownWidget> createState() => _LanguageDropdownWidgetState();
}

class _LanguageDropdownWidgetState extends State<LanguageDropdownWidget> {
  late LanguageModel _initialValue;
  late GlobalUserViewModel globalUserViewModel;
  @override
  void didChangeDependencies() {
    globalUserViewModel = Provider.of<GlobalUserViewModel>(context);

    _initialValue = (widget.index == 0)
        ? globalUserViewModel.targetLanguage
        : globalUserViewModel.translationLanguage;
    super.didChangeDependencies();
  }

  void _chooseLanguage(int elementIndex) {
    setState(() {
      (widget.index == 0)
          ? globalUserViewModel.targetLanguage =
              globalUserViewModel.languageModelsList[elementIndex]
          : globalUserViewModel.translationLanguage =
              globalUserViewModel.languageModelsList[elementIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: GoogleFonts.jost(textStyle: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => LanguageSearchAndChooseDialog(
                      languageList: globalUserViewModel.languageModelsList,
                      chooseLanguage: _chooseLanguage));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: customButtonColor,
                  border: Border.all(
                      style: BorderStyle.solid, color: Colors.black12)),
              child: Row(
                children: [
                  CountryFlag.fromCountryCode(
                    _initialValue.countryCode,
                    width: 30,
                    height: 30,
                    shape: const Circle(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    _initialValue.name,
                    style: GoogleFonts.jost(),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LanguageSearchAndChooseDialog extends StatefulWidget {
  const LanguageSearchAndChooseDialog(
      {super.key, required this.languageList, required this.chooseLanguage});
  final List<LanguageModel> languageList;
  final Function(int) chooseLanguage;

  @override
  State<LanguageSearchAndChooseDialog> createState() =>
      _LanguageSearchAndChooseDialogState();
}

class _LanguageSearchAndChooseDialogState
    extends State<LanguageSearchAndChooseDialog> {
  late TextEditingController _textEditingController;
  late List<LanguageModel> _listLanguagesCopy;

  void _languageSearch() {
    final query = _textEditingController.text.toLowerCase();

    setState(() {
      _listLanguagesCopy = widget.languageList.where((language) {
        final name = language.name.toLowerCase();
        final code = language.countryCode.toLowerCase();
        return name.contains(query) || query.contains(code);
      }).toList();
    });
  }

  @override
  void initState() {
    _textEditingController = TextEditingController()
      ..addListener(() {
        _languageSearch();
      });
    _listLanguagesCopy = widget.languageList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Choose Target Language',
                  style: GoogleFonts.jost(
                      textStyle: const TextStyle(fontSize: 20)),
                ),
                Transform.translate(
                  offset: const Offset(5, -10),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close)),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  fillColor: customButtonColor,
                  filled: true,
                  suffixIcon: Icon(
                    Icons.search,
                    color: lightGreyTextColor,
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _listLanguagesCopy.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      widget.chooseLanguage(index);
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(bottom: 10.0, top: 10),
                      child: Row(mainAxisSize: MainAxisSize.max, children: [
                        CountryFlag.fromCountryCode(
                          _listLanguagesCopy[index].countryCode.toLowerCase(),
                          width: 30,
                          height: 30,
                          shape: const Circle(),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          _listLanguagesCopy[index].name,
                          style: GoogleFonts.jost(),
                        ),
                      ]),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
