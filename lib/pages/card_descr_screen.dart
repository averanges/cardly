// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sound/pages/new_chat_screen.dart';
// import 'package:sound/utils/colors.dart';

// class CardDescrScreen extends StatefulWidget {
//   const CardDescrScreen({super.key});

//   @override
//   State<CardDescrScreen> createState() => _CardDescrScreenState();
// }

// class _CardDescrScreenState extends State<CardDescrScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: backgroundColor,
//           leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: const Icon(Icons.arrow_back),
//           ),
//         ),
//         body: SizedBox(
//           width: double.infinity,
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Health Care',
//                       style: GoogleFonts.amiri(
//                         textStyle: const TextStyle(
//                           fontSize: 40,
//                           color: Colors.black,
//                           height: 1,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     ClipPath(
//                       clipper: BestSellerClipper(),
//                       child: Container(
//                         color: const Color.fromRGBO(174, 219, 207, 1),
//                         padding: const EdgeInsets.only(
//                             left: 10, top: 5, right: 20, bottom: 5),
//                         child: Text(
//                           "Easy".toUpperCase(),
//                           style: const TextStyle(
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                               letterSpacing: 5),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                     Text('Description: ',
//                         style: GoogleFonts.jost(
//                             textStyle: const TextStyle(
//                                 fontSize: 16,
//                                 color: Color.fromRGBO(177, 176, 161, 1)))),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                     Text(
//                         'It`s beginning of spring and you have itchy, water eyes. You decide to visit doctor to find out if you have allergies. Describe your symptoms, ask questions about treatments, and understand the doctor`s advice.',
//                         style: GoogleFonts.jost(
//                             textStyle: const TextStyle(fontSize: 14))),
//                     const SizedBox(
//                       height: 35,
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 flex: 2,
//                 child: Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(50),
//                     color: Colors.white,
//                   ),
//                   child: Stack(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(30),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 10),
//                                 decoration: const BoxDecoration(
//                                     color: customButtonColor,
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(5))),
//                                 child: Text("Tasks",
//                                     style: GoogleFonts.amiri(fontSize: 24))),
//                             const SizedBox(height: 30),
//                             const CourseContent(
//                               number: "01",
//                               title:
//                                   "Ask about Golden week events that are happening",
//                               isDone: true,
//                             ),
//                             const CourseContent(
//                               number: '02',
//                               title: "Find out the location of an event",
//                               isDone: true,
//                             ),
//                             const CourseContent(
//                               number: '03',
//                               title: "Say thank you for the information",
//                             ),
//                           ],
//                         ),
//                       ),
//                       Positioned(
//                         right: 5,
//                         left: 5,
//                         bottom: 5,
//                         child: Container(
//                           padding: const EdgeInsets.all(20),
//                           height: 90,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(40),
//                             boxShadow: [
//                               BoxShadow(
//                                 offset: const Offset(0, 4),
//                                 blurRadius: 50,
//                                 color: Colors.black.withOpacity(.1),
//                               ),
//                             ],
//                           ),
//                           child: Row(
//                             children: [
//                               Container(
//                                   padding: const EdgeInsets.all(14),
//                                   height: 56,
//                                   width: 60,
//                                   decoration: BoxDecoration(
//                                     color: customButtonColor,
//                                     borderRadius: BorderRadius.circular(40),
//                                   ),
//                                   child: const Icon(
//                                     Icons.language,
//                                     color: Colors.black54,
//                                   )),
//                               const SizedBox(width: 20),
//                               Expanded(
//                                 child: Container(
//                                   alignment: Alignment.center,
//                                   height: 56,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(40),
//                                     color: primaryPurpleColor,
//                                   ),
//                                   child: OutlinedButton(
//                                     style: const ButtonStyle(
//                                         side: WidgetStatePropertyAll(BorderSide(
//                                             style: BorderStyle.none))),
//                                     onPressed: () {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   const NewChatScreen()));
//                                     },
//                                     child: const Text(
//                                       "Start conversation",
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           letterSpacing: 4),
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CourseContent extends StatelessWidget {
//   final String number;
//   final String title;
//   final bool isDone;

//   const CourseContent({
//     super.key,
//     required this.number,
//     required this.title,
//     this.isDone = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 30.0),
//       child: Row(
//         children: [
//           Text(
//             number,
//             style: const TextStyle(
//                 color: Color.fromRGBO(177, 176, 161, 0.7),
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//               flex: 3,
//               child: Text(title,
//                   style: GoogleFonts.jost(
//                     textStyle: TextStyle(
//                       color: Colors.black.withOpacity(.9),
//                       fontSize: 16,
//                     ),
//                   ))),
//           const SizedBox(
//             width: 20,
//           ),
//           Container(
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: customGreenColor,
//             ),
//             child: const Icon(
//               Icons.check_outlined,
//               color: Colors.white,
//               size: 30,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class BestSellerClipper extends CustomClipper<Path> {
//   @override
//   getClip(Size size) {
//     var path = Path();
//     path.lineTo(size.width + 20, 0);
//     path.lineTo(size.width, size.height / 2);
//     path.lineTo(size.width - 20, size.height);
//     path.lineTo(0, size.height);
//     path.lineTo(0, 0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper oldClipper) {
//     return false;
//   }
// }
