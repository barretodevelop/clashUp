import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final List<double>? stops;

  const GradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.stops,
  });

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
