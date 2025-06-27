// CommunityUtils - Utilitarios e helpers
// Arquivo criado automaticamente pelo script de estrutura
// Data: 2025-06-27 13:56:54
// Projeto: ClashUp - Sistema de Comunidades

// TODO: Implementar a classe/funcionalidade

// lib/features/communities/utils/community_utils.dart
// CommunityUtils - Utilitários e helpers para comunidades
import 'package:clashup/core/utils/logger.dart';
import 'package:clashup/features/communities/constants/community_constants.dart';
import 'package:clashup/features/communities/models/community_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommunityUtils {
  // ========== FORMATAÇÃO DE NÚMEROS ==========

  /// Formatar número de membros de forma legível
  static String formatMemberCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      final thousands = count / 1000;
      return '${thousands.toStringAsFixed(thousands.truncateToDouble() == thousands ? 0 : 1)}K';
    } else {
      final millions = count / 1000000;
      return '${millions.toStringAsFixed(millions.truncateToDouble() == millions ? 0 : 1)}M';
    }
  }

  /// Formatar número de posts
  static String formatPostCount(int count) {
    return formatMemberCount(count); // Usar a mesma lógica
  }

  /// Formatar estatísticas gerais
  static String formatStatNumber(int number) {
    if (number == 0) return '0';
    if (number < 1000) return number.toString();
    if (number < 1000000) {
      return '${(number / 1000).toStringAsFixed(1).replaceAll('.0', '')}K';
    }
    return '${(number / 1000000).toStringAsFixed(1).replaceAll('.0', '')}M';
  }

  // ========== FORMATAÇÃO DE DATAS ==========

  /// Formatar data de criação da comunidade
  static String formatCreationDate(DateTime date) {
    return timeago.format(date, locale: 'pt_BR');
  }

  /// Formatar última atividade
  static String formatLastActivity(DateTime? date) {
    if (date == null) return 'Nunca';

    final difference = DateTime.now().difference(date);

    if (difference.inMinutes < 1) {
      return 'Agora mesmo';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m atrás';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h atrás';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d atrás';
    } else {
      return timeago.format(date, locale: 'pt_BR');
    }
  }

  /// Verificar se usuário está online
  static bool isUserOnline(DateTime? lastActivity) {
    if (lastActivity == null) return false;
    return DateTime.now().difference(lastActivity).inMinutes < 15;
  }

  // ========== CÁLCULOS DE NÍVEL E PROGRESSO ==========

  /// Calcular nível da comunidade
  static int calculateCommunityLevel(int membersCount) {
    return CommunityConstants.calculateCommunityLevel(membersCount);
  }

  /// Calcular progresso para próximo nível
  static double calculateLevelProgress(int membersCount) {
    final currentLevel = calculateCommunityLevel(membersCount);
    final currentThreshold = _getLevelThreshold(currentLevel);
    final nextThreshold = _getLevelThreshold(currentLevel + 1);

    if (nextThreshold == 0) return 1.0; // Já é o nível máximo

    final progress =
        (membersCount - currentThreshold) / (nextThreshold - currentThreshold);
    return progress.clamp(0.0, 1.0);
  }

  /// Calcular membros necessários para próximo nível
  static int calculateMembersForNextLevel(int currentMembers) {
    final currentLevel = calculateCommunityLevel(currentMembers);
    final nextThreshold = _getLevelThreshold(currentLevel + 1);

    if (nextThreshold == 0) return 0; // Já é o nível máximo

    return nextThreshold - currentMembers;
  }

  static int _getLevelThreshold(int level) {
    const thresholds = {
      1: 0,
      2: 10,
      3: 50,
      4: 100,
      5: 250,
      6: 500,
      7: 1000,
      8: 2500,
      9: 5000,
      10: 10000,
    };
    return thresholds[level] ?? 0;
  }

  // ========== CORES E TEMAS ==========

  /// Obter cor baseada no nível da comunidade
  static Color getLevelColor(int level) {
    if (level >= 10) return const Color(0xFFFFD700); // Dourado
    if (level >= 8) return const Color(0xFFC0C0C0); // Prateado
    if (level >= 6) return const Color(0xFFCD7F32); // Bronze
    if (level >= 4) return const Color(0xFF4CAF50); // Verde
    if (level >= 2) return const Color(0xFF2196F3); // Azul
    return const Color(0xFF9E9E9E); // Cinza
  }

  /// Obter cor da categoria
  static Color getCategoryColor(CommunityCategory category) {
    switch (category) {
      case CommunityCategory.technology:
        return const Color(0xFF2196F3);
      case CommunityCategory.music:
        return const Color(0xFF9C27B0);
      case CommunityCategory.sports:
        return const Color(0xFF4CAF50);
      case CommunityCategory.games:
        return const Color(0xFFFF9800);
      case CommunityCategory.movies:
        return const Color(0xFFE91E63);
      case CommunityCategory.books:
        return const Color(0xFF795548);
      case CommunityCategory.food:
        return const Color(0xFFFF5722);
      case CommunityCategory.travel:
        return const Color(0xFF00BCD4);
      case CommunityCategory.lifestyle:
        return const Color(0xFFCDDC39);
      case CommunityCategory.education:
        return const Color(0xFF3F51B5);
      case CommunityCategory.business:
        return const Color(0xFF607D8B);
      case CommunityCategory.art:
        return const Color(0xFFE91E63);
      case CommunityCategory.health:
        return const Color(0xFF4CAF50);
      case CommunityCategory.relationships:
        return const Color(0xFFF44336);
      case CommunityCategory.humor:
        return const Color(0xFFFFEB3B);
      case CommunityCategory.other:
        return const Color(0xFF9E9E9E);
    }
  }

  /// Obter cor do tipo de privacidade
  static Color getPrivacyColor(CommunityPrivacyType privacy) {
    switch (privacy) {
      case CommunityPrivacyType.public:
        return Colors.green;
      case CommunityPrivacyType.private:
        return Colors.red;
      case CommunityPrivacyType.restricted:
        return Colors.orange;
    }
  }

  // ========== ANÁLISE DE ATIVIDADE ==========

  /// Classificar atividade da comunidade
  static CommunityActivityLevel classifyActivity({
    required int membersCount,
    required int postsCount,
    required int activeUsersCount,
    required DateTime createdAt,
  }) {
    if (membersCount == 0) return CommunityActivityLevel.inactive;

    var daysSinceCreation = DateTime.now().difference(createdAt).inDays;
    if (daysSinceCreation == 0) {
      daysSinceCreation = 1; // Evitar divisão por zero
    }

    final postsPerDay = postsCount / daysSinceCreation;
    final activeRatio = activeUsersCount / membersCount;

    if (postsPerDay >= 10 && activeRatio >= 0.3) {
      return CommunityActivityLevel.veryHigh;
    } else if (postsPerDay >= 5 && activeRatio >= 0.2) {
      return CommunityActivityLevel.high;
    } else if (postsPerDay >= 1 && activeRatio >= 0.1) {
      return CommunityActivityLevel.medium;
    } else if (postsPerDay >= 0.1 && activeRatio >= 0.05) {
      return CommunityActivityLevel.low;
    } else {
      return CommunityActivityLevel.inactive;
    }
  }

  /// Obter descrição da atividade
  static String getActivityDescription(CommunityActivityLevel level) {
    switch (level) {
      case CommunityActivityLevel.veryHigh:
        return 'Muito ativa';
      case CommunityActivityLevel.high:
        return 'Ativa';
      case CommunityActivityLevel.medium:
        return 'Moderadamente ativa';
      case CommunityActivityLevel.low:
        return 'Pouco ativa';
      case CommunityActivityLevel.inactive:
        return 'Inativa';
    }
  }

  /// Obter cor da atividade
  static Color getActivityColor(CommunityActivityLevel level) {
    switch (level) {
      case CommunityActivityLevel.veryHigh:
        return Colors.green.shade700;
      case CommunityActivityLevel.high:
        return Colors.green;
      case CommunityActivityLevel.medium:
        return Colors.orange;
      case CommunityActivityLevel.low:
        return Colors.red.shade300;
      case CommunityActivityLevel.inactive:
        return Colors.grey;
    }
  }

  // ========== COMPARTILHAMENTO ==========

  /// Compartilhar comunidade
  static Future<void> shareCommunity(CommunityModel community) async {
    try {
      final text = _buildShareText(community);
      await Share.share(text, subject: 'Confira esta comunidade!');

      AppLogger.info('Comunidade compartilhada', data: {
        'communityId': community.id,
        'name': community.name,
      });
    } catch (e) {
      AppLogger.error('Erro ao compartilhar comunidade', error: e);
    }
  }

  /// Copiar link da comunidade
  static Future<void> copyCommunityLink(
      BuildContext context, CommunityModel community) async {
    try {
      final link = _buildCommunityLink(community);
      await Clipboard.setData(ClipboardData(text: link));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Link copiado!'),
            duration: Duration(seconds: 2),
          ),
        );
      }

      AppLogger.info('Link da comunidade copiado', data: {
        'communityId': community.id,
      });
    } catch (e) {
      AppLogger.error('Erro ao copiar link', error: e);
    }
  }

  static String _buildShareText(CommunityModel community) {
    return '''
🏘️ ${community.name}

${community.description}

${community.category.emoji} ${community.category.displayName}
👥 ${formatMemberCount(community.membersCount)} membros
⭐ Nível ${calculateCommunityLevel(community.membersCount)}

${_buildCommunityLink(community)}

#ClashUp #Comunidade
'''
        .trim();
  }

  static String _buildCommunityLink(CommunityModel community) {
    // Implementar lógica de deep linking quando disponível
    return 'https://clashup.app/community/${community.id}';
  }

  // ========== BUSCA E FILTROS ==========

  /// Filtrar comunidades por texto
  static List<CommunityModel> filterByText(
    List<CommunityModel> communities,
    String query,
  ) {
    if (query.trim().isEmpty) return communities;

    final searchLower = query.toLowerCase().trim();

    return communities.where((community) {
      return community.name.toLowerCase().contains(searchLower) ||
          community.description.toLowerCase().contains(searchLower) ||
          community.tags
              .any((tag) => tag.toLowerCase().contains(searchLower)) ||
          community.category.displayName.toLowerCase().contains(searchLower);
    }).toList();
  }

  /// Ordenar comunidades
  static List<CommunityModel> sortCommunities(
    List<CommunityModel> communities,
    CommunitySortOption sortOption,
  ) {
    final sortedList = List<CommunityModel>.from(communities);

    switch (sortOption) {
      case CommunitySortOption.name:
        sortedList.sort((a, b) => a.name.compareTo(b.name));
        break;
      case CommunitySortOption.members:
        sortedList.sort((a, b) => b.membersCount.compareTo(a.membersCount));
        break;
      case CommunitySortOption.activity:
        sortedList
            .sort((a, b) => b.activeUsersCount.compareTo(a.activeUsersCount));
        break;
      case CommunitySortOption.newest:
        sortedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case CommunitySortOption.oldest:
        sortedList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case CommunitySortOption.level:
        sortedList.sort((a, b) {
          final levelA = calculateCommunityLevel(a.membersCount);
          final levelB = calculateCommunityLevel(b.membersCount);
          return levelB.compareTo(levelA);
        });
        break;
    }

    return sortedList;
  }

  // ========== VALIDAÇÕES RÁPIDAS ==========

  /// Verificar se comunidade pode ser verificada
  static bool canBeVerified(CommunityModel community) {
    return CommunityConstants.canBeVerified(
      community.membersCount,
      calculateCommunityLevel(community.membersCount),
    );
  }

  /// Verificar se é uma nova comunidade
  static bool isNewCommunity(DateTime createdAt) {
    return DateTime.now().difference(createdAt).inDays <= 7;
  }

  /// Verificar se é uma comunidade em crescimento
  static bool isGrowingCommunity(CommunityModel community) {
    // Lógica simples: comunidade com mais de 10 membros e menos de 90 dias
    final daysSinceCreation =
        DateTime.now().difference(community.createdAt).inDays;
    return community.membersCount >= 10 &&
        community.membersCount <= 100 &&
        daysSinceCreation <= 90;
  }

  // ========== UTILITÁRIOS DE TEXTO ==========

  /// Gerar slug para URL
  static String generateSlug(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '') // Remove caracteres especiais
        .replaceAll(RegExp(r'\s+'), '-') // Substitui espaços por hífen
        .replaceAll(RegExp(r'-+'), '-') // Remove hífens duplicados
        .replaceAll(RegExp(r'^-|-$'), ''); // Remove hífens do início/fim
  }

  /// Truncar texto com ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }

  /// Extrair hashtags do texto
  static List<String> extractHashtags(String text) {
    final regex = RegExp(r'#(\w+)');
    return regex.allMatches(text).map((match) => match.group(1)!).toList();
  }

  // ========== ANALYTICS E MÉTRICAS ==========

  /// Calcular taxa de engajamento
  static double calculateEngagementRate(CommunityModel community) {
    if (community.membersCount == 0) return 0.0;
    return community.activeUsersCount / community.membersCount;
  }

  /// Calcular posts por membro
  static double calculatePostsPerMember(CommunityModel community) {
    if (community.membersCount == 0) return 0.0;
    return community.postsCount / community.membersCount;
  }

  /// Gerar relatório de estatísticas
  static Map<String, dynamic> generateStatsReport(CommunityModel community) {
    return {
      'basicStats': {
        'membersCount': community.membersCount,
        'postsCount': community.postsCount,
        'activeUsersCount': community.activeUsersCount,
        'level': calculateCommunityLevel(community.membersCount),
      },
      'calculated': {
        'engagementRate': calculateEngagementRate(community),
        'postsPerMember': calculatePostsPerMember(community),
        'activityLevel': classifyActivity(
          membersCount: community.membersCount,
          postsCount: community.postsCount,
          activeUsersCount: community.activeUsersCount,
          createdAt: community.createdAt,
        ).name,
        'daysSinceCreation':
            DateTime.now().difference(community.createdAt).inDays,
      },
      'flags': {
        'isNew': isNewCommunity(community.createdAt),
        'isGrowing': isGrowingCommunity(community),
        'canBeVerified': canBeVerified(community),
      },
    };
  }
}

// ========== ENUMS E CLASSES AUXILIARES ==========

enum CommunityActivityLevel {
  inactive,
  low,
  medium,
  high,
  veryHigh,
}

enum CommunitySortOption {
  name,
  members,
  activity,
  newest,
  oldest,
  level,
}

/// Classe para estatísticas calculadas
class CommunityStats {
  final int level;
  final double progress;
  final int membersForNextLevel;
  final CommunityActivityLevel activityLevel;
  final double engagementRate;
  final Color levelColor;

  CommunityStats({
    required this.level,
    required this.progress,
    required this.membersForNextLevel,
    required this.activityLevel,
    required this.engagementRate,
    required this.levelColor,
  });

  factory CommunityStats.fromCommunity(CommunityModel community) {
    final level =
        CommunityUtils.calculateCommunityLevel(community.membersCount);

    return CommunityStats(
      level: level,
      progress: CommunityUtils.calculateLevelProgress(community.membersCount),
      membersForNextLevel:
          CommunityUtils.calculateMembersForNextLevel(community.membersCount),
      activityLevel: CommunityUtils.classifyActivity(
        membersCount: community.membersCount,
        postsCount: community.postsCount,
        activeUsersCount: community.activeUsersCount,
        createdAt: community.createdAt,
      ),
      engagementRate: CommunityUtils.calculateEngagementRate(community),
      levelColor: CommunityUtils.getLevelColor(level),
    );
  }
}
