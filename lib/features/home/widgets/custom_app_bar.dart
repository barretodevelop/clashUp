import 'package:clashup/features/user/providers/user_provider.dart';
import 'package:clashup/models/user_model.dart';
import 'package:clashup/services/notification_service.dart'; // Import NotificationService
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override // Changed to ConsumerWidget
  Widget build(BuildContext context, WidgetRef ref) {
    final UserModel? userModel = ref.watch(userProvider); // Watch the UserModel
    final theme = Theme.of(context);

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: theme.colorScheme.onSurface,
      leading: _NotificationButton(
        // Changed to ConsumerStatefulWidget
        onPressed: onNotificationsPressed,
        hasNotifications: true, // Você pode conectar isso ao seu estado
      ),
      title: _GreetingSection(userModel: userModel), // Pass userModel
      actions: [
        _EconomyWidget(userData: userModel), // Pass userModel
        const SizedBox(width: 8),
        // _ProfileButton(onPressed: onPersonPressed),
        // const SizedBox(width: 8),
        _SettingsButton(onPressed: onSettingsPressed),
        const SizedBox(width: 16),
      ],
    );
  }
}

class _NotificationButton extends ConsumerStatefulWidget {
  final VoidCallback onPressed;
  final bool hasNotifications;

  const _NotificationButton({
    super.key,
    required this.onPressed,
    required this.hasNotifications,
  });

  @override
  ConsumerState<_NotificationButton> createState() =>
      _NotificationButtonState();
}

class _NotificationButtonState extends ConsumerState<_NotificationButton> {
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    // Listen to notification stream to update count
    NotificationService.onNotificationsReceived.listen((notifications) {
      setState(() {
        _notificationCount = notifications.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: Colors.amber,
          ),
          onPressed: () => _showNotificationBottomSheet(context),
          color: theme.colorScheme.onSurface,
        ),
        if (_notificationCount > 0)
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
        if (_notificationCount > 0)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$_notificationCount',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  void _showNotificationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to be full height
      builder: (BuildContext bc) {
        return _NotificationBottomSheet();
      },
    );
  }
}

class _NotificationBottomSheet extends ConsumerWidget {
  const _NotificationBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = NotificationService.getAllNotifications();
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8, // 80% of screen height
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notificações',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: notifications.isEmpty
                ? Center(
                    child: Text(
                      'Nenhuma notificação por enquanto.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return ListTile(
                        leading: Icon(Icons.message,
                            color: theme.colorScheme.primary),
                        title: Text(notification['title'] ?? 'Sem título'),
                        subtitle: Text(notification['body'] ?? 'Sem conteúdo'),
                        onTap: () {
                          // Handle notification tap, e.g., navigate to detail screen
                          Navigator.pop(context); // Close bottom sheet
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  // Now takes UserModel
  final UserModel? userModel;
  const _GreetingSection({this.userModel});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final theme = Theme.of(context);
    String greeting;
    final String displayName = userModel?.displayName ?? 'Anônimo';

    if (hour < 12) {
      greeting = 'Bom dia';
    } else if (hour < 18) {
      greeting = 'Boa tarde';
    } else {
      greeting = 'Boa noite';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          greeting,
          style: theme.textTheme.titleMedium?.copyWith(
            // fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          displayName, // Use user's display name
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class _EconomyWidget extends StatefulWidget {
  // Now takes UserModel?
  final UserModel? userData;

  const _EconomyWidget({this.userData});

  @override
  State<_EconomyWidget> createState() => _EconomyWidgetState();
}

class _EconomyWidgetState extends State<_EconomyWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.monetization_on,
              size: 16,
              color: Theme.of(context).colorScheme.primary, // Use colorScheme
            ),
            const SizedBox(width: 4),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isExpanded
                  ? _ExpandedEconomyView(
                      userData: widget.userData) // Pass nullable
                  : _CompactEconomyView(
                      userData: widget.userData), // Pass nullable
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactEconomyView extends StatelessWidget {
  // Now takes UserModel
  final UserModel? userData;

  const _CompactEconomyView({this.userData}); // Made nullable

  @override
  Widget build(BuildContext context) {
    return Text(
      '${userData?.coins ?? 0}', // Handle null userData
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }
}

class _ExpandedEconomyView extends StatelessWidget {
  // Now takes UserModel
  final UserModel? userData;

  const _ExpandedEconomyView({this.userData}); // Made nullable

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${userData?.coins ?? 0}', // Handle null userData
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.star,
          size: 12,
          color: Theme.of(context).colorScheme.secondary,
        ),
        Text(
          '${userData?.xp ?? 0}', // Handle null userData
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
      ],
    );
  }
}

class _ProfileButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ProfileButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.7),
          ],
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: const Icon(
          Icons.person,
          size: 18,
          color: Colors.white,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SettingsButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      icon: const Icon(Icons.settings_outlined),
      onPressed: onPressed,
      color: theme.colorScheme.onSurface.withOpacity(0.7),
    );
  }
}
