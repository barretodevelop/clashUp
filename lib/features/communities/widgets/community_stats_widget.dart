// CommunityStatsWidget - Estatisticas visuais
// Arquivo criado automaticamente pelo script de estrutura
// Data: 2025-06-27 13:56:53
// Projeto: ClashUp - Sistema de Comunidades

// TODO: Implementar a classe/funcionalidade
// lib/features/communities/widgets/community_stats_widget.dart
// CommunityStatsWidget - Estatísticas visuais da comunidade
import 'package:clashup/features/communities/constants/community_constants.dart';
import 'package:clashup/features/communities/models/community_model.dart';
import 'package:flutter/material.dart';

class CommunityStatsWidget extends StatelessWidget {
  final CommunityModel community;
  final bool isCompact;

  const CommunityStatsWidget({
    super.key,
    required this.community,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return isCompact ? _buildCompactLayout(context) : _buildFullLayout(context);
  }

  Widget _buildFullLayout(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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
          // Header
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Estatísticas da Comunidade',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildLevelBadge(context),
            ],
          ),

          const SizedBox(height: 20),

          // Stats Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildStatCard(
                context,
                'Membros',
                community.membersCount.toString(),
                Icons.people,
                theme.colorScheme.primary,
              ),
              _buildStatCard(
                context,
                'Posts',
                community.postsCount.toString(),
                Icons.message,
                theme.colorScheme.secondary,
              ),
              _buildStatCard(
                context,
                'Ativos',
                community.activeUsersCount.toString(),
                Icons.trending_up,
                Colors.green,
              ),
              _buildStatCard(
                context,
                'Nível',
                CommunityConstants.calculateCommunityLevel(
                        community.membersCount)
                    .toString(),
                Icons.star,
                Colors.amber,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Progress indicators
          _buildProgressSection(context),

          const SizedBox(height: 16),

          // Additional info
          _buildAdditionalInfo(context),
        ],
      ),
    );
  }

  Widget _buildCompactLayout(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCompactStat(context, community.membersCount.toString(),
              'Membros', Icons.people),
          _buildVerticalDivider(context),
          _buildCompactStat(
              context, community.postsCount.toString(), 'Posts', Icons.message),
          _buildVerticalDivider(context),
          _buildCompactStat(
              context,
              'Nv.${CommunityConstants.calculateCommunityLevel(community.membersCount)}',
              'Nível',
              Icons.star),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStat(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 4),
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
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    final theme = Theme.of(context);
    final currentLevel =
        CommunityConstants.calculateCommunityLevel(community.membersCount);
    final nextLevelThreshold = _getNextLevelThreshold(currentLevel);
    final progress = nextLevelThreshold > 0
        ? community.membersCount / nextLevelThreshold
        : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progresso para Nível ${currentLevel + 1}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (nextLevelThreshold > 0)
              Text(
                '${community.membersCount}/${nextLevelThreshold}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: theme.colorScheme.surfaceVariant,
            valueColor:
                AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo(BuildContext context) {
    final theme = Theme.of(context);
    final features = <String>[];

    if (community.isVerified) features.add('Verificada');
    if (community.isPremium) features.add('Premium');
    if (community.allowPosts) features.add('Posts Abertos');
    if (community.allowComments) features.add('Comentários Livres');

    if (features.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Características',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: features
              .map((feature) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          theme.colorScheme.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      feature,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildLevelBadge(BuildContext context) {
    final theme = Theme.of(context);
    final level =
        CommunityConstants.calculateCommunityLevel(community.membersCount);
    final color = _getLevelColor(level);

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
            Icons.star,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            'Nv. $level',
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider(BuildContext context) {
    return Container(
      height: 30,
      width: 1,
      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
    );
  }

  // Métodos auxiliares
  int _getNextLevelThreshold(int currentLevel) {
    const thresholds = {
      1: 10,
      2: 50,
      3: 100,
      4: 250,
      5: 500,
      6: 1000,
      7: 2500,
      8: 5000,
      9: 10000,
    };

    return thresholds[currentLevel] ?? 0;
  }

  Color _getLevelColor(int level) {
    if (level >= 10) return const Color(0xFFFFD700); // Dourado
    if (level >= 8) return const Color(0xFFC0C0C0); // Prateado
    if (level >= 6) return const Color(0xFFCD7F32); // Bronze
    if (level >= 4) return const Color(0xFF4CAF50); // Verde
    if (level >= 2) return const Color(0xFF2196F3); // Azul
    return const Color(0xFF9E9E9E); // Cinza
  }
}

/// Widget simplificado para uso em listas
class CommunityStatsPreview extends StatelessWidget {
  final CommunityModel community;

  const CommunityStatsPreview({
    super.key,
    required this.community,
  });

  @override
  Widget build(BuildContext context) {
    return CommunityStatsWidget(
      community: community,
      isCompact: true,
    );
  }
}

/// Widget de estatística individual para uso modular
class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;
  final bool isVertical;

  const StatItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color,
    this.isVertical = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;

    if (isVertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: effectiveColor,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: effectiveColor,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: effectiveColor,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: effectiveColor,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      );
    }
  }
}
