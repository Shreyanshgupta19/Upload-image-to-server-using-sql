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
    super.key,
    required this.height,
    this.width,
    this.radius,
  });

  @override
  State<ShimmerContainer> createState() => _ShimmerContainerState();
}

class _ShimmerContainerState extends State<ShimmerContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<Color> _getGradientColors(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    if (brightness == Brightness.light) {
      return [
        Colors.grey[300]!,
        Colors.grey[200]!,
        Colors.grey[100]!,
        Colors.grey[200]!,
        Colors.grey[300]!,
      ];
    } else {
      return [
        Colors.grey[800]!,
        Colors.grey[700]!,
        Colors.grey[600]!,
        Colors.grey[700]!,
        Colors.grey[800]!,
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius ?? 8),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.1, 0.3, 0.5, 0.7, 0.9],
              colors: _getGradientColors(context),
              transform: GradientRotation(animation.value),
            ),
          ),
        );
      },
    );
  }
}

// Custom theme colors for shimmer (optional)
class ShimmerTheme {
  static const lightShimmerColors = [
    Color(0xFFE0E0E0), // Base
    Color(0xFFEEEEEE), // Lighter
    Color(0xFFF5F5F5), // Lightest
    Color(0xFFEEEEEE), // Lighter
    Color(0xFFE0E0E0), // Base
  ];

  static const darkShimmerColors = [
    Color(0xFF424242), // Base
    Color(0xFF616161), // Lighter
    Color(0xFF757575), // Lightest
    Color(0xFF616161), // Lighter
    Color(0xFF424242), // Base
  ];
}

// Example usage with custom theme
class ThemedShimmerContainer extends StatefulWidget {
  final double height;
  final double? width;
  final double? radius;
  final List<Color>? customLightColors;
  final List<Color>? customDarkColors;

  const ThemedShimmerContainer({
    super.key,
    required this.height,
    this.width,
    this.radius,
    this.customLightColors,
    this.customDarkColors,
  });

  @override
  State<ThemedShimmerContainer> createState() => _ThemedShimmerContainerState();
}

class _ThemedShimmerContainerState extends State<ThemedShimmerContainer> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<Color> _getGradientColors(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    if (brightness == Brightness.light) {
      return widget.customLightColors ?? ShimmerTheme.lightShimmerColors;
    } else {
      return widget.customDarkColors ?? ShimmerTheme.darkShimmerColors;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius ?? 8),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.1, 0.3, 0.5, 0.7, 0.9],
              colors: _getGradientColors(context),
              transform: GradientRotation(animation.value),
            ),
          ),
        );
      },
    );
  }
}