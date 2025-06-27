// CommunityReactionBar - Barra de reacoes
// Arquivo criado automaticamente pelo script de estrutura
// Data: 2025-06-27 13:56:53
// Projeto: ClashUp - Sistema de Comunidades

// TODO: Implementar a classe/funcionalidade
// lib/features/communities/widgets/community_reaction_bar.dart
// CommunityReactionBar - Barra de reações para posts e comentários
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ReactionType {
  like,
  love,
  laugh,
  wow,
  sad,
  angry,
  clap,
  fire,
}

class Reaction {
  final ReactionType type;
  final String emoji;
  final String label;
  final Color color;

  const Reaction({
    required this.type,
    required this.emoji,
    required this.label,
    required this.color,
  });
}

class CommunityReactionBar extends StatefulWidget {
  final Map<ReactionType, int> reactions;
  final ReactionType? userReaction;
  final Function(ReactionType) onReactionTap;
  final VoidCallback? onCommentsPressed;
  final VoidCallback? onSharePressed;
  final VoidCallback? onBookmarkPressed;
  final int? commentsCount;
  final bool isBookmarked;
  final bool isCompact;
  final bool showCounts;
  final bool enableLongPress;

  const CommunityReactionBar({
    super.key,
    required this.reactions,
    this.userReaction,
    required this.onReactionTap,
    this.onCommentsPressed,
    this.onSharePressed,
    this.onBookmarkPressed,
    this.commentsCount,
    this.isBookmarked = false,
    this.isCompact = false,
    this.showCounts = true,
    this.enableLongPress = true,
    required int likesCount,
    required int sharesCount,
    VoidCallback? onLike,
  });

  @override
  State<CommunityReactionBar> createState() => _CommunityReactionBarState();
}

class _CommunityReactionBarState extends State<CommunityReactionBar>
    with TickerProviderStateMixin {
  late AnimationController _reactionController;
  late AnimationController _bounceController;
  OverlayEntry? _overlayEntry;

  // Definição das reações disponíveis
  static const List<Reaction> availableReactions = [
    Reaction(
        type: ReactionType.like,
        emoji: '👍',
        label: 'Curtir',
        color: Colors.blue),
    Reaction(
        type: ReactionType.love, emoji: '❤️', label: 'Amar', color: Colors.red),
    Reaction(
        type: ReactionType.laugh,
        emoji: '😂',
        label: 'Rir',
        color: Colors.orange),
    Reaction(
        type: ReactionType.wow, emoji: '😮', label: 'Uau', color: Colors.amber),
    Reaction(
        type: ReactionType.sad,
        emoji: '😢',
        label: 'Triste',
        color: Colors.blue),
    Reaction(
        type: ReactionType.angry,
        emoji: '😠',
        label: 'Raiva',
        color: Colors.red),
    Reaction(
        type: ReactionType.clap,
        emoji: '👏',
        label: 'Palmas',
        color: Colors.green),
    Reaction(
        type: ReactionType.fire,
        emoji: '🔥',
        label: 'Fogo',
        color: Colors.deepOrange),
  ];

  @override
  void initState() {
    super.initState();
    _reactionController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _reactionController.dispose();
    _bounceController.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isCompact ? 8 : 16,
        vertical: widget.isCompact ? 6 : 12,
      ),
      child: widget.isCompact
          ? _buildCompactLayout(theme)
          : _buildFullLayout(theme),
    );
  }

  Widget _buildFullLayout(ThemeData theme) {
    return Column(
      children: [
        // Reações populares (se houver)
        if (_hasReactions()) ...[
          _buildReactionSummary(theme),
          const SizedBox(height: 8),
        ],

        // Barra de ações
        Row(
          children: [
            // Botão de reação principal
            _buildMainReactionButton(theme),

            const SizedBox(width: 16),

            // Botão de comentários
            if (widget.onCommentsPressed != null)
              _buildActionButton(
                icon: Icons.chat_bubble_outline,
                activeIcon: Icons.chat_bubble,
                label: 'Comentar',
                count: widget.commentsCount,
                onPressed: widget.onCommentsPressed!,
                theme: theme,
              ),

            const SizedBox(width: 16),

            // Botão de compartilhar
            if (widget.onSharePressed != null)
              _buildActionButton(
                icon: Icons.share,
                label: 'Compartilhar',
                onPressed: widget.onSharePressed!,
                theme: theme,
              ),

            const Spacer(),

            // Botão de bookmark
            if (widget.onBookmarkPressed != null) _buildBookmarkButton(theme),
          ],
        ),
      ],
    );
  }

  Widget _buildCompactLayout(ThemeData theme) {
    return Row(
      children: [
        // Reações + contagem
        _buildMainReactionButton(theme, compact: true),

        const SizedBox(width: 12),

        // Comentários
        if (widget.onCommentsPressed != null) ...[
          _buildActionButton(
            icon: Icons.chat_bubble_outline,
            count: widget.commentsCount,
            onPressed: widget.onCommentsPressed!,
            theme: theme,
            compact: true,
          ),
          const SizedBox(width: 12),
        ],

        const Spacer(),

        // Ações secundárias
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.onSharePressed != null) ...[
              IconButton(
                icon: const Icon(Icons.share, size: 18),
                onPressed: widget.onSharePressed,
                splashRadius: 20,
              ),
            ],
            if (widget.onBookmarkPressed != null)
              IconButton(
                icon: Icon(
                  widget.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  size: 18,
                ),
                onPressed: widget.onBookmarkPressed,
                splashRadius: 20,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainReactionButton(ThemeData theme, {bool compact = false}) {
    final userReaction = widget.userReaction;
    final totalReactions = _getTotalReactions();

    return GestureDetector(
      onTap: () => _handleQuickReaction(),
      onLongPress: widget.enableLongPress ? () => _showReactionPicker() : null,
      child: AnimatedBuilder(
        animation: _bounceController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_bounceController.value * 0.1),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 8 : 12,
                vertical: compact ? 4 : 8,
              ),
              decoration: BoxDecoration(
                color: userReaction != null
                    ? _getReactionColor(userReaction).withOpacity(0.1)
                    : theme.colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(compact ? 16 : 20),
                border: Border.all(
                  color: userReaction != null
                      ? _getReactionColor(userReaction)
                      : theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ícone da reação
                  if (userReaction != null) ...[
                    Text(
                      _getReactionEmoji(userReaction),
                      style: TextStyle(fontSize: compact ? 16 : 18),
                    ),
                  ] else ...[
                    Icon(
                      Icons.thumb_up_outlined,
                      size: compact ? 16 : 18,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ],

                  // Contagem (se mostrar contagens)
                  if (widget.showCounts && totalReactions > 0) ...[
                    const SizedBox(width: 4),
                    Text(
                      _formatReactionCount(totalReactions),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: userReaction != null
                            ? _getReactionColor(userReaction)
                            : theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],

                  // Label (apenas em modo não compacto)
                  if (!compact) ...[
                    const SizedBox(width: 4),
                    Text(
                      userReaction != null
                          ? _getReactionLabel(userReaction)
                          : 'Curtir',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: userReaction != null
                            ? _getReactionColor(userReaction)
                            : theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    IconData? activeIcon,
    String? label,
    int? count,
    required VoidCallback onPressed,
    required ThemeData theme,
    bool compact = false,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 12,
          vertical: compact ? 4 : 8,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(compact ? 16 : 20),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive && activeIcon != null ? activeIcon : icon,
              size: compact ? 16 : 18,
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            if (count != null && count > 0) ...[
              const SizedBox(width: 4),
              Text(
                _formatReactionCount(count),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
            if (!compact && label != null) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarkButton(ThemeData theme) {
    return IconButton(
      icon: Icon(
        widget.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
        color: widget.isBookmarked
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface.withOpacity(0.7),
      ),
      onPressed: widget.onBookmarkPressed,
      splashRadius: 20,
    );
  }

  Widget _buildReactionSummary(ThemeData theme) {
    final topReactions = _getTopReactions(3);
    final totalReactions = _getTotalReactions();

    if (topReactions.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        // Emojis das reações mais populares
        ...topReactions.map((entry) => Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Text(
                _getReactionEmoji(entry.key),
                style: const TextStyle(fontSize: 14),
              ),
            )),

        const SizedBox(width: 8),

        // Contagem total
        Text(
          _formatReactionCount(totalReactions),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),

        const Spacer(),

        // Comentários summary
        if (widget.commentsCount != null && widget.commentsCount! > 0)
          Text(
            '${_formatReactionCount(widget.commentsCount!)} comentários',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
      ],
    );
  }

  void _handleQuickReaction() {
    _bounceController.forward().then((_) => _bounceController.reverse());
    HapticFeedback.lightImpact();

    // Se usuário já reagiu, remove a reação; senão, adiciona like
    if (widget.userReaction != null) {
      widget.onReactionTap(widget.userReaction!);
    } else {
      widget.onReactionTap(ReactionType.like);
    }
  }

  void _showReactionPicker() {
    if (_overlayEntry != null) return;

    HapticFeedback.mediumImpact();

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => _ReactionPickerOverlay(
        position: position,
        onReactionSelected: (reaction) {
          _removeOverlay();
          widget.onReactionTap(reaction);
        },
        onDismiss: _removeOverlay,
        animation: _reactionController,
      ),
    );

    overlay.insert(_overlayEntry!);
    _reactionController.forward();
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _reactionController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  // Métodos auxiliares
  bool _hasReactions() {
    return widget.reactions.values.any((count) => count > 0);
  }

  int _getTotalReactions() {
    return widget.reactions.values.fold(0, (sum, count) => sum + count);
  }

  List<MapEntry<ReactionType, int>> _getTopReactions(int limit) {
    final entries =
        widget.reactions.entries.where((entry) => entry.value > 0).toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(limit).toList();
  }

  String _formatReactionCount(int count) {
    if (count < 1000) return count.toString();
    if (count < 1000000)
      return '${(count / 1000).toStringAsFixed(1).replaceAll('.0', '')}K';
    return '${(count / 1000000).toStringAsFixed(1).replaceAll('.0', '')}M';
  }

  String _getReactionEmoji(ReactionType type) {
    return availableReactions.firstWhere((r) => r.type == type).emoji;
  }

  String _getReactionLabel(ReactionType type) {
    return availableReactions.firstWhere((r) => r.type == type).label;
  }

  Color _getReactionColor(ReactionType type) {
    return availableReactions.firstWhere((r) => r.type == type).color;
  }
}

// Widget do overlay para seleção de reações
class _ReactionPickerOverlay extends StatelessWidget {
  final Offset position;
  final Function(ReactionType) onReactionSelected;
  final VoidCallback onDismiss;
  final Animation<double> animation;

  const _ReactionPickerOverlay({
    required this.position,
    required this.onReactionSelected,
    required this.onDismiss,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Material(
        color: Colors.transparent,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Opacity(
              opacity: animation.value,
              child: Transform.scale(
                scale: 0.5 + (animation.value * 0.5),
                child: Stack(
                  children: [
                    Positioned(
                      left: position.dx - 160,
                      top: position.dy - 60,
                      child: _buildReactionPicker(context),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReactionPicker(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _CommunityReactionBarState.availableReactions.map((reaction) {
          return GestureDetector(
            onTap: () => onReactionSelected(reaction.type),
            child: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Center(
                child: Text(
                  reaction.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Widget simplificado para uso rápido
class SimpleReactionBar extends StatelessWidget {
  final int likes;
  final bool isLiked;
  final VoidCallback onLike;
  final int? comments;
  final VoidCallback? onComment;

  const SimpleReactionBar({
    super.key,
    required this.likes,
    required this.isLiked,
    required this.onLike,
    this.comments,
    this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    return CommunityReactionBar(
      reactions: {ReactionType.like: likes},
      userReaction: isLiked ? ReactionType.like : null,
      onReactionTap: (_) => onLike(),
      commentsCount: comments,
      onCommentsPressed: onComment,
      isCompact: true,
      enableLongPress: false,
      likesCount: 0,
      sharesCount: 0,
    );
  }
}

// Widget para estatísticas de reações
class ReactionStats extends StatelessWidget {
  final Map<ReactionType, int> reactions;
  final bool showPercentages;

  const ReactionStats({
    super.key,
    required this.reactions,
    this.showPercentages = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = reactions.values.fold(0, (sum, count) => sum + count);

    if (total == 0) return const SizedBox.shrink();

    final sortedReactions = reactions.entries
        .where((entry) => entry.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reações ($total)',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...sortedReactions.map((entry) {
          final reaction = _CommunityReactionBarState.availableReactions
              .firstWhere((r) => r.type == entry.key);
          final percentage = (entry.value / total * 100).round();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Text(reaction.emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text(
                  reaction.label,
                  style: theme.textTheme.bodyMedium,
                ),
                const Spacer(),
                Text(
                  showPercentages ? '$percentage%' : '${entry.value}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
