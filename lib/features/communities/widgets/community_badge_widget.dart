// CommunityBadgeWidget - Badges e conquistas
// Arquivo criado automaticamente pelo script de estrutura
// Data: 2025-06-27 13:56:53
// Projeto: ClashUp - Sistema de Comunidades

// TODO: Implementar a classe/funcionalidade
// lib/features/communities/widgets/community_badge_widget.dart
// CommunityBadgeWidget - Badges e conquistas das comunidades
import 'package:clashup/features/communities/constants/community_constants.dart';
import 'package:flutter/material.dart';

enum CommunityBadgeType {
  verified, // Comunidade verificada
  premium, // Comunidade premium
  popular, // Comunidade popular
  trending, // Em alta
  newCommunity, // Nova comunidade
  featured, // Em destaque
  official, // Oficial
  partner, // Parceira
}

enum CommunityBadgeSize {
  small, // 16x16
  medium, // 20x20
  large, // 24x24
  extraLarge, // 32x32
}

class CommunityBadgeWidget extends StatelessWidget {
  final CommunityBadgeType type;
  final CommunityBadgeSize size;
  final bool showTooltip;
  final String? customTooltip;
  final Color? customColor;
  final bool animated;

  const CommunityBadgeWidget({
    super.key,
    required this.type,
    this.size = CommunityBadgeSize.medium,
    this.showTooltip = true,
    this.customTooltip,
    this.customColor,
    this.animated = false,
  });

  @override
  Widget build(BuildContext context) {
    final badge = _buildBadge(context);

    if (!showTooltip) {
      return badge;
    }

    return Tooltip(
      message: customTooltip ?? _getTooltipMessage(),
      child: badge,
    );
  }

  Widget _buildBadge(BuildContext context) {
    final icon = _buildIcon(context);

    if (animated) {
      return _AnimatedBadge(child: icon);
    }

    return icon;
  }

  Widget _buildIcon(BuildContext context) {
    final iconData = _getIconData();
    final color = customColor ?? _getColor(context);
    final iconSize = _getIconSize();

    return Icon(
      iconData,
      color: color,
      size: iconSize,
    );
  }

  IconData _getIconData() {
    switch (type) {
      case CommunityBadgeType.verified:
        return Icons.verified;
      case CommunityBadgeType.premium:
        return Icons.star;
      case CommunityBadgeType.popular:
        return Icons.trending_up;
      case CommunityBadgeType.trending:
        return Icons.whatshot;
      case CommunityBadgeType.newCommunity:
        return Icons.new_releases;
      case CommunityBadgeType.featured:
        return Icons.featured_play_list;
      case CommunityBadgeType.official:
        return Icons.admin_panel_settings;
      case CommunityBadgeType.partner:
        return Icons.handshake;
    }
  }

  Color _getColor(BuildContext context) {
    final theme = Theme.of(context);

    switch (type) {
      case CommunityBadgeType.verified:
        return Colors.blue;
      case CommunityBadgeType.premium:
        return Colors.amber;
      case CommunityBadgeType.popular:
        return Colors.green;
      case CommunityBadgeType.trending:
        return Colors.red;
      case CommunityBadgeType.newCommunity:
        return Colors.purple;
      case CommunityBadgeType.featured:
        return theme.colorScheme.primary;
      case CommunityBadgeType.official:
        return Colors.indigo;
      case CommunityBadgeType.partner:
        return Colors.orange;
    }
  }

  double _getIconSize() {
    switch (size) {
      case CommunityBadgeSize.small:
        return 16;
      case CommunityBadgeSize.medium:
        return 20;
      case CommunityBadgeSize.large:
        return 24;
      case CommunityBadgeSize.extraLarge:
        return 32;
    }
  }

  String _getTooltipMessage() {
    switch (type) {
      case CommunityBadgeType.verified:
        return 'Comunidade Verificada';
      case CommunityBadgeType.premium:
        return 'Comunidade Premium';
      case CommunityBadgeType.popular:
        return 'Comunidade Popular';
      case CommunityBadgeType.trending:
        return 'Em Alta';
      case CommunityBadgeType.newCommunity:
        return 'Nova Comunidade';
      case CommunityBadgeType.featured:
        return 'Em Destaque';
      case CommunityBadgeType.official:
        return 'Comunidade Oficial';
      case CommunityBadgeType.partner:
        return 'Comunidade Parceira';
    }
  }
}

/// Widget animado para badges
class _AnimatedBadge extends StatefulWidget {
  final Widget child;

  const _AnimatedBadge({required this.child});

  @override
  State<_AnimatedBadge> createState() => _AnimatedBadgeState();
}

class _AnimatedBadgeState extends State<_AnimatedBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _pulseAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Widget para exibir múltiplos badges em linha
class CommunityBadgeRow extends StatelessWidget {
  final List<CommunityBadgeType> badges;
  final CommunityBadgeSize size;
  final double spacing;
  final bool animated;

  const CommunityBadgeRow({
    super.key,
    required this.badges,
    this.size = CommunityBadgeSize.medium,
    this.spacing = 4,
    this.animated = false,
  });

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: badges.asMap().entries.map((entry) {
        final index = entry.key;
        final badge = entry.value;

        return Padding(
          padding: EdgeInsets.only(
            left: index > 0 ? spacing : 0,
          ),
          child: CommunityBadgeWidget(
            type: badge,
            size: size,
            animated: animated,
          ),
        );
      }).toList(),
    );
  }
}

/// Widget para badge de conquista do usuário
class UserCommunityBadge extends StatelessWidget {
  final String badgeId;
  final int quantity;
  final bool showQuantity;
  final CommunityBadgeSize size;
  final VoidCallback? onTap;

  const UserCommunityBadge({
    super.key,
    required this.badgeId,
    this.quantity = 1,
    this.showQuantity = true,
    this.size = CommunityBadgeSize.medium,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeConfig = CommunityConstants.communityBadges[badgeId];

    if (badgeConfig == null) {
      return const SizedBox.shrink();
    }

    final badgeSize = _getBadgeSize();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: badgeSize,
        height: badgeSize,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withOpacity(0.2),
          borderRadius: BorderRadius.circular(badgeSize / 4),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            // Badge principal
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    badgeConfig['emoji'] ?? '🏅',
                    style: TextStyle(fontSize: _getEmojiSize()),
                  ),
                  if (size != CommunityBadgeSize.small) ...[
                    const SizedBox(height: 2),
                    Text(
                      badgeConfig['name'] ?? 'Badge',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: _getTextSize(),
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Quantidade (se maior que 1)
            if (showQuantity && quantity > 1)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.surface,
                      width: 1,
                    ),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    quantity.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  double _getBadgeSize() {
    switch (size) {
      case CommunityBadgeSize.small:
        return 32;
      case CommunityBadgeSize.medium:
        return 48;
      case CommunityBadgeSize.large:
        return 64;
      case CommunityBadgeSize.extraLarge:
        return 80;
    }
  }

  double _getEmojiSize() {
    switch (size) {
      case CommunityBadgeSize.small:
        return 16;
      case CommunityBadgeSize.medium:
        return 20;
      case CommunityBadgeSize.large:
        return 24;
      case CommunityBadgeSize.extraLarge:
        return 32;
    }
  }

  double _getTextSize() {
    switch (size) {
      case CommunityBadgeSize.small:
        return 8;
      case CommunityBadgeSize.medium:
        return 9;
      case CommunityBadgeSize.large:
        return 10;
      case CommunityBadgeSize.extraLarge:
        return 12;
    }
  }
}

/// Widget para exibir grid de badges do usuário
class UserCommunityBadgeGrid extends StatelessWidget {
  final Map<String, int> badges;
  final int maxVisible;
  final CommunityBadgeSize size;
  final VoidCallback? onViewAll;

  const UserCommunityBadgeGrid({
    super.key,
    required this.badges,
    this.maxVisible = 6,
    this.size = CommunityBadgeSize.medium,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (badges.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.emoji_events,
              size: 32,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'Nenhuma conquista ainda',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Participe das comunidades para ganhar badges!',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final visibleBadges = badges.entries.take(maxVisible).toList();
    final remainingCount = badges.length - visibleBadges.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Icon(
              Icons.emoji_events,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Conquistas da Comunidade',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (remainingCount > 0 && onViewAll != null)
              TextButton(
                onPressed: onViewAll,
                child: Text('Ver todas (${badges.length})'),
              ),
          ],
        ),

        const SizedBox(height: 12),

        // Grid de badges
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            // Badges visíveis
            ...visibleBadges.map((entry) => UserCommunityBadge(
                  badgeId: entry.key,
                  quantity: entry.value,
                  size: size,
                  onTap: () => _showBadgeDetails(context, entry.key),
                )),

            // Botão "ver mais" se houver badges ocultos
            if (remainingCount > 0 && onViewAll != null)
              GestureDetector(
                onTap: onViewAll,
                child: Container(
                  width: _getBadgeSize(),
                  height: _getBadgeSize(),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(_getBadgeSize() / 4),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          size: _getIconSize(),
                        ),
                        if (size != CommunityBadgeSize.small) ...[
                          const SizedBox(height: 2),
                          Text(
                            '+$remainingCount',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: _getTextSize(),
                              fontWeight: FontWeight.w600,
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _showBadgeDetails(BuildContext context, String badgeId) {
    final badgeConfig = CommunityConstants.communityBadges[badgeId];
    if (badgeConfig == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(badgeConfig['emoji'] ?? '🏅',
                style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Expanded(child: Text(badgeConfig['name'] ?? 'Badge')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(badgeConfig['description'] ?? 'Descrição não disponível'),
            const SizedBox(height: 16),
            if (badgeConfig['xpReward'] != null)
              Text(
                'XP concedido: ${badgeConfig['xpReward']}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  double _getBadgeSize() {
    switch (size) {
      case CommunityBadgeSize.small:
        return 32;
      case CommunityBadgeSize.medium:
        return 48;
      case CommunityBadgeSize.large:
        return 64;
      case CommunityBadgeSize.extraLarge:
        return 80;
    }
  }

  double _getIconSize() {
    switch (size) {
      case CommunityBadgeSize.small:
        return 12;
      case CommunityBadgeSize.medium:
        return 16;
      case CommunityBadgeSize.large:
        return 20;
      case CommunityBadgeSize.extraLarge:
        return 24;
    }
  }

  double _getTextSize() {
    switch (size) {
      case CommunityBadgeSize.small:
        return 8;
      case CommunityBadgeSize.medium:
        return 9;
      case CommunityBadgeSize.large:
        return 10;
      case CommunityBadgeSize.extraLarge:
        return 12;
    }
  }
}
