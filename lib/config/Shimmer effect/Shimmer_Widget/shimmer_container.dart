import 'package:flutter/material.dart';

Widget buildShimmerLabel() {
  return ShimmerContainer(
    height: 14,
    width: 80,
  );
}

Widget buildShimmerField({
  required double height,
  double? width,
  double? radius,
}) {
  return ShimmerContainer(
    height: height,
    width: width,
    radius: radius,
  );
}

class ShimmerContainer extends StatefulWidget {
  final double height;
  final double? width;
  final double? radius;

  const ShimmerContainer({
    Key? key,
    required this.height,
    this.width,
    this.radius,
  }) : super(key: key);

  @override
  State<ShimmerContainer> createState() => _ShimmerContainerState();
}

class _ShimmerContainerState extends State<ShimmerContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius ?? 8),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                0.1,
                0.3,
                0.5,
                0.7,
                0.9,
              ],
              colors: [
                Colors.grey[300]!,
                Colors.grey[200]!,
                Colors.grey[100]!,
                Colors.grey[200]!,
                Colors.grey[300]!,
              ],
              transform: GradientRotation(_animation.value),
            ),
          ),
        );
      },
    );
  }
}