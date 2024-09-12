// import 'package:flutter/material.dart';

// class TestClass extends StatefulWidget {
//   const TestClass({super.key});

//   @override
//   State<TestClass> createState() => _TestClassState();
// }

// class _TestClassState extends State<TestClass> {
//   Map<String, dynamic> _removedElement = {};
//   final List<Map<String, dynamic>> _offsetList = [
//     {
//       "offset": const Offset(0, 0),
//       'scale': 1.0,
//       'color': Colors.green,
//     },
//     {
//       "offset": const Offset(0, 40),
//       'scale': 0.95,
//       'color': Colors.yellow,
//     },
//     {
//       "offset": const Offset(0, 100),
//       'scale': 0.9,
//       'color': Colors.red,
//     },
//   ];

//   void _addLast() {
//     _offsetList.add(_removedElement);
//     setState(() {});
//   }

//   Future<void> _removeLast() async {
//     _removedElement = _offsetList.last;
//     print(_removedElement);
//     _offsetList.removeLast();
//     setState(() {});
//     await Future.delayed(
//         Duration.zero, () => _offsetList.insert(0, _removedElement));
//     setState(() {});
//     print(_offsetList);
//     print(_offsetList.length);
//   }

//   Future<void> _removeFirst() async {
//     _removedElement = _offsetList.first;
//     print(_removedElement);
//     _offsetList.removeAt(0);
//     setState(() {});
//     await Future.delayed(Duration.zero, () => _addLast());
//     print(_offsetList);
//     print(_offsetList.length);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//         body: Center(
//       child: Text('TEST'),
//     ));
//   }
// }

// class Card extends StatefulWidget {
//   final bool isLast;
//   final bool isFirst;
//   final VoidCallback callback;
//   final VoidCallback addLast;
//   final Offset offset;
//   final double scale;
//   final Color color;
//   const Card(
//       {super.key,
//       required this.addLast,
//       required this.isLast,
//       required this.isFirst,
//       required this.callback,
//       required this.offset,
//       required this.scale,
//       required this.color});

//   @override
//   State<Card> createState() => _CardState();
// }

// class _CardState extends State<Card> with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _animation;

//   bool _isInitAnimation = true;

//   @override
//   void initState() {
//     _controller = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 500));
//     // _controller.addStatusListener((status) {
//     //   if (status == AnimationStatus.completed) {
//     //     if (!_isInitAnimation) widget.callback();
//     //   }
//     // });
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     _animation = Tween<Offset>(
//             begin: Offset(0, MediaQuery.of(context).size.height),
//             end: const Offset(0, 0))
//         .animate(_controller);
//     _controller.forward();
//     super.didChangeDependencies();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//         animation: _controller,
//         builder: (context, child) {
//           return Transform.translate(
//             offset: _animation.value,
//             child: Transform.scale(
//               scale: widget.scale,
//               child: Transform.translate(
//                 offset: widget.offset,
//                 child: GestureDetector(
//                   onTap: () {
//                     if (widget.isFirst || widget.isLast) {
//                       _isInitAnimation = false;
//                       print('clicked');
//                       _controller
//                           .reverse()
//                           .whenComplete(() => widget.callback());
//                       // setState(() {});
//                       // widget.addLast();
//                     } else {
//                       print('clicked middle');
//                     }
//                   },
//                   child: Container(
//                     width: 200,
//                     height: 100,
//                     decoration: BoxDecoration(color: widget.color),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         });
//   }
// }
