import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/app_strings.dart';
import '../../../providers/theme_provider.dart';
import '../../../shared/widgets/animated_button.dart';

class ThemeSelectionDialog extends ConsumerWidget {
  const ThemeSelectionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(AppStrings.selectTheme),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ThemeOptionTile(
            leading: const Icon(Icons.light_mode),
            title: const Text(AppStrings.lightTheme),
            onTap: () {
              ref.read(appThemeProvider.notifier).setTheme(ThemeMode.light);
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 8),
          _ThemeOptionTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text(AppStrings.darkTheme),
            onTap: () {
              ref.read(appThemeProvider.notifier).setTheme(ThemeMode.dark);
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 8),
          _ThemeOptionTile(
            leading: const Icon(Icons.auto_mode),
            title: const Text('Sistema'),
            onTap: () {
              ref.read(appThemeProvider.notifier).setTheme(ThemeMode.system);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.leading,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onPressed: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        ),
        child: ListTile(
          leading: leading,
          title: title,
          onTap: null,
        ),
      ),
    );
  }
}
