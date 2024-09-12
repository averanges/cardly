// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:sound/pages/ChatPage.dart';
// import 'package:sound/pages/GetStartedScreen.dart';


// class OnBoardingScreen extends StatefulWidget {
//   const OnBoardingScreen({super.key});

//   @override
//   State<OnBoardingScreen> createState() => _OnBoardingScreenState();
// }

// class _OnBoardingScreenState extends State<OnBoardingScreen> {
//   late Timer timer;

//   @override
//   void initState() {
//     timer = Timer(Duration(milliseconds: 1000), () {
//       Navigator.push(context, MaterialPageRoute(builder: (context) => GetStartedScreen()));
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//   return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         color: Colors.white,
//         child: Center(
//           child: Image.asset('assets/images/wings.png', width: 150,),
//         ),
//       ),
//     );
//   }
// }