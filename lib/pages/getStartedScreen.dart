// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:rive/rive.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_gradient_text/flutter_gradient_text.dart';
// import 'package:curved_text/curved_text.dart';
// import 'package:sound/pages/login_screen.dart';
// import 'package:sound/utils/animated_button.dart';
// import 'package:sound/utils/colors.dart';

// class GetStartedScreen extends StatefulWidget {
//   const GetStartedScreen({super.key});

//   @override
//   State<GetStartedScreen> createState() => _GetStartedScreenState();
// }

// class _GetStartedScreenState extends State<GetStartedScreen> {
//   late RiveAnimationController _btnAnimationController;

//   bool isShowSignInDialog = false;

//   @override
//   void initState() {
//     _btnAnimationController = OneShotAnimation(
//       "active",
//       autoplay: false,
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: Stack(
//         children: [
//           Positioned(
//             width: MediaQuery.of(context).size.width * 1.7,
//             left: 100,
//             bottom: 100,
//             child: Image.asset(
//               "assets/images/Spline.png",
//             ),
//           ),
//           Positioned.fill(
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//               child: const SizedBox(),
//             ),
//           ),
//           const RiveAnimation.asset(
//             "assets/images/shapes.riv",
//           ),
//           Positioned.fill(
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
//               child: const SizedBox(),
//             ),
//           ),
//           AnimatedPositioned(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             duration: const Duration(milliseconds: 260),
//             child: SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 32),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 30,),
//                     SizedBox(
//                       width: 360,
//                       child: Column(
//                         children: [
//                           Container(
//                             margin: EdgeInsets.only(bottom: 50),
//                             child: CurvedText(
//                               curvature: 0.01,
//                               text: "ready to practice",
//                               textStyle: GoogleFonts.caveat(
//                                 textStyle: TextStyle(
//                                   fontSize: 20
//                               )),
//                             ),
//                           ),
//                         Text('KOREAN SPEAKING',
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.amiri(
//                           textStyle: TextStyle(
//                             letterSpacing: 6,
//                             height: 0.8,
//                           fontSize: 50,
//                         )) ),
//                         GradientText(
//                           colors: [Color(0xff77dfe0), Color(0xfff972b7), Color(0xff53b965)],
//                           Text('perfectly?' ,
//                           style: GoogleFonts.caveat(
//                             textStyle: TextStyle(
//                             fontSize: 50,
//                             letterSpacing: 5,
//                           )
//                           )),
//                         ),
//                         ],
//                       ),
//                     ),
//                     const Spacer(flex: 2),
//                     AnimatedBtn(
//                       btnAnimationController: _btnAnimationController,
//                       press: () {
//                         _btnAnimationController.isActive = true;

//                         Future.delayed(
//                           const Duration(milliseconds: 800),
//                           () {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
//                           },
//                         );
//                       },
//                     ),
//                     SizedBox(height: 10,),
//                     Text('Get access to the best learning role-play situations to make your Korean natural',
//                     style : GoogleFonts.jost(textStyle: TextStyle(color: Colors.black45))),
//                       SizedBox(height: 80,)
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Test'),
      ),
    );
  }
}
