// CommunityConstants - Constantes do sistema
// Arquivo criado automaticamente pelo script de estrutura
// Data: 2025-06-27 13:56:53
// Projeto: ClashUp - Sistema de Comunidades

// TODO: Implementar a classe/funcionalidade
// lib/features/communities/constants/community_constants.dart
// CommunityConstants - Constantes do sistema de comunidades

class CommunityConstants {
  // ========== LIMITES DE TEXTO ==========
  static const int maxCommunityNameLength = 50;
  static const int minCommunityNameLength = 3;
  static const int maxCommunityDescriptionLength = 500;
  static const int minCommunityDescriptionLength = 10;
  static const int maxCommunityRulesLength = 2000;
  static const int maxWelcomeMessageLength = 300;
  static const int maxTagsCount = 10;
  static const int maxTagLength = 20;

  // ========== LIMITES DE MEMBROS ==========
  static const int maxMembersPerCommunity = 50000;
  static const int maxOwnedCommunitiesPerUser = 5;
  static const int maxJoinedCommunitiesPerUser = 100;
  static const int maxModeratedCommunitiesPerUser = 10;

  // ========== GAMIFICAÇÃO - XP ==========
  static const int xpCreateCommunity = 100;
  static const int xpJoinCommunity = 25;
  static const int xpFirstPost = 30;
  static const int xpRegularPost = 15;
  static const int xpPopularPost = 50; // Post com 10+ curtidas
  static const int xpViralPost = 100; // Post com 50+ curtidas
  static const int xpComment = 5;
  static const int xpHelpfulComment = 15; // Comentário com 5+ curtidas
  static const int xpModerationAction = 10;
  static const int xpPromotedToModerator = 200;
  static const int xpCommunity100Members = 500; // Para criador
  static const int xpCommunity1000Members = 1000; // Para criador
  static const int xpWeeklyActiveUser = 25; // Usuário ativo na semana

  // ========== GAMIFICAÇÃO - COINS ==========
  static const int coinsCreateCommunity = 50;
  static const int coinsPopularPost = 25; // Post com 10+ curtidas
  static const int coinsViralPost = 50; // Post com 50+ curtidas
  static const int coinsCommunityOfTheMonth = 100; // Para criador
  static const int coinsActiveModerator = 30; // Moderação ativa por semana
  static const int coinsRecruit5Members = 75; // Recrutar 5 novos membros
  static const int coinsRecruit10Members = 150; // Recrutar 10 novos membros
  static const int coinsWeeklyTopContributor = 40; // Top contribuidor da semana

  // ========== GAMIFICAÇÃO - GEMS ==========
  static const int gemsCommunity500Members = 10; // Para criador
  static const int gemsCommunity1000Members = 20; // Para criador
  static const int gemsElectedModerator = 5; // Eleito por votação
  static const int gemsVerifiedCommunity = 15; // Comunidade verificada
  static const int gemsMonthlyTopCreator = 25; // Top criador do mês
  static const int gemsCommunityAward = 50; // Comunidade premiada

  // ========== MÉTRICAS PARA POSTS POPULARES ==========
  static const int likesForPopularPost = 10;
  static const int likesForViralPost = 50;
  static const int likesForHelpfulComment = 5;
  static const int commentsForPopularPost = 5;
  static const int sharesForViralPost = 10;

  // ========== INTERVALOS DE TEMPO ==========
  static const Duration weeklyStatsInterval = Duration(days: 7);
  static const Duration monthlyStatsInterval = Duration(days: 30);
  static const Duration activityTimeWindow =
      Duration(days: 7); // Para usuários ativos
  static const Duration cooldownCreateCommunity = Duration(hours: 24);
  static const Duration cooldownJoinCommunities = Duration(minutes: 30);

  // ========== CONFIGURAÇÕES DE BUSCA ==========
  static const int defaultSearchLimit = 20;
  static const int maxSearchLimit = 50;
  static const int popularCommunitiesLimit = 10;
  static const int recommendedCommunitiesLimit = 15;
  static const int trendingCommunitiesLimit = 8;

  // ========== CONFIGURAÇÕES DE PAGINAÇÃO ==========
  static const int defaultPageSize = 20;
  static const int postsPageSize = 15;
  static const int commentsPageSize = 10;
  static const int membersPageSize = 25;

  // ========== NÍVEIS DE COMUNIDADE ==========
  static const Map<int, int> communityLevelThresholds = {
    1: 0, // Nível 1: 0+ membros
    2: 10, // Nível 2: 10+ membros
    3: 50, // Nível 3: 50+ membros
    4: 100, // Nível 4: 100+ membros
    5: 250, // Nível 5: 250+ membros
    6: 500, // Nível 6: 500+ membros
    7: 1000, // Nível 7: 1000+ membros
    8: 2500, // Nível 8: 2500+ membros
    9: 5000, // Nível 9: 5000+ membros
    10: 10000, // Nível 10: 10000+ membros
  };

  // ========== BADGES DE COMUNIDADE ==========
  static const Map<String, Map<String, dynamic>> communityBadges = {
    'founder': {
      'name': 'Fundador',
      'description': 'Criou uma comunidade',
      'emoji': '👑',
      'xpReward': 100,
    },
    'popular_creator': {
      'name': 'Criador Popular',
      'description': 'Comunidade com 100+ membros',
      'emoji': '⭐',
      'xpReward': 200,
    },
    'viral_creator': {
      'name': 'Criador Viral',
      'description': 'Comunidade com 1000+ membros',
      'emoji': '🚀',
      'xpReward': 500,
    },
    'super_moderator': {
      'name': 'Super Moderador',
      'description': 'Modera 3+ comunidades',
      'emoji': '🛡️',
      'xpReward': 150,
    },
    'community_champion': {
      'name': 'Campeão da Comunidade',
      'description': '100+ posts aprovados',
      'emoji': '🏆',
      'xpReward': 300,
    },
    'conversation_starter': {
      'name': 'Iniciador de Conversas',
      'description': '50+ tópicos criados',
      'emoji': '💬',
      'xpReward': 100,
    },
    'helpful_member': {
      'name': 'Membro Prestativo',
      'description': '100+ comentários úteis',
      'emoji': '🤝',
      'xpReward': 150,
    },
    'active_participant': {
      'name': 'Participante Ativo',
      'description': 'Ativo por 30 dias consecutivos',
      'emoji': '📅',
      'xpReward': 200,
    },
  };

  // ========== CONFIGURAÇÕES DE MODERAÇÃO ==========
  static const int maxReportsPerPost = 10;
  static const int autoHideThreshold =
      5; // Reports para ocultar automaticamente
  static const Duration reportCooldown = Duration(hours: 24);
  static const Duration moderationActionCooldown = Duration(minutes: 30);

  // ========== CONFIGURAÇÕES DE NOTIFICAÇÃO ==========
  static const Map<String, bool> defaultNotificationSettings = {
    'newMember': true,
    'newPost': true,
    'newComment': false,
    'mentionedInPost': true,
    'mentionedInComment': true,
    'moderationAction': true,
    'communityUpdates': true,
    'weeklyDigest': true,
    'monthlyStats': false,
  };

  // ========== TIPOS DE ATIVIDADE ==========
  static const List<String> activityTypes = [
    'post_created',
    'comment_added',
    'post_liked',
    'comment_liked',
    'member_joined',
    'member_promoted',
    'community_updated',
    'event_created',
    'milestone_reached',
  ];

  // ========== CONFIGURAÇÕES DE UPLOAD ==========
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxBannerSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'webp'
  ];
  static const int imageCompressionQuality = 85;

  // ========== MENSAGENS DE ERRO ==========
  static const String errorCommunityNotFound = 'Comunidade não encontrada';
  static const String errorUserNotMember = 'Usuário não é membro da comunidade';
  static const String errorInsufficientPermissions = 'Permissões insuficientes';
  static const String errorCommunityNameTaken =
      'Nome da comunidade já está em uso';
  static const String errorMaxCommunitiesReached =
      'Limite máximo de comunidades atingido';
  static const String errorCooldownActive =
      'Aguarde antes de realizar esta ação novamente';
  static const String errorInvalidInput = 'Dados de entrada inválidos';
  static const String errorNetworkFailure = 'Falha na conexão de rede';

  // ========== CONFIGURAÇÕES DE CACHE ==========
  static const Duration cachePopularCommunities = Duration(minutes: 15);
  static const Duration cacheTrendingCommunities = Duration(minutes: 10);
  static const Duration cacheUserCommunities = Duration(minutes: 5);
  static const Duration cacheSearchResults = Duration(minutes: 3);

  // ========== ANALYTICS EVENTS ==========
  static const String eventCommunityCreated = 'community_created';
  static const String eventCommunityJoined = 'community_joined';
  static const String eventCommunityLeft = 'community_left';
  static const String eventPostCreated = 'community_post_created';
  static const String eventCommentAdded = 'community_comment_added';
  static const String eventPostLiked = 'community_post_liked';
  static const String eventCommunitySearched = 'community_searched';
  static const String eventMemberPromoted = 'community_member_promoted';
  static const String eventMilestoneReached = 'community_milestone_reached';

  // ========== MÉTODOS UTILITÁRIOS ==========

  /// Calcular nível da comunidade baseado no número de membros
  static int calculateCommunityLevel(int membersCount) {
    for (int level = communityLevelThresholds.length; level >= 1; level--) {
      if (membersCount >= (communityLevelThresholds[level] ?? 0)) {
        return level;
      }
    }
    return 1;
  }

  /// Verificar se comunidade pode ser verificada
  static bool canBeVerified(int membersCount, int communityLevel) {
    return membersCount >= 500 && communityLevel >= 6;
  }

  /// Calcular XP baseado na atividade
  static int calculateXpReward(String activityType,
      {Map<String, dynamic>? context}) {
    switch (activityType) {
      case 'create_community':
        return xpCreateCommunity;
      case 'join_community':
        return xpJoinCommunity;
      case 'first_post':
        return xpFirstPost;
      case 'regular_post':
        return xpRegularPost;
      case 'popular_post':
        return xpPopularPost;
      case 'viral_post':
        return xpViralPost;
      case 'comment':
        return xpComment;
      case 'helpful_comment':
        return xpHelpfulComment;
      case 'moderation_action':
        return xpModerationAction;
      default:
        return 0;
    }
  }

  /// Calcular coins baseado na atividade
  static int calculateCoinsReward(String activityType,
      {Map<String, dynamic>? context}) {
    switch (activityType) {
      case 'create_community':
        return coinsCreateCommunity;
      case 'popular_post':
        return coinsPopularPost;
      case 'viral_post':
        return coinsViralPost;
      case 'active_moderator':
        return coinsActiveModerator;
      default:
        return 0;
    }
  }

  /// Verificar se post é popular
  static bool isPopularPost(int likes, int comments) {
    return likes >= likesForPopularPost || comments >= commentsForPopularPost;
  }

  /// Verificar se post é viral
  static bool isViralPost(int likes, int shares) {
    return likes >= likesForViralPost || shares >= sharesForViralPost;
  }

  /// Verificar se comentário é útil
  static bool isHelpfulComment(int likes) {
    return likes >= likesForHelpfulComment;
  }
}

/// Extensão para facilitar o uso das constantes
extension CommunityConstantsExtension on CommunityConstants {
  /// Obter configuração de badge por ID
  static Map<String, dynamic>? getBadgeConfig(String badgeId) {
    return CommunityConstants.communityBadges[badgeId];
  }

  /// Obter nome do badge
  static String getBadgeName(String badgeId) {
    final config = getBadgeConfig(badgeId);
    return config?['name'] ?? 'Badge Desconhecido';
  }

  /// Obter emoji do badge
  static String getBadgeEmoji(String badgeId) {
    final config = getBadgeConfig(badgeId);
    return config?['emoji'] ?? '🏅';
  }

  /// Obter descrição do badge
  static String getBadgeDescription(String badgeId) {
    final config = getBadgeConfig(badgeId);
    return config?['description'] ?? 'Descrição não disponível';
  }
}
