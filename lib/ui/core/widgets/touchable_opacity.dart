import 'package:flutter/widgets.dart';

class TouchableOpacity extends StatefulWidget {
  const TouchableOpacity({
    required this.child,
    this.onTap,
    this.onLongPress,
    this.decoration,
    this.width,
    this.height,
    this.behavior = HitTestBehavior.opaque,
    this.isDisabled = false,
    this.isLoading = false,
    this.onTapDown,
    this.alignment,
    this.onTapUp,
    this.onTapCancel,
    this.padding,
    super.key,
  });
  final Widget child;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BoxDecoration? decoration;
  final HitTestBehavior behavior;
  final bool isDisabled;
  final bool isLoading;
  final AlignmentGeometry? alignment;
  final VoidCallback? onTapDown;
  final VoidCallback? onTapUp;
  final VoidCallback? onTapCancel;
  final EdgeInsetsGeometry? padding;
  @override
  State<TouchableOpacity> createState() => _TouchableOpacityState();
}

class _TouchableOpacityState extends State<TouchableOpacity> {
  bool isTappedDown = false;

  @override
  Widget build(BuildContext context) {
    Widget current = Container(
      width: widget.width,
      height: widget.height,
      decoration: widget.decoration,
      alignment: widget.alignment,
      padding: widget.padding,
      child: widget.child,
    );

    // only apply expensive layers if the user is actually touching the button
    if (isTappedDown) {
      current = Transform.scale(
        scale: 0.95,
        child: Opacity(
          opacity: 0.6,
          child: current,
        ),
      );
    }
    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: (tapDownDetails) {
        if (widget.isDisabled) {
          return;
        }
        setState(() {
          isTappedDown = true;
        });
        widget.onTapDown?.call();
      },
      onTapUp: (tapUpDetails) {
        setState(() {
          isTappedDown = false;
        });
        widget.onTapUp?.call();
      },
      onTapCancel: () {
        setState(() {
          isTappedDown = false;
        });

        widget.onTapCancel?.call();
      },
      onTap: (widget.isDisabled || widget.isLoading) ? null : widget.onTap,
      onLongPress: widget.isDisabled ? null : widget.onLongPress,
      child: current,
    );
  }
}
