// CommunityHeader - Header com info da comunidade
// Arquivo criado automaticamente pelo script de estrutura
// Data: 2025-06-27 13:56:53
// Projeto: ClashUp - Sistema de Comunidades

// TODO: Implementar a classe/funcionalidade

// lib/features/communities/widgets/community_header.dart
// CommunityHeader - Header com informações da comunidade
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clashup/features/communities/constants/community_constants.dart';
import 'package:clashup/features/communities/models/community_model.dart';
import 'package:clashup/features/communities/widgets/community_badge_widget.dart';
import 'package:clashup/features/communities/widgets/community_join_button.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

enum CommunityHeaderStyle {
  compact, // Para uso em listas
  detailed, // Para tela de detalhes
  banner, // Para topo de tela com banner
}

class CommunityHeader extends StatelessWidget {
  final CommunityModel community;
  final CommunityHeaderStyle style;
  final bool isUserMember;
  final bool canModerate;
  final VoidCallback? onJoin;
  final VoidCallback? onLeave;
  final VoidCallback? onEdit;
  final VoidCallback? onShare;
  final VoidCallback? onReport;
  final Widget? customActions;

  const CommunityHeader({
    super.key,
    required this.community,
    this.style = CommunityHeaderStyle.detailed,
    this.isUserMember = false,
    this.canModerate = false,
    this.onJoin,
    this.onLeave,
    this.onEdit,
    this.onShare,
    this.onReport,
    this.customActions,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case CommunityHeaderStyle.compact:
        return _buildCompactHeader(context);
      case CommunityHeaderStyle.detailed:
        return _buildDetailedHeader(context);
      case CommunityHeaderStyle.banner:
        return _buildBannerHeader(context);
    }
  }

  Widget _buildCompactHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          // Avatar da comunidade
          _buildCommunityAvatar(context, 40),

          const SizedBox(width: 12),

          // Informações básicas
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
                    _buildStatusBadges(compact: true),
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
                    Expanded(
                      child: Text(
                        '${community.membersCount} membros • ${community.category.displayName}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Ações
          CommunityJoinButton(
            community: community,
            isUserMember: isUserMember,
            onJoin: onJoin,
            onLeave: onLeave,
            size: CommunityJoinButtonSize.small,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Primeira linha: Avatar, Nome, Ações
          Row(
            children: [
              _buildCommunityAvatar(context, 64),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome e badges
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            community.name,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildStatusBadges(),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Categoria e privacidade
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(community.category.emoji,
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 4),
                              Text(
                                community.category.displayName,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildPrivacyIndicator(theme),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Menu de ações
              _buildActionsMenu(context),
            ],
          ),

          const SizedBox(height: 16),

          // Descrição
          if (community.description.isNotEmpty) ...[
            Text(
              community.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
          ],

          // Estatísticas rápidas
          Row(
            children: [
              _buildStatChip(
                theme,
                Icons.people,
                community.membersCount.toString(),
                'membros',
              ),
              const SizedBox(width: 12),
              _buildStatChip(
                theme,
                Icons.message,
                community.postsCount.toString(),
                'posts',
              ),
              const SizedBox(width: 12),
              _buildLevelChip(theme),

              const Spacer(),

              // Data de criação
              Text(
                'Criada ${timeago.format(community.createdAt, locale: 'pt_BR')}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Botão principal
          SizedBox(
            width: double.infinity,
            child: CommunityJoinButton(
              community: community,
              isUserMember: isUserMember,
              onJoin: onJoin,
              onLeave: onLeave,
              size: CommunityJoinButtonSize.large,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 280,
      child: Stack(
        children: [
          // Banner de fundo
          Container(
            height: 200,
            width: double.infinity,
            child: community.hasBanner
                ? CachedNetworkImage(
                    imageUrl: community.bannerUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        _buildBannerPlaceholder(theme),
                    errorWidget: (context, url, error) =>
                        _buildBannerPlaceholder(theme),
                  )
                : _buildBannerPlaceholder(theme),
          ),

          // Overlay gradient
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),

          // Conteúdo sobreposto
          Positioned(
            bottom: 0,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // Avatar elevado
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: community.hasImage
                        ? CachedNetworkImage(
                            imageUrl: community.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                _buildAvatarPlaceholder(theme),
                            errorWidget: (context, url, error) =>
                                _buildAvatarPlaceholder(theme),
                          )
                        : _buildAvatarPlaceholder(theme),
                  ),
                ),

                const SizedBox(height: 12),

                // Card de informações
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Nome e badges
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              community.name,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Status badges
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStatusBadges(),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Stats inline
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildBannerStat(
                              context, '${community.membersCount}', 'Membros'),
                          _buildBannerStat(
                              context, '${community.postsCount}', 'Posts'),
                          _buildBannerStat(
                              context,
                              'Nv.${CommunityConstants.calculateCommunityLevel(community.membersCount)}',
                              'Nível'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Ações no canto superior direito
          Positioned(
            top: 40,
            right: 20,
            child: _buildBannerActions(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityAvatar(BuildContext context, double size) {
    final theme = Theme.of(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.2),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.2 - 1),
        child: community.hasImage
            ? CachedNetworkImage(
                imageUrl: community.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildAvatarPlaceholder(theme),
                errorWidget: (context, url, error) =>
                    _buildAvatarPlaceholder(theme),
              )
            : _buildAvatarPlaceholder(theme),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          community.category.emoji,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildBannerPlaceholder(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.3),
            theme.colorScheme.secondary.withOpacity(0.3),
          ],
        ),
      ),
      child: Center(
        child: Text(
          community.category.emoji,
          style: const TextStyle(fontSize: 60),
        ),
      ),
    );
  }

  Widget _buildStatusBadges({bool compact = false}) {
    final badges = <Widget>[];

    if (community.isVerified) {
      badges.add(CommunityBadgeWidget(
        type: CommunityBadgeType.verified,
        size: compact ? CommunityBadgeSize.small : CommunityBadgeSize.medium,
      ));
    }

    if (community.isPremium) {
      badges.add(CommunityBadgeWidget(
        type: CommunityBadgeType.premium,
        size: compact ? CommunityBadgeSize.small : CommunityBadgeSize.medium,
      ));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: badges
          .map((badge) => Padding(
                padding: const EdgeInsets.only(left: 4),
                child: badge,
              ))
          .toList(),
    );
  }

  Widget _buildPrivacyIndicator(ThemeData theme) {
    IconData icon;
    Color color;
    String tooltip;

    switch (community.privacyType) {
      case CommunityPrivacyType.public:
        icon = Icons.public;
        color = Colors.green;
        tooltip = 'Comunidade Pública';
        break;
      case CommunityPrivacyType.private:
        icon = Icons.lock;
        color = Colors.red;
        tooltip = 'Comunidade Privada';
        break;
      case CommunityPrivacyType.restricted:
        icon = Icons.lock_open;
        color = Colors.orange;
        tooltip = 'Comunidade Restrita';
        break;
    }

    return Tooltip(
      message: tooltip,
      child: Icon(
        icon,
        size: 16,
        color: color,
      ),
    );
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
            ),
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              fontSize: 11,
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
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerStat(BuildContext context, String value, String label) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildActionsMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
      onSelected: (action) => _handleAction(action),
      itemBuilder: (context) => [
        if (onShare != null)
          const PopupMenuItem(
            value: 'share',
            child: Row(
              children: [
                Icon(Icons.share, size: 16),
                SizedBox(width: 8),
                Text('Compartilhar'),
              ],
            ),
          ),
        if (canModerate && onEdit != null)
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, size: 16),
                SizedBox(width: 8),
                Text('Editar Comunidade'),
              ],
            ),
          ),
        if (onReport != null)
          const PopupMenuItem(
            value: 'report',
            child: Row(
              children: [
                Icon(Icons.flag, size: 16, color: Colors.red),
                SizedBox(width: 8),
                Text('Reportar', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildBannerActions(BuildContext context) {
    return Row(
      children: [
        if (onShare != null)
          _buildBannerActionButton(
            Icons.share,
            onShare!,
            'Compartilhar',
          ),
        const SizedBox(width: 8),
        if (canModerate && onEdit != null)
          _buildBannerActionButton(
            Icons.edit,
            onEdit!,
            'Editar',
          ),
      ],
    );
  }

  Widget _buildBannerActionButton(
      IconData icon, VoidCallback onTap, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(icon, size: 20),
          onPressed: onTap,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  void _handleAction(String action) {
    switch (action) {
      case 'share':
        onShare?.call();
        break;
      case 'edit':
        onEdit?.call();
        break;
      case 'report':
        onReport?.call();
        break;
    }
  }
}
