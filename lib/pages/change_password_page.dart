import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sound/pages/personal_details_page.dart';
import 'package:sound/utils/colors.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final List<Map<String, dynamic>> _textFieldsListData = [
    {
      'title': 'Current Password',
      'hintText': '',
    },
    {
      'title': 'New Password',
      'hintText': '',
    },
    {
      'title': 'Repeat Password',
      'hintText': '',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ..._textFieldsListData.map((element) => CustomFormFieldWidget(
                isPasswordField: true,
                hintText: element['hintText'],
                title: element['title'])),
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
