import 'package:flutter/material.dart';

/// A reusable widget to apply a linear gradient background.
///
/// This widget can be used to apply a gradient to any child widget.
/// It defaults to a dark or light gradient based on the current theme's brightness.
class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final List<double>? stops;

  const GradientBackground({
    Key? key,
    required this.child,
    this.colors,
    this.stops,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultColors = isDark
        ? [Colors.black, Colors.grey[900]!, Colors.grey[800]!]
        : [Colors.deepPurple, Colors.deepPurple[300]!, Colors.white];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors ?? defaultColors,
          stops: stops ?? const [0.0, 0.3, 1.0],
        ),
      ),
      child: child,
    );
  }
}
