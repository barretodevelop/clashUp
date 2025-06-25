import 'package:aplicativo_social/features/home/presentation/widgets/economy_chip.dart';
import 'package:aplicativo_social/features/user/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A custom AppBar that includes user greeting and compact economy data.
class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final VoidCallback onPersonPressed;
  final VoidCallback onSettingsPressed;
  final VoidCallback onNotificationsPressed;

  const CustomAppBar({
    super.key,
    required this.onPersonPressed,
    required this.onSettingsPressed,
    required this.onNotificationsPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(
      kToolbarHeight + 40.0); // Increased height for compact chips

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Removed 'brightness' as it was undefined. 'isDarkMode' is correctly derived from Theme.
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final UserDataState userData =
        ref.watch(userProvider); // FIX: Define userData

    return AppBar(
      // Removed explicit backgroundColor and foregroundColor to rely on AppBarTheme
      // defined in app_theme.dart for better theme consistency.
      leading: IconButton(
        icon: const Icon(Icons
            .notifications), // Color will be inherited from AppBarTheme.foregroundColor
        onPressed: onNotificationsPressed,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Olá, Anônimo", // AppStrings.hello,
            style: TextStyle(
                fontSize:
                    18), // Text color will be inherited from AppBarTheme.foregroundColor or TextTheme
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CompactEconomyChip(
                icon: Icons.monetization_on,
                value: userData.coins, // FIX: userData is now defined
              ),
              const SizedBox(width: 8),
              CompactEconomyChip(
                  icon: Icons.star,
                  value: userData.xp), // FIX: userData is now defined
              const SizedBox(width: 8),
              CompactEconomyChip(
                  icon: Icons.diamond,
                  value: userData.gems), // FIX: userData is now defined
            ],
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.person), // Color will be inherited
          onPressed: onPersonPressed,
        ),
        IconButton(
          icon: const Icon(Icons.settings), // Color will be inherited
          onPressed: onSettingsPressed,
        ),
      ],
    );
  }
}
