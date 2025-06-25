import 'package:flutter/material.dart';

/// A reusable widget to display a single economy metric (e.g., coins, XP, gems).
/// (Kept for completeness, though no longer used in HomeContent)
class _EconomyChip extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;

  const _EconomyChip({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(icon, color: Theme.of(context).primaryColor, size: 30),
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color
                    ?.withOpacity(0.7),
              ),
        ),
      ],
    );
  }
}

/// A compact widget to display a single economy metric in the AppBar.
class CompactEconomyChip extends StatelessWidget {
  final IconData icon;
  final int value;

  const CompactEconomyChip(
      {super.key, required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    // Use AppBarTheme.foregroundColor to ensure text and icon colors adapt to the AppBar's background.
    final Color? appBarContentColor =
        Theme.of(context).appBarTheme.foregroundColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, color: appBarContentColor, size: 16), // Use theme color
        const SizedBox(width: 4),
        Text(
          value.toString(),
          style: TextStyle(
              color: appBarContentColor, fontSize: 12), // Use theme color
        ),
      ],
    );
  }
}
