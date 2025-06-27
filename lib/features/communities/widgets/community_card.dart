// CommunityCard - Card de comunidade na lista
// Arquivo criado automaticamente pelo script de estrutura
// Data: 2025-06-27 13:56:53
// Projeto: ClashUp - Sistema de Comunidades

// TODO: Implementar a classe/funcionalidade
// lib/features/communities/widgets/community_card.dart
// CommunityCard - Card de comunidade na lista
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clashup/features/communities/constants/community_constants.dart';
import 'package:clashup/features/communities/models/community_model.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommunityCard extends StatelessWidget {
  final CommunityModel community;
  final VoidCallback? onTap;
  final VoidCallback? onJoin;
  final VoidCallback? onLeave;
  final bool isJoined;
  final bool showJoinButton;
  final bool isCompact;

  const CommunityCard({
    super.key,
    required this.community,
    this.onTap,
    this.onJoin,
    this.onLeave,
    this.isJoined = false,
    this.showJoinButton = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              isCompact ? _buildCompactLayout(theme) : _buildFullLayout(theme),
        ),
      ),
    );
  }

  Widget _buildFullLayout(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header com imagem e informações básicas
        Row(
          children: [
            _buildCommunityImage(theme, size: 56),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          community.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (community.isVerified) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.verified,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                      if (community.isPremium) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        community.category.emoji,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        community.category.displayName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildPrivacyIcon(theme),
                    ],
                  ),
                ],
              ),
            ),
            if (showJoinButton) _buildJoinButton(theme),
          ],
        ),

        const SizedBox(height: 12),

        // Descrição
        Text(
          community.description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 12),

        // Estatísticas e informações adicionais
        Row(
          children: [
            _buildStatChip(
              theme,
              Icons.people,
              '${community.membersCount}',
              'membros',
            ),
            const SizedBox(width: 8),
            _buildStatChip(
              theme,
              Icons.message,
              '${community.postsCount}',
              'posts',
            ),
            const SizedBox(width: 8),
            _buildLevelChip(theme),
            const Spacer(),
            Text(
              'Criada ${timeago.format(community.createdAt, locale: 'pt_BR')}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),

        // Tags (se houver)
        if (community.tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildTags(theme),
        ],
      ],
    );
  }

  Widget _buildCompactLayout(ThemeData theme) {
    return Row(
      children: [
        _buildCommunityImage(theme, size: 40),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      community.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (community.isVerified)
                    Icon(
                      Icons.verified,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    community.category.emoji,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${community.membersCount} membros',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showJoinButton) _buildJoinButton(theme, compact: true),
      ],
    );
  }

  Widget _buildCommunityImage(ThemeData theme, {required double size}) {
    if (community.hasImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: community.imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildImagePlaceholder(theme, size),
          errorWidget: (context, url, error) =>
              _buildImagePlaceholder(theme, size),
        ),
      );
    } else {
      return _buildImagePlaceholder(theme, size);
    }
  }

  Widget _buildImagePlaceholder(ThemeData theme, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Center(
        child: Text(
          community.category.emoji,
          style: TextStyle(fontSize: size * 0.4),
        ),
      ),
    );
  }

  Widget _buildPrivacyIcon(ThemeData theme) {
    IconData icon;
    Color color;

    switch (community.privacyType) {
      case CommunityPrivacyType.public:
        icon = Icons.public;
        color = Colors.green;
        break;
      case CommunityPrivacyType.private:
        icon = Icons.lock;
        color = Colors.red;
        break;
      case CommunityPrivacyType.restricted:
        icon = Icons.lock_open;
        color = Colors.orange;
        break;
    }

    return Icon(
      icon,
      size: 14,
      color: color,
    );
  }

  Widget _buildJoinButton(ThemeData theme, {bool compact = false}) {
    if (isJoined) {
      return TextButton.icon(
        onPressed: onLeave,
        icon: Icon(
          Icons.check,
          size: compact ? 16 : 18,
        ),
        label: Text(compact ? 'Membro' : 'Saindo'),
        style: TextButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 8 : 12,
            vertical: compact ? 4 : 8,
          ),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: onJoin,
        icon: Icon(
          Icons.add,
          size: compact ? 16 : 18,
        ),
        label: Text(compact ? 'Entrar' : 'Participar'),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 8 : 12,
            vertical: compact ? 4 : 8,
          ),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }
  }

  Widget _buildStatChip(
      ThemeData theme, IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelChip(ThemeData theme) {
    final level =
        CommunityConstants.calculateCommunityLevel(community.membersCount);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: 14,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 2),
          Text(
            'Nv. $level',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags(ThemeData theme) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: community.tags.take(3).map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.outline.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: Text(
            '#$tag',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontSize: 11,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Variação do card para uso em listas horizontais
class CommunityCardHorizontal extends StatelessWidget {
  final CommunityModel community;
  final VoidCallback? onTap;
  final bool isJoined;

  const CommunityCardHorizontal({
    super.key,
    required this.community,
    this.onTap,
    this.isJoined = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner ou imagem da comunidade
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: community.hasBanner
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: community.bannerUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              _buildBannerPlaceholder(theme),
                          errorWidget: (context, url, error) =>
                              _buildBannerPlaceholder(theme),
                        ),
                      )
                    : _buildBannerPlaceholder(theme),
              ),

              // Conteúdo
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              community.name,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (community.isVerified)
                            Icon(
                              Icons.verified,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        community.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            community.category.emoji,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${community.membersCount} membros',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                            ),
                          ),
                          if (isJoined)
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerPlaceholder(ThemeData theme) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.secondary.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Text(
          community.category.emoji,
          style: const TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
