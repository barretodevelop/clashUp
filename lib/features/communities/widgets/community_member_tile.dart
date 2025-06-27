// CommunityMemberTile - Tile de membro
// Arquivo criado automaticamente pelo script de estrutura
// Data: 2025-06-27 13:56:53
// Projeto: ClashUp - Sistema de Comunidades

// TODO: Implementar a classe/funcionalidade
// lib/features/communities/widgets/community_member_tile.dart
// CommunityMemberTile - Tile de membro da comunidade
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clashup/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

enum MemberRole {
  member,
  moderator,
  creator,
}

class CommunityMemberModel {
  final String userId;
  final String communityId;
  final DateTime joinedAt;
  final MemberRole role;
  final bool isActive;
  final DateTime? lastActivityAt;
  final int postsCount;
  final int commentsCount;

  // Informações do usuário (podem ser carregadas separadamente)
  final UserModel? userInfo;

  const CommunityMemberModel({
    required this.userId,
    required this.communityId,
    required this.joinedAt,
    this.role = MemberRole.member,
    this.isActive = true,
    this.lastActivityAt,
    this.postsCount = 0,
    this.commentsCount = 0,
    this.userInfo,
  });

  CommunityMemberModel copyWith({
    String? userId,
    String? communityId,
    DateTime? joinedAt,
    MemberRole? role,
    bool? isActive,
    DateTime? lastActivityAt,
    int? postsCount,
    int? commentsCount,
    UserModel? userInfo,
  }) {
    return CommunityMemberModel(
      userId: userId ?? this.userId,
      communityId: communityId ?? this.communityId,
      joinedAt: joinedAt ?? this.joinedAt,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      postsCount: postsCount ?? this.postsCount,
      commentsCount: commentsCount ?? this.commentsCount,
      userInfo: userInfo ?? this.userInfo,
    );
  }
}

class CommunityMemberTile extends StatelessWidget {
  final CommunityMemberModel member;
  final VoidCallback? onTap;
  final VoidCallback? onPromote;
  final VoidCallback? onDemote;
  final VoidCallback? onRemove;
  final bool showActions;
  final bool isCurrentUser;
  final bool canModerate;

  const CommunityMemberTile({
    super.key,
    required this.member,
    this.onTap,
    this.onPromote,
    this.onDemote,
    this.onRemove,
    this.showActions = false,
    this.isCurrentUser = false,
    this.canModerate = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar do usuário
              _buildUserAvatar(context),

              const SizedBox(width: 12),

              // Informações do usuário
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome e badges
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            member.userInfo?.displayName ??
                                'Usuário ${member.userId.substring(0, 8)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isCurrentUser) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Você',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                        _buildRoleBadge(context),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Username e informações adicionais
                    if (member.userInfo?.username != null)
                      Text(
                        '@${member.userInfo!.username}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),

                    const SizedBox(height: 8),

                    // Estatísticas de atividade
                    Row(
                      children: [
                        _buildActivityStat(
                          context,
                          Icons.message,
                          '${member.postsCount}',
                          'posts',
                        ),
                        const SizedBox(width: 16),
                        _buildActivityStat(
                          context,
                          Icons.chat_bubble_outline,
                          '${member.commentsCount}',
                          'comentários',
                        ),
                        const Spacer(),
                        _buildJoinedInfo(context),
                      ],
                    ),
                  ],
                ),
              ),

              // Ações (se permitidas)
              if (showActions && canModerate && !isCurrentUser) ...[
                const SizedBox(width: 8),
                _buildActionsMenu(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context) {
    final theme = Theme.of(context);
    final avatarUrl = member.userInfo?.avatar;
    final isOnline = member.isActive &&
        member.lastActivityAt != null &&
        DateTime.now().difference(member.lastActivityAt!).inMinutes < 15;

    return Stack(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getRoleColor().withOpacity(0.3),
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: avatarUrl != null && avatarUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: avatarUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        _buildAvatarPlaceholder(theme),
                    errorWidget: (context, url, error) =>
                        _buildAvatarPlaceholder(theme),
                  )
                : _buildAvatarPlaceholder(theme),
          ),
        ),

        // Indicador de status online
        if (isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.surface,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAvatarPlaceholder(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Icon(
          Icons.person,
          color: theme.colorScheme.primary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildRoleBadge(BuildContext context) {
    if (member.role == MemberRole.member) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final color = _getRoleColor();
    final text = _getRoleText();
    final icon = _getRoleIcon();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityStat(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
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
    );
  }

  Widget _buildJoinedInfo(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Membro desde',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            fontSize: 10,
          ),
        ),
        Text(
          timeago.format(member.joinedAt, locale: 'pt_BR'),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
            fontSize: 11,
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
        if (member.role == MemberRole.member && onPromote != null)
          const PopupMenuItem(
            value: 'promote',
            child: Row(
              children: [
                Icon(Icons.arrow_upward, size: 16),
                SizedBox(width: 8),
                Text('Promover a Moderador'),
              ],
            ),
          ),
        if (member.role == MemberRole.moderator && onDemote != null)
          const PopupMenuItem(
            value: 'demote',
            child: Row(
              children: [
                Icon(Icons.arrow_downward, size: 16),
                SizedBox(width: 8),
                Text('Rebaixar a Membro'),
              ],
            ),
          ),
        if (member.role != MemberRole.creator && onRemove != null)
          const PopupMenuItem(
            value: 'remove',
            child: Row(
              children: [
                Icon(Icons.remove_circle, size: 16, color: Colors.red),
                SizedBox(width: 8),
                Text('Remover da Comunidade',
                    style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        const PopupMenuItem(
          value: 'view_profile',
          child: Row(
            children: [
              Icon(Icons.person, size: 16),
              SizedBox(width: 8),
              Text('Ver Perfil'),
            ],
          ),
        ),
      ],
    );
  }

  void _handleAction(String action) {
    switch (action) {
      case 'promote':
        onPromote?.call();
        break;
      case 'demote':
        onDemote?.call();
        break;
      case 'remove':
        onRemove?.call();
        break;
      case 'view_profile':
        // Navegar para perfil do usuário
        break;
    }
  }

  Color _getRoleColor() {
    switch (member.role) {
      case MemberRole.creator:
        return Colors.purple;
      case MemberRole.moderator:
        return Colors.orange;
      case MemberRole.member:
        return Colors.grey;
    }
  }

  String _getRoleText() {
    switch (member.role) {
      case MemberRole.creator:
        return 'Criador';
      case MemberRole.moderator:
        return 'Moderador';
      case MemberRole.member:
        return 'Membro';
    }
  }

  IconData _getRoleIcon() {
    switch (member.role) {
      case MemberRole.creator:
        return Icons.star;
      case MemberRole.moderator:
        return Icons.shield;
      case MemberRole.member:
        return Icons.person;
    }
  }
}

/// Widget compacto para uso em listas menores
class CommunityMemberChip extends StatelessWidget {
  final CommunityMemberModel member;
  final VoidCallback? onTap;

  const CommunityMemberChip({
    super.key,
    required this.member,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar pequeno
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
              child: member.userInfo?.avatar != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(
                        imageUrl: member.userInfo!.avatar!,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Icon(
                          Icons.person,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.person,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
            ),

            const SizedBox(width: 6),

            // Nome
            Text(
              member.userInfo?.displayName ?? 'User',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Role indicator
            if (member.role != MemberRole.member) ...[
              const SizedBox(width: 4),
              Icon(
                member.role == MemberRole.creator ? Icons.star : Icons.shield,
                size: 12,
                color: member.role == MemberRole.creator
                    ? Colors.purple
                    : Colors.orange,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget para mostrar lista de membros em formato avatar
class CommunityMembersAvatarList extends StatelessWidget {
  final List<CommunityMemberModel> members;
  final int maxVisible;
  final VoidCallback? onViewAll;

  const CommunityMembersAvatarList({
    super.key,
    required this.members,
    this.maxVisible = 5,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visibleMembers = members.take(maxVisible).toList();
    final remainingCount = members.length - visibleMembers.length;

    return Row(
      children: [
        // Avatares dos membros
        ...visibleMembers.map((member) => Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: member.userInfo?.avatar != null
                      ? CachedNetworkImage(
                          imageUrl: member.userInfo!.avatar!,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Container(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            child: Icon(
                              Icons.person,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        )
                      : Container(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          child: Icon(
                            Icons.person,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                ),
              ),
            )),

        // Contador de membros restantes
        if (remainingCount > 0)
          GestureDetector(
            onTap: onViewAll,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Center(
                child: Text(
                  '+$remainingCount',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
