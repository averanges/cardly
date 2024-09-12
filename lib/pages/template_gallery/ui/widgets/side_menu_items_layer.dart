import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sound/utils/colors.dart';

class SideMenuItemsLayer extends StatelessWidget {
  const SideMenuItemsLayer(
      {super.key,
      required this.child,
      required this.sideMenuSubTitle,
      required this.sideMenuTitle});
  final String sideMenuTitle;
  final String sideMenuSubTitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
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
              title: Transform.scale(
                scale: 3,
                child: Image.asset(
                  'assets/images/clearly.png',
                  width: 150,
                  height: 50,
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    sideMenuTitle,
                    style: GoogleFonts.amiri(
                        textStyle: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          border: Border.all(
                              style: BorderStyle.solid,
                              color: primaryPurpleColor)),
                      child: Text(
                        'Guest Mode',
                        style: GoogleFonts.jost(
                            textStyle:
                                const TextStyle(color: primaryPurpleColor)),
                      ))
                ],
              ),
              Text(sideMenuSubTitle,
                  style: GoogleFonts.jost(
                      textStyle: const TextStyle(
                          fontSize: 16, color: lightGreyTextColor))),
              const SizedBox(
                height: 40,
              ),
              child
            ],
          ),
        ),
      ),
    );
  }
}
