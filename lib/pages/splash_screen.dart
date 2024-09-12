// import 'dart:async';

// import 'package:flutter/material.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   late Timer timer;

//   @override
//   void initState() {
//     timer = Timer(const Duration(milliseconds: 1000), () {
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => GetStartedScreen()));
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(254, 245, 233, 1),
//       body: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.only(bottom: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Spacer(),
//             Image.asset(
//               'assets/images/splash_img.png',
//               fit: BoxFit.contain,
//             ),
//             const Spacer(),
//             SizedBox(
//                 width: 120,
//                 height: 100,
//                 child: Image.asset(
//                   'assets/images/logo.png',
//                   fit: BoxFit.cover,
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }
