import 'package:clashup/features/home/presentation/widgets/user_mode_card.dart';
import 'package:clashup/features/user/providers/user_provider.dart';
import 'package:clashup/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeContent extends ConsumerStatefulWidget {
  final ValueChanged<int> onNavigateToTab;

  const HomeContent({Key? key, required this.onNavigateToTab})
      : super(key: key);

  @override
  ConsumerState<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends ConsumerState<HomeContent>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Welcome Section com animação fade
          // Pass userModel to WelcomeSection
          FadeTransition(
            opacity: _fadeAnimation,
            child: _WelcomeSection(userModel: ref.watch(userProvider)),
          ),

          const SizedBox(height: 32),

          // User Mode Card com animação slide
          SlideTransition(
            position: _slideAnimation,
            child: const OptimizedUserModeCard(),
          ),

          const SizedBox(height: 40),

          // Quick Actions com staggered animation
          _QuickActionsGrid(
            onNavigateToTab: widget.onNavigateToTab,
            slideAnimation: _slideAnimation,
          ),
        ],
      ),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  // Now takes UserModel
  final UserModel? userModel;
  const _WelcomeSection({this.userModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // Removed diagonal gradient to allow global vertical gradient to show
        // Using a subtle surface color from the theme instead.
        color: theme.colorScheme.surface,
        // Optional: Add a subtle linear gradient if desired, but ensure it's vertical
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.surface.withOpacity(0.1),
            theme.colorScheme.surfaceBright.withOpacity(0.1)
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Pass userModel to _ProfileAvatar
          _ProfileAvatar(userModel: userModel),
          const SizedBox(height: 16),

          Text(
            'Bem-vindo de volta!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            'Descubra novas conexões e viva experiências únicas',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  // Now takes UserModel
  final UserModel? userModel;
  const _ProfileAvatar({this.userModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String avatarUrl =
        userModel?.avatar ?? 'https://via.placeholder.com/150'; // Default image
    final String displayName = userModel?.displayName ?? 'Anônimo';

    return Container(
      // This container defines the overall shape and border
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Removed gradient for a simpler background or image
        color: theme.colorScheme.primary
            .withOpacity(0.1), // Use a subtle background
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        // ClipRRect to ensure the image is rounded
        borderRadius: BorderRadius.circular(
            50), // Half of width/height for circular shape
        child: Image.network(
          avatarUrl,
          fit: BoxFit.cover,
          width: 100,
          height: 100,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: theme.colorScheme.primary,
              ),
            );
          },
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
            return Container(
              color: theme.colorScheme.surfaceVariant,
              child: Center(
                child: Text(
                  displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(color: theme.colorScheme.onSurface),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  final ValueChanged<int> onNavigateToTab;
  final Animation<Offset> slideAnimation;

  const _QuickActionsGrid({
    required this.onNavigateToTab,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionData(
        icon: Icons.radar,
        title: 'Radar de Almas',
        subtitle: 'Descubra conexões',
        onTap: () => onNavigateToTab(1),
        delay: 0,
      ),
      _ActionData(
        icon: Icons.people,
        title: 'Amigos',
        subtitle: 'Suas conexões',
        onTap: () => onNavigateToTab(2),
        delay: 100,
      ),
      _ActionData(
        icon: Icons.group,
        title: 'Comunidades',
        subtitle: 'Encontre grupos',
        onTap: () => onNavigateToTab(3),
        delay: 200,
      ),
      _ActionData(
        icon: Icons.flag,
        title: 'Desafios',
        subtitle: 'Teste habilidades',
        onTap: () => onNavigateToTab(4),
        delay: 300,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acesso Rápido',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        ...actions
            .map((action) => _AnimatedActionCard(
                  action: action,
                  slideAnimation: slideAnimation,
                ))
            .toList(),
      ],
    );
  }
}

class _ActionData {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final int delay;

  const _ActionData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.delay,
  });
}

class _AnimatedActionCard extends StatefulWidget {
  final _ActionData action;
  final Animation<Offset> slideAnimation;

  const _AnimatedActionCard({
    required this.action,
    required this.slideAnimation,
  });

  @override
  State<_AnimatedActionCard> createState() => _AnimatedActionCardState();
}

class _AnimatedActionCardState extends State<_AnimatedActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: widget.slideAnimation,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Material(
                elevation: _isHovered ? 8 : 2,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: widget.action.onTap,
                  onHover: _onHover,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: _isHovered
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.08),
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.03),
                              ],
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            widget.action.icon,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.action.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.action.subtitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withOpacity(0.7),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
