import 'package:flutter/material.dart';

/// Fundo gradiente melhorado para o app inteiro
class ImprovedGradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final List<double>? stops;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const ImprovedGradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.stops,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Cores mais balanceadas baseadas no tema
    final defaultColors = isDark
        ? [
            const Color(0xFF1A1A1F), // Fundo escuro principal
            const Color(0xFF242429), // Meio termo
            const Color(0xFF2A2A2F), // Mais claro no final
          ]
        : [
            const Color(0xFFF8F9FA), // Fundo claro principal
            const Color(0xFFEEF2F7), // Meio termo
            const Color(0xFFE1E8ED), // Final com leve tom azulado
          ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors ?? defaultColors,
          stops: stops ?? const [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}

/// Versão alternativa com gradiente muito sutil
class SubtleGradientBackground extends StatelessWidget {
  final Widget child;

  const SubtleGradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final surface = theme.colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            surface,
            primary.withOpacity(0.02),
            surface,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}

/// Versão para usar como overlay em cards
class CardGradientOverlay extends StatelessWidget {
  final Widget child;
  final bool isPressed;

  const CardGradientOverlay({
    super.key,
    required this.child,
    this.isPressed = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        gradient: isPressed
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primary.withOpacity(0.08),
                  primary.withOpacity(0.03),
                ],
              )
            : null,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
