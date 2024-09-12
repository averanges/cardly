import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sound/utils/colors.dart';

class PersonalDetailsPage extends StatefulWidget {
  const PersonalDetailsPage({super.key});

  @override
  State<PersonalDetailsPage> createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  final List<Map<String, dynamic>> _textFieldsListData = [
    {
      'title': 'Your email address',
      'hintText': 'averanges@kbu.ac.kr',
    },
    {
      'title': 'First name',
      'hintText': 'Nick',
    },
    {
      'title': 'Last Name',
      'hintText': 'Bel',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ..._textFieldsListData.map((element) => CustomFormFieldWidget(
                hintText: element['hintText'], title: element['title'])),
            const SizedBox(
              height: 20,
            ),
            Container(
                alignment: Alignment.center,
                height: 50,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: customButtonColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 1, spreadRadius: 1)
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  // border: Border.all(
                  //     color: Colors.black12, style: BorderStyle.solid)
                ),
                child: Text(
                  'Save'.toUpperCase(),
                  style: GoogleFonts.jost(
                      textStyle: const TextStyle(
                          color: lightGreyTextColor, letterSpacing: 2)),
                ))
          ],
        ),
      ),
    );
  }
}

class CustomFormFieldWidget extends StatefulWidget {
  const CustomFormFieldWidget({
    required this.hintText,
    required this.title,
    this.isPasswordField = false,
    super.key,
  });
  final bool isPasswordField;
  final String title;
  final String hintText;

  @override
  State<CustomFormFieldWidget> createState() => _CustomFormFieldWidgetState();
}

class _CustomFormFieldWidgetState extends State<CustomFormFieldWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: GoogleFonts.jost(textStyle: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
                suffixIcon:
                    widget.isPasswordField ? const Icon(Iconsax.eye) : null,
                hintText: widget.hintText,
                fillColor: Colors.white,
                filled: true,
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black45),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.all(Radius.circular(20)))),
          )
        ],
      ),
    );
  }
}
