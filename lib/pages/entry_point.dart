import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sound/pages/main_screen.dart';
import 'package:sound/pages/side_settings_menu.dart';
import 'package:sound/utils/colors.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint>
    with SingleTickerProviderStateMixin {
  bool _isSideBarOpen = false;

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(
        () {
          setState(() {});
        },
      );
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSideMenu() {
    _isSideBarOpen = !_isSideBarOpen;
    if (_animationController.value == 0) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor2,
      body: PopScope(
        canPop: false,
        child: Stack(
          children: [
            AnimatedPositioned(
              width: 288,
              height: MediaQuery.of(context).size.height,
              duration: const Duration(milliseconds: 400),
              curve: Curves.fastOutSlowIn,
              left: _isSideBarOpen ? 0 : -288,
              top: 0,
              child: SideBar(
                toggleSideMenu: _toggleSideMenu,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_isSideBarOpen) {
                  _toggleSideMenu();
                }
              },
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(
                      1 * animation.value - 30 * (animation.value) * pi / 180),
                child: Transform.translate(
                  offset: Offset(animation.value * 265, 0),
                  child: Transform.scale(
                    scale: scalAnimation.value,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(24 * _animationController.value),
                      ),
                      child: MainScreen(
                        toggleSideMenu: _toggleSideMenu,
                        isSideMenuOpened: _isSideBarOpen,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
