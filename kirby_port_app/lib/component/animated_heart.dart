import 'package:flutter/material.dart';

class AnimatedHeart extends StatefulWidget {
  final Duration duration;
  final double endY;
  final double size;

  const AnimatedHeart({
    super.key,
    required this.duration,
    required this.endY,
    required this.size,
  });

  @override
  State<AnimatedHeart> createState() => _AnimatedHeartState();
}

class _AnimatedHeartState extends State<AnimatedHeart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _yAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _yAnimation = Tween<double>(begin: 0, end: widget.endY).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_yAnimation.value),
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Icon(
              Icons.favorite,
              size: widget.size,
              color: Colors.red,
            ),
          ),
        );
      },
    );
  }
}
