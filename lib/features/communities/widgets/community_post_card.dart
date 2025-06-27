// CommunityPostCard - Card de post/topico
// Arquivo criado automaticamente pelo script de estrutura
// Data: 2025-06-27 13:56:53
// Projeto: ClashUp - Sistema de Comunidades

// TODO: Implementar a classe/funcionalidade
// lib/features/communities/widgets/community_post_card.dart
// CommunityPostCard - Card de post/tópico da comunidade
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clashup/features/communities/widgets/community_reaction_bar.dart';
import 'package:clashup/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

enum CommunityPostType {
  text, // Post apenas texto
  image, // Post com imagem
  poll, // Enquete
  event, // Evento
  link, // Link externo
}

enum CommunityPostStatus {
  published, // Publicado
  pending, // Aguardando aprovação
  reported, // Reportado
  removed, // Removido
}

class CommunityPostModel {
  final String id;
  final String communityId;
  final String authorId;
  final String title;
  final String content;
  final CommunityPostType type;
  final CommunityPostStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Estatísticas
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final int viewsCount;

  // Conteúdo específico do tipo
  final List<String> imageUrls;
  final String? linkUrl;
  final String? linkTitle;
  final String? linkDescription;
  final String? linkImageUrl;

  // Poll específico
  final List<String> pollOptions;
  final Map<String, int> pollVotes; // {option: count}
  final DateTime? pollEndsAt;

  // Metadados
  final List<String> tags;
  final bool isPinned;
  final bool isLocked;
  final bool allowComments;

  // Informações do autor (podem ser carregadas separadamente)
  final UserModel? authorInfo;

  const CommunityPostModel({
    required this.id,
    required this.communityId,
    required this.authorId,
    required this.title,
    required this.content,
    this.type = CommunityPostType.text,
    this.status = CommunityPostStatus.published,
    required this.createdAt,
    this.updatedAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.viewsCount = 0,
    this.imageUrls = const [],
    this.linkUrl,
    this.linkTitle,
    this.linkDescription,
    this.linkImageUrl,
    this.pollOptions = const [],
    this.pollVotes = const {},
    this.pollEndsAt,
    this.tags = const [],
    this.isPinned = false,
    this.isLocked = false,
    this.allowComments = true,
    this.authorInfo,
  });

  bool get hasImages => imageUrls.isNotEmpty;
  bool get hasLink => linkUrl != null && linkUrl!.isNotEmpty;
  bool get isPoll => type == CommunityPostType.poll && pollOptions.isNotEmpty;
  bool get isEvent => type == CommunityPostType.event;
  bool get isPopular => likesCount >= 10 || commentsCount >= 5;
  bool get isViral => likesCount >= 50 || sharesCount >= 10;

  int get totalPollVotes =>
      pollVotes.values.fold(0, (sum, votes) => sum + votes);
  bool get isPollActive =>
      pollEndsAt == null || DateTime.now().isBefore(pollEndsAt!);
}

class CommunityPostCard extends StatefulWidget {
  final CommunityPostModel post;
  final bool isCurrentUserAuthor;
  final bool canModerate;
  final bool isCompact;
  final bool showCommunityInfo;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onReport;
  final Function(String)? onPollVote;

  const CommunityPostCard({
    super.key,
    required this.post,
    this.isCurrentUserAuthor = false,
    this.canModerate = false,
    this.isCompact = false,
    this.showCommunityInfo = false,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onEdit,
    this.onDelete,
    this.onReport,
    this.onPollVote,
  });

  @override
  State<CommunityPostCard> createState() => _CommunityPostCardState();
}

class _CommunityPostCardState extends State<CommunityPostCard> {
  bool _isExpanded = false;
  String? _selectedPollOption;

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
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header do post
            _buildPostHeader(context, theme),

            // Conteúdo principal
            _buildPostContent(context, theme),

            // Conteúdo específico por tipo
            if (widget.post.hasImages) _buildImageContent(context, theme),
            if (widget.post.hasLink) _buildLinkPreview(context, theme),
            if (widget.post.isPoll) _buildPollContent(context, theme),

            // Tags
            if (widget.post.tags.isNotEmpty && !widget.isCompact)
              _buildTags(context, theme),

            // Footer com ações
            _buildPostFooter(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildPostHeader(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Avatar do autor
          _buildAuthorAvatar(theme),

          const SizedBox(width: 12),

          // Informações do autor
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.post.authorInfo?.displayName ?? 'Usuário',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Badges de status
                    ..._buildStatusBadges(theme),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (widget.post.authorInfo?.username != null) ...[
                      Text(
                        '@${widget.post.authorInfo!.username}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      timeago.format(widget.post.createdAt, locale: 'pt_BR'),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                    if (widget.post.updatedAt != null &&
                        widget.post.updatedAt!
                            .isAfter(widget.post.createdAt)) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.edit,
                        size: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Menu de ações
          _buildActionsMenu(context, theme),
        ],
      ),
    );
  }

  Widget _buildAuthorAvatar(ThemeData theme) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: widget.post.authorInfo?.avatar != null
            ? CachedNetworkImage(
                imageUrl: widget.post.authorInfo!.avatar!,
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
        borderRadius: BorderRadius.circular(9),
      ),
      child: Center(
        child: Icon(
          Icons.person,
          color: theme.colorScheme.primary,
          size: 20,
        ),
      ),
    );
  }

  List<Widget> _buildStatusBadges(ThemeData theme) {
    final badges = <Widget>[];

    if (widget.post.isPinned) {
      badges.add(
          _buildStatusBadge('Fixado', Icons.push_pin, Colors.orange, theme));
    }

    if (widget.post.isLocked) {
      badges.add(_buildStatusBadge('Bloqueado', Icons.lock, Colors.red, theme));
    }

    if (widget.post.isPopular) {
      badges.add(
          _buildStatusBadge('Popular', Icons.trending_up, Colors.green, theme));
    }

    if (widget.post.status == CommunityPostStatus.pending) {
      badges.add(
          _buildStatusBadge('Pendente', Icons.pending, Colors.amber, theme));
    }

    return badges;
  }

  Widget _buildStatusBadge(
      String label, IconData icon, Color color, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 2),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 9,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          if (widget.post.title.isNotEmpty) ...[
            Text(
              widget.post.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: widget.isCompact ? 2 : null,
              overflow: widget.isCompact ? TextOverflow.ellipsis : null,
            ),
            const SizedBox(height: 8),
          ],

          // Conteúdo
          if (widget.post.content.isNotEmpty) ...[
            Text(
              widget.post.content,
              style: theme.textTheme.bodyMedium,
              maxLines: widget.isCompact ? 3 : (_isExpanded ? null : 6),
              overflow: widget.isCompact
                  ? TextOverflow.ellipsis
                  : (_isExpanded ? null : TextOverflow.ellipsis),
            ),

            // Botão expandir (apenas se não for compacto e o texto for longo)
            if (!widget.isCompact && widget.post.content.length > 200) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Text(
                  _isExpanded ? 'Ver menos' : 'Ver mais',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildImageContent(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: widget.isCompact ? 120 : 200,
      child: widget.post.imageUrls.length == 1
          ? _buildSingleImage(widget.post.imageUrls.first, theme)
          : _buildImageGrid(theme),
    );
  }

  Widget _buildSingleImage(String imageUrl, ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        placeholder: (context, url) => Container(
          color: theme.colorScheme.surfaceVariant,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          color: theme.colorScheme.surfaceVariant,
          child: const Center(child: Icon(Icons.error)),
        ),
      ),
    );
  }

  Widget _buildImageGrid(ThemeData theme) {
    final images = widget.post.imageUrls.take(4).toList();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: images[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => Container(
                  color: theme.colorScheme.surfaceVariant,
                ),
                errorWidget: (context, url, error) => Container(
                  color: theme.colorScheme.surfaceVariant,
                  child: const Icon(Icons.error),
                ),
              ),
            ),

            // Overlay para mais imagens
            if (index == 3 && widget.post.imageUrls.length > 4)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '+${widget.post.imageUrls.length - 4}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildLinkPreview(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Abrir link externo
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do link
            if (widget.post.linkImageUrl != null) ...[
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: widget.post.linkImageUrl!,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 120,
                    color: theme.colorScheme.surfaceVariant,
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 120,
                    color: theme.colorScheme.surfaceVariant,
                    child: const Icon(Icons.link),
                  ),
                ),
              ),
            ],

            // Informações do link
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.post.linkTitle != null) ...[
                    Text(
                      widget.post.linkTitle!,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (widget.post.linkDescription != null) ...[
                    Text(
                      widget.post.linkDescription!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      Icon(
                        Icons.link,
                        size: 14,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          Uri.tryParse(widget.post.linkUrl!)?.host ??
                              widget.post.linkUrl!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
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
          ],
        ),
      ),
    );
  }

  Widget _buildPollContent(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header da enquete
            Row(
              children: [
                Icon(
                  Icons.poll,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Enquete',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (!widget.post.isPollActive)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Encerrada',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Opções da enquete
            ...widget.post.pollOptions.map(
              (option) => _buildPollOption(option, theme),
            ),

            const SizedBox(height: 12),

            // Informações da enquete
            Row(
              children: [
                Text(
                  '${widget.post.totalPollVotes} votos',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                if (widget.post.pollEndsAt != null) ...[
                  const SizedBox(width: 16),
                  Icon(
                    Icons.timer,
                    size: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.post.isPollActive
                        ? 'Termina ${timeago.format(widget.post.pollEndsAt!, locale: 'pt_BR')}'
                        : 'Encerrada',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPollOption(String option, ThemeData theme) {
    final votes = widget.post.pollVotes[option] ?? 0;
    final totalVotes = widget.post.totalPollVotes;
    final percentage = totalVotes > 0 ? votes / totalVotes : 0.0;
    final isSelected = _selectedPollOption == option;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: widget.post.isPollActive
            ? () {
                setState(() {
                  _selectedPollOption = option;
                });
                widget.onPollVote?.call(option);
              }
            : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.1)
                : theme.colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Stack(
            children: [
              // Barra de progresso
              if (totalVotes > 0)
                Positioned.fill(
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),

              // Conteúdo da opção
              Row(
                children: [
                  Expanded(
                    child: Text(
                      option,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (totalVotes > 0) ...[
                    Text(
                      '${(percentage * 100).round()}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$votes',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTags(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: widget.post.tags.map((tag) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Text(
              '#$tag',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPostFooter(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      child: Column(
        children: [
          // Estatísticas rápidas
          if (!widget.isCompact) ...[
            Row(
              children: [
                if (widget.post.viewsCount > 0) ...[
                  Icon(
                    Icons.visibility,
                    size: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.post.viewsCount} visualizações',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
          ],

          // Barra de reações
          CommunityReactionBar(
            likesCount: widget.post.likesCount,
            commentsCount: widget.post.commentsCount,
            sharesCount: widget.post.sharesCount,
            onLike: widget.onLike,
            onCommentsPressed: widget.onComment,
            onSharePressed: widget.onShare,
            isCompact: widget.isCompact,
            reactions: {},
            onReactionTap: (ReactionType) {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionsMenu(BuildContext context, ThemeData theme) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: theme.colorScheme.onSurface.withOpacity(0.6),
      ),
      onSelected: (action) => _handleAction(action),
      itemBuilder: (context) => [
        if (widget.isCurrentUserAuthor && widget.onEdit != null)
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, size: 16),
                SizedBox(width: 8),
                Text('Editar Post'),
              ],
            ),
          ),
        if (widget.isCurrentUserAuthor && widget.onDelete != null)
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, size: 16, color: Colors.red),
                SizedBox(width: 8),
                Text('Excluir Post', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        if (!widget.isCurrentUserAuthor && widget.onReport != null)
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
        const PopupMenuItem(
          value: 'copy_link',
          child: Row(
            children: [
              Icon(Icons.link, size: 16),
              SizedBox(width: 8),
              Text('Copiar Link'),
            ],
          ),
        ),
      ],
    );
  }

  void _handleAction(String action) {
    switch (action) {
      case 'edit':
        widget.onEdit?.call();
        break;
      case 'delete':
        widget.onDelete?.call();
        break;
      case 'report':
        widget.onReport?.call();
        break;
      case 'copy_link':
        // Implementar cópia do link
        break;
    }
  }
}
