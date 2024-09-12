import 'package:flutter/material.dart';
import 'package:sound/utils/colors.dart';

class AnimatedIconButton extends StatefulWidget {
  const AnimatedIconButton({
    super.key,
    required this.title,
    required this.nextPage,
  });
  final String title;
  final Widget nextPage;

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconController;
  late Animation<Offset> _iconAnimation;

  @override
  void initState() {
    _iconController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
    _iconAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(10, 0))
        .animate(_iconController);
    super.initState();
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _iconController,
      builder: (context, child) => OutlinedButton(
          onPressed: () {
            Navigator.of(context).push(PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  widget.nextPage,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.title),
              Opacity(
                opacity: _iconController.value,
                child: Transform.translate(
                  offset: _iconAnimation.value,
                  child: const Icon(
                    Icons.keyboard_double_arrow_right_outlined,
                    color: customButtonColor,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
