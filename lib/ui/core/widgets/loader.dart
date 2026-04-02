import 'dart:async';

import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({
    super.key,
    this.backdropColor = Colors.black54,
    this.barColor = Colors.white,
  });
  final Color backdropColor;
  final Color barColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: backdropColor,
        child: Center(
          child: BouncingBarLoader(color: barColor),
        ),
      ),
    );
  }
}

class BouncingBarLoader extends StatefulWidget {
  const BouncingBarLoader({
    super.key,
    this.width = 200,
    this.barHeight = 4,
    this.color = Colors.white,
    this.duration = const Duration(milliseconds: 800),
  });
  final double width;
  final double barHeight;
  final Color color;
  final Duration duration;

  @override
  State<BouncingBarLoader> createState() => _BouncingBarLoaderState();
}

class _BouncingBarLoaderState extends State<BouncingBarLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _widthAnimation;

  static const double _minBarWidth = 20;
  static const double _maxBarWidth = 50;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    unawaited(_controller.repeat(reverse: true));

    _positionAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _widthAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: _minBarWidth,
          end: _maxBarWidth,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: _maxBarWidth,
          end: _minBarWidth,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.barHeight,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final barWidth = _widthAnimation.value;
          final maxTravel = widget.width - barWidth;
          final leftOffset = _positionAnimation.value * maxTravel;

          return Stack(
            children: [
              Positioned(
                left: leftOffset,
                child: Container(
                  width: barWidth,
                  height: widget.barHeight,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(widget.barHeight / 2),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
