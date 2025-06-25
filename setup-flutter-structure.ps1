# Script de correcao precisa do erro RenderFlex

# CustomAppBar - remove TODOS os Expanded/Flexible problematicos
$customAppBarContent = @'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../shared/widgets/animated_button.dart';
import '../../../user/providers/user_provider.dart';
import 'economy_chip.dart';

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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 40.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userProvider);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.notifications, color: Colors.white),
        onPressed: onNotificationsPressed,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.hello,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              EconomyChip(
                icon: Icons.monetization_on,
                value: userData.coins,
                label: 'Moedas',
              ),
              const SizedBox(width: 8),
              EconomyChip(
                icon: Icons.star,
                value: userData.xp,
                label: 'Experiencia',
              ),
              const SizedBox(width: 8),
              EconomyChip(
                icon: Icons.diamond,
                value: userData.gems,
                label: 'Gemas',
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person, color: Colors.white),
          onPressed: onPersonPressed,
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: onSettingsPressed,
        ),
      ],
    );
  }
}
'@

Set-Content -Path "lib/features/home/presentation/widgets/custom_app_bar.dart" -Value $customAppBarContent -Encoding UTF8

# UserModeCard - remove TODOS os Expanded/Flexible
$userModeCardContent = @'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../shared/widgets/animated_button.dart';
import '../../../user/domain/entities/user_mode.dart';
import '../../../user/providers/user_provider.dart';

class UserModeCard extends ConsumerStatefulWidget {
  const UserModeCard({super.key});

  @override
  ConsumerState<UserModeCard> createState() => _UserModeCardState();
}

class _UserModeCardState extends ConsumerState<UserModeCard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onModeSelected(UserModeEnum selectedMode) {
    final userData = ref.read(userProvider);
    if (userData.userMode != selectedMode) {
      _pulseController.forward().then((_) => _pulseController.reverse());
      ref.read(userProvider.notifier).setUserMode(selectedMode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProvider);
    final currentMode = userData.userMode;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Card(
        elevation: 16,
        shadowColor: currentMode.color.withOpacity(0.3),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                currentMode.color.withOpacity(0.1),
                Colors.white.withOpacity(0.95),
              ],
            ),
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.currentMode,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    currentMode.icon,
                    color: currentMode.color,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    currentMode.displayName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: currentMode.color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: UserModeEnum.values.map((mode) {
                    final isSelected = mode == currentMode;
                    return AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: isSelected ? _pulseAnimation.value : 1.0,
                          child: GestureDetector(
                            onTap: () => _onModeSelected(mode),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8.0),
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? mode.color.withOpacity(0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? mode.color.withOpacity(0.5)
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    mode.icon,
                                    size: isSelected ? 36.0 : 28.0,
                                    color: isSelected ? mode.color : Colors.grey[400],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    mode.displayName,
                                    style: TextStyle(
                                      fontSize: isSelected ? 12.0 : 10.0,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected ? mode.color : Colors.grey[500],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
'@

Set-Content -Path "lib/features/home/presentation/widgets/user_mode_card.dart" -Value $userModeCardContent -Encoding UTF8

# QuickAccessButton - simplificado sem Flexible
$quickAccessButtonContent = @'
import 'package:flutter/material.dart';
import '../../../../shared/widgets/animated_button.dart';

class QuickAccessButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? leadingIcon;

  const QuickAccessButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 8,
          shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
        ),
        child: Row(
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: 24),
              const SizedBox(width: 16),
            ],
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}
'@

Set-Content -Path "lib/features/home/presentation/widgets/quick_access_button.dart" -Value $quickAccessButtonContent -Encoding UTF8

Write-Host "Arquivos corrigidos" -ForegroundColor Green