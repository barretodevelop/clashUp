// lib/core/constants/app_constants.dart - Atualizado com Sistema de Comunidades
class AppConstants {
  // ========== INFORMAÇÕES DO APP ==========
  static const String appName = 'ClashUp';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Um aplicativo social com modos de usuário e economia gamificada';

  // ========== CONFIGURAÇÕES DE TEXTO ==========
  static const int maxUsernameLength = 20;
  static const int minUsernameLength = 3;
  static const int maxDisplayNameLength = 30;
  static const int maxBioLength = 150;
  static const int maxMessageLength = 500;
  static const int maxCommentLength = 280;
  static const int maxChallengeNameLength = 50;
  static const int maxChallengeDescriptionLength = 300;

  // ========== CONFIGURAÇÕES DE MÍDIA ==========
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const int maxVideoSize = 100 * 1024 * 1024; // 100MB
  static const int maxAudioSize = 25 * 1024 * 1024; // 25MB
  static const List<String> allowedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp'
  ];
  static const List<String> allowedVideoFormats = ['mp4', 'mov', 'avi'];
  static const List<String> allowedAudioFormats = ['mp3', 'wav', 'aac'];

  // ========== CONFIGURAÇÕES DE DESAFIOS ==========
  static const int maxChallengeParticipants = 100;
  static const int minChallengeParticipants = 2;
  // static const int maxChallengeNameLength = maxChallengeNameLength;
  // static const int maxChallengeDescriptionLength =
  //     maxChallengeDescriptionLength;
  static const int challengeMaxParticipants = maxChallengeParticipants;

  // ========== CONFIGURAÇÕES DE GAMIFICAÇÃO ==========
  static const int xpPerLevel = 1000;
  static const int baseXpReward = 10;
  static const int winChallengeXp = 100;
  static const int participateChallengeXp = 25;
  static const int createChallengeXp = 50;
  static const int inviteFriendXp = 75;
  static const int dailyLoginXp = 5;
  static const int streakBonusXp = 15;

  // Moedas virtuais (Faíscas e Gemas)
  static const int startingCoins = 100; // Faíscas iniciais
  static const int startingGems = 10; // Gemas iniciais
  static const int dailyLoginCoins = 10;
  static const int winChallengeCoins = 50;
  static const int streakBonusCoins = 25;
  static const int maxEntryFee =
      100; // Máximo de Faíscas para entrar em desafio

  // ========== CONFIGURAÇÕES DE COMUNIDADES (NOVO) ==========

  // Limites de texto para comunidades
  static const int maxCommunityNameLength = 50;
  static const int minCommunityNameLength = 3;
  static const int maxCommunityDescriptionLength = 500;
  static const int minCommunityDescriptionLength = 10;
  static const int maxCommunityRulesLength = 2000;
  static const int maxCommunityWelcomeMessageLength = 300;
  static const int maxCommunityTagsCount = 10;
  static const int maxCommunityTagLength = 20;

  // Limites de membros
  static const int maxMembersPerCommunity = 50000;
  static const int maxOwnedCommunitiesPerUser = 5;
  static const int maxJoinedCommunitiesPerUser = 100;
  static const int maxModeratedCommunitiesPerUser = 10;

  // XP para atividades em comunidades
  static const int xpCreateCommunity = 100;
  static const int xpJoinCommunity = 25;
  static const int xpFirstPostInCommunity = 30;
  static const int xpRegularPostInCommunity = 15;
  static const int xpPopularPostInCommunity = 50; // Post com 10+ curtidas
  static const int xpViralPostInCommunity = 100; // Post com 50+ curtidas
  static const int xpCommentInCommunity = 5;
  static const int xpHelpfulCommentInCommunity =
      15; // Comentário com 5+ curtidas
  static const int xpModerationAction = 10;
  static const int xpPromotedToModerator = 200;
  static const int xpCommunity100Members = 500; // Para criador
  static const int xpCommunity1000Members = 1000; // Para criador
  static const int xpWeeklyActiveInCommunity = 25;

  // Coins para atividades em comunidades
  static const int coinsCreateCommunity = 50;
  static const int coinsPopularPostInCommunity = 25; // Post com 10+ curtidas
  static const int coinsViralPostInCommunity = 50; // Post com 50+ curtidas
  static const int coinsCommunityOfTheMonth = 100; // Para criador
  static const int coinsActiveModerator = 30; // Moderação ativa por semana
  static const int coinsRecruit5Members = 75; // Recrutar 5 novos membros
  static const int coinsRecruit10Members = 150; // Recrutar 10 novos membros
  static const int coinsWeeklyTopContributor = 40; // Top contribuidor da semana

  // Gems para atividades em comunidades
  static const int gemsCommunity500Members = 10; // Para criador
  static const int gemsCommunity1000Members = 20; // Para criador
  static const int gemsElectedModerator = 5; // Eleito por votação
  static const int gemsVerifiedCommunity = 15; // Comunidade verificada
  static const int gemsMonthlyTopCreator = 25; // Top criador do mês
  static const int gemsCommunityAward = 50; // Comunidade premiada

  // Configurações de paginação para comunidades
  static const int defaultCommunityPageSize = 20;
  static const int communityPostsPageSize = 15;
  static const int communityCommentsPageSize = 10;
  static const int communityMembersPageSize = 25;
  static const int popularCommunitiesLimit = 10;
  static const int recommendedCommunitiesLimit = 15;
  static const int trendingCommunitiesLimit = 8;

  // ========== ANIMAÇÕES ==========
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimation = Duration(milliseconds: 150);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  static const Duration microAnimation = Duration(milliseconds: 100);

  // Delays sequenciais
  static const Duration staggerDelay = Duration(milliseconds: 100);
  static const Duration cascadeDelay = Duration(milliseconds: 150);

  // Durações específicas
  static const Duration splashMinDuration = Duration(seconds: 2);
  static const Duration snackBarDuration = Duration(seconds: 4);
  static const Duration toastDuration = Duration(seconds: 3);
  static const Duration loadingTimeout = Duration(seconds: 30);

  // Durações de cache para comunidades
  static const Duration cachePopularCommunities = Duration(minutes: 15);
  static const Duration cacheTrendingCommunities = Duration(minutes: 10);
  static const Duration cacheUserCommunities = Duration(minutes: 5);
  static const Duration cacheSearchResults = Duration(minutes: 3);

  // ========== URLS E LINKS ==========
  static const String websiteUrl = 'https://clashup.app';
  static const String privacyPolicyUrl = 'https://clashup.app/privacy';
  static const String termsOfServiceUrl = 'https://clashup.app/terms';
  static const String supportUrl = 'https://clashup.app/support';
  static const String feedbackUrl = 'https://clashup.app/feedback';

  // APIs externas
  static const String defaultApiUrl = 'https://api.clashup.app';
  static const String analyticsUrl = 'https://analytics.clashup.app';

  // ========== CONFIGURAÇÕES DE CACHE ==========
  static const Duration defaultCacheDuration = Duration(minutes: 5);
  static const Duration userDataCacheDuration = Duration(minutes: 10);
  static const Duration settingsCacheDuration = Duration(hours: 1);
  static const Duration staticContentCacheDuration = Duration(days: 1);

  // ========== CONFIGURAÇÕES DE RATE LIMITING ==========
  static const Duration postCooldown = Duration(seconds: 30);
  static const Duration commentCooldown = Duration(seconds: 10);
  static const Duration messageCooldown = Duration(seconds: 5);
  static const Duration challengeCreateCooldown = Duration(minutes: 5);
  static const Duration communityCreateCooldown = Duration(hours: 24); // NOVO
  static const Duration communityJoinCooldown = Duration(minutes: 30); // NOVO

  // ========== CONFIGURAÇÕES DE NOTIFICAÇÃO ==========
  static const String notificationChannelId = 'clashup_notifications';
  static const String notificationChannelName = 'ClashUp';
  static const String notificationChannelDescription =
      'Notificações do ClashUp';

  // Canais específicos para comunidades (NOVO)
  static const String communityNotificationChannelId =
      'community_notifications';
  static const String communityNotificationChannelName = 'Comunidades';
  static const String communityNotificationChannelDescription =
      'Notificações de comunidades';

  // ========== CONFIGURAÇÕES DE ANALYTICS ==========
  static const String analyticsUserId = 'user_id';
  static const String analyticsSessionId = 'session_id';
  static const String analyticsAppVersion = 'app_version';
  static const String analyticsPlatform = 'platform';

  // Eventos de analytics para comunidades (NOVO)
  static const String eventCommunityCreated = 'community_created';
  static const String eventCommunityJoined = 'community_joined';
  static const String eventCommunityLeft = 'community_left';
  static const String eventCommunityPostCreated = 'community_post_created';
  static const String eventCommunitySearched = 'community_searched';
  static const String eventCommunityMemberPromoted =
      'community_member_promoted';

  // ========== MENSAGENS DE ERRO ==========
  static const String errorNetworkConnection = 'Erro de conexão com a internet';
  static const String errorServerUnavailable = 'Servidor indisponível';
  static const String errorUnauthorized = 'Acesso não autorizado';
  static const String errorUserNotFound = 'Usuário não encontrado';
  static const String errorInvalidInput = 'Dados inválidos';
  static const String errorGeneric = 'Algo deu errado. Tente novamente.';

  // Mensagens de erro específicas para comunidades (NOVO)
  static const String errorCommunityNotFound = 'Comunidade não encontrada';
  static const String errorUserNotMember = 'Usuário não é membro da comunidade';
  static const String errorInsufficientPermissions = 'Permissões insuficientes';
  static const String errorCommunityNameTaken =
      'Nome da comunidade já está em uso';
  static const String errorMaxCommunitiesReached =
      'Limite máximo de comunidades atingido';
  static const String errorCommunityCreateCooldown =
      'Aguarde antes de criar outra comunidade';
  static const String errorCommunityJoinCooldown =
      'Aguarde antes de entrar em outra comunidade';

  // ========== MENSAGENS DE SUCESSO ==========
  static const String successProfileUpdated = 'Perfil atualizado com sucesso';
  static const String successPasswordChanged = 'Senha alterada com sucesso';
  static const String successEmailUpdated = 'Email atualizado com sucesso';

  // Mensagens de sucesso para comunidades (NOVO)
  static const String successCommunityCreated = 'Comunidade criada com sucesso';
  static const String successCommunityJoined = 'Você entrou na comunidade';
  static const String successCommunityLeft = 'Você saiu da comunidade';
  static const String successCommunityUpdated =
      'Comunidade atualizada com sucesso';
  static const String successPostCreated = 'Post criado com sucesso';

  // ========== CONFIGURAÇÕES DE VALIDAÇÃO ==========
  static const String usernamePattern = r'^[a-zA-Z0-9_]+$';
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^\+?[1-9]\d{1,14}$';

  // Padrões de validação para comunidades (NOVO)
  static const String communityNamePattern = r'^[a-zA-Z0-9\s\-_]+$';
  static const String communityTagPattern = r'^[a-zA-Z0-9_]+$';

  // ========== CONFIGURAÇÕES DE SEGURANÇA ==========
  static const int maxLoginAttempts = 5;
  static const Duration loginCooldownDuration = Duration(minutes: 15);
  static const int passwordMinLength = 8;
  static const Duration sessionTimeout = Duration(hours: 24);

  // ========== CONFIGURAÇÕES DE DESENVOLVIMENTO ==========
  static const bool enableDebugMode = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enablePerformanceMonitoring = true;

  // ========== CÓDIGOS DE STATUS ==========
  static const int statusSuccess = 200;
  static const int statusCreated = 201;
  static const int statusNoContent = 204;
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusForbidden = 403;
  static const int statusNotFound = 404;
  static const int statusConflict = 409;
  static const int statusInternalServerError = 500;

  // ========== MÉTODOS UTILITÁRIOS ==========

  /// Calcular nível baseado no XP
  static int calculateLevel(int xp) {
    return (xp / xpPerLevel).floor() + 1;
  }

  /// Calcular XP necessário para o próximo nível
  static int xpForNextLevel(int currentXp) {
    final currentLevel = calculateLevel(currentXp);
    return (currentLevel * xpPerLevel) - currentXp;
  }

  /// Verificar se texto é válido para username
  static bool isValidUsername(String username) {
    if (username.length < minUsernameLength ||
        username.length > maxUsernameLength) {
      return false;
    }
    return RegExp(usernamePattern).hasMatch(username);
  }

  /// Verificar se email é válido
  static bool isValidEmail(String email) {
    return RegExp(emailPattern).hasMatch(email);
  }

  /// Verificar se nome de comunidade é válido (NOVO)
  static bool isValidCommunityName(String name) {
    if (name.length < minCommunityNameLength ||
        name.length > maxCommunityNameLength) {
      return false;
    }
    return RegExp(communityNamePattern).hasMatch(name);
  }

  /// Verificar se tag de comunidade é válida (NOVO)
  static bool isValidCommunityTag(String tag) {
    if (tag.length > maxCommunityTagLength) {
      return false;
    }
    return RegExp(communityTagPattern).hasMatch(tag);
  }

  /// Calcular nível de comunidade baseado no número de membros (NOVO)
  static int calculateCommunityLevel(int membersCount) {
    const thresholds = {
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

    for (int level = thresholds.length; level >= 1; level--) {
      if (membersCount >= (thresholds[level] ?? 0)) {
        return level;
      }
    }
    return 1;
  }

  /// Verificar se comunidade pode ser verificada (NOVO)
  static bool canCommunityBeVerified(int membersCount, int communityLevel) {
    return membersCount >= 500 && communityLevel >= 6;
  }

  /// Obter cor baseada no nível (NOVO)
  static String getLevelColor(int level) {
    if (level >= 10) return '#FFD700'; // Dourado
    if (level >= 8) return '#C0C0C0'; // Prateado
    if (level >= 6) return '#CD7F32'; // Bronze
    if (level >= 4) return '#4CAF50'; // Verde
    if (level >= 2) return '#2196F3'; // Azul
    return '#9E9E9E'; // Cinza
  }
}
