import 'package:flutter/material.dart';

/// Gradiente de fundo que realmente funciona
class WorkingGradientBackground extends StatelessWidget {
  final Widget child;

  const WorkingGradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  const Color(0xFF1A1A1F), // Topo escuro
                  const Color(0xFF242429), // Meio
                  const Color(0xFF1E1E24), // Base
                ]
              : [
                  const Color.fromARGB(229, 204, 180, 220), // Topo claro
                  const Color(0xFFEDF2F7), // Meio
                  const Color(0xFFE2E8F0), // Base azulada
                ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}
