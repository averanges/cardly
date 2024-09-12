import 'package:flutter/material.dart';
import 'package:flutter_gradient_text/flutter_gradient_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sound/utils/colors.dart';

class AnimatedGradientText extends StatefulWidget {
  final bool isVisible;
  final String text;
  final Color color;
  const AnimatedGradientText({
    this.isVisible = false,
    this.color = customGreenColor,
    required this.text,
    super.key,
  });

  @override
  State<AnimatedGradientText> createState() => _AnimatedGradientTextState();
}

class _AnimatedGradientTextState extends State<AnimatedGradientText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => GradientText(
          Text(
            widget.text,
            style: GoogleFonts.jost(
                textStyle:
                    const TextStyle(fontSize: 12, color: lightGreyTextColor)),
          ),
          colors: [lightGreyTextColor, widget.color, lightGreyTextColor],
          stops: [
            _controller.value - 0.3,
            _controller.value,
            _controller.value + 0.3,
          ],
        ),
      ),
    );
  }
}
