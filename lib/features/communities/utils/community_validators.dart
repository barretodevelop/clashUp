// CommunityValidators - Validacoes de formularios
// Arquivo criado automaticamente pelo script de estrutura
// Data: 2025-06-27 13:56:54
// Projeto: ClashUp - Sistema de Comunidades

// TODO: Implementar a classe/funcionalidade
// lib/features/communities/utils/community_validators.dart
// CommunityValidators - Validações de formulários e dados das comunidades
import 'package:clashup/core/constants/app_constants.dart';
import 'package:clashup/features/communities/constants/community_constants.dart';

class CommunityValidators {
  // ========== VALIDAÇÕES DE NOME ==========

  /// Validar nome da comunidade
  static String? validateCommunityName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome da comunidade é obrigatório';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < CommunityConstants.minCommunityNameLength) {
      return 'Nome deve ter pelo menos ${CommunityConstants.minCommunityNameLength} caracteres';
    }

    if (trimmedValue.length > CommunityConstants.maxCommunityNameLength) {
      return 'Nome deve ter no máximo ${CommunityConstants.maxCommunityNameLength} caracteres';
    }

    if (!AppConstants.isValidCommunityName(trimmedValue)) {
      return 'Nome contém caracteres inválidos. Use apenas letras, números, espaços, hífen e underscore';
    }

    // Verificar palavras proibidas
    if (_containsBannedWords(trimmedValue)) {
      return 'Nome contém palavras não permitidas';
    }

    return null;
  }

  // ========== VALIDAÇÕES DE DESCRIÇÃO ==========

  /// Validar descrição da comunidade
  static String? validateCommunityDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Descrição da comunidade é obrigatória';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length <
        CommunityConstants.minCommunityDescriptionLength) {
      return 'Descrição deve ter pelo menos ${CommunityConstants.minCommunityDescriptionLength} caracteres';
    }

    if (trimmedValue.length >
        CommunityConstants.maxCommunityDescriptionLength) {
      return 'Descrição deve ter no máximo ${CommunityConstants.maxCommunityDescriptionLength} caracteres';
    }

    // Verificar conteúdo inadequado
    if (_containsInappropriateContent(trimmedValue)) {
      return 'Descrição contém conteúdo inadequado';
    }

    return null;
  }

  // ========== VALIDAÇÕES DE REGRAS ==========

  /// Validar regras da comunidade
  static String? validateCommunityRules(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Regras são opcionais
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length > CommunityConstants.maxCommunityRulesLength) {
      return 'Regras devem ter no máximo ${CommunityConstants.maxCommunityRulesLength} caracteres';
    }

    if (_containsInappropriateContent(trimmedValue)) {
      return 'Regras contêm conteúdo inadequado';
    }

    return null;
  }

  // ========== VALIDAÇÕES DE MENSAGEM DE BOAS-VINDAS ==========

  /// Validar mensagem de boas-vindas
  static String? validateWelcomeMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Mensagem de boas-vindas é opcional
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length > CommunityConstants.maxWelcomeMessageLength) {
      return 'Mensagem deve ter no máximo ${CommunityConstants.maxWelcomeMessageLength} caracteres';
    }

    if (_containsInappropriateContent(trimmedValue)) {
      return 'Mensagem contém conteúdo inadequado';
    }

    return null;
  }

  // ========== VALIDAÇÕES DE TAGS ==========

  /// Validar tag individual
  static String? validateCommunityTag(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tag não pode estar vazia';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length > CommunityConstants.maxTagLength) {
      return 'Tag deve ter no máximo ${CommunityConstants.maxTagLength} caracteres';
    }

    if (!AppConstants.isValidCommunityTag(trimmedValue)) {
      return 'Tag contém caracteres inválidos. Use apenas letras, números e underscore';
    }

    if (_containsBannedWords(trimmedValue)) {
      return 'Tag contém palavras não permitidas';
    }

    return null;
  }

  /// Validar lista de tags
  static String? validateCommunityTags(List<String> tags) {
    if (tags.length > CommunityConstants.maxTagsCount) {
      return 'Máximo de ${CommunityConstants.maxTagsCount} tags permitidas';
    }

    for (final tag in tags) {
      final validation = validateCommunityTag(tag);
      if (validation != null) {
        return 'Tag "$tag": $validation';
      }
    }

    // Verificar duplicatas
    final uniqueTags = tags.toSet();
    if (uniqueTags.length != tags.length) {
      return 'Tags duplicadas não são permitidas';
    }

    return null;
  }

  // ========== VALIDAÇÕES DE POSTS ==========

  /// Validar título do post
  static String? validatePostTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Título do post é obrigatório';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < 3) {
      return 'Título deve ter pelo menos 3 caracteres';
    }

    if (trimmedValue.length > 100) {
      return 'Título deve ter no máximo 100 caracteres';
    }

    if (_containsInappropriateContent(trimmedValue)) {
      return 'Título contém conteúdo inadequado';
    }

    return null;
  }

  /// Validar conteúdo do post
  static String? validatePostContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Conteúdo do post é obrigatório';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < 10) {
      return 'Conteúdo deve ter pelo menos 10 caracteres';
    }

    if (trimmedValue.length > 5000) {
      return 'Conteúdo deve ter no máximo 5000 caracteres';
    }

    if (_containsInappropriateContent(trimmedValue)) {
      return 'Conteúdo contém material inadequado';
    }

    return null;
  }

  // ========== VALIDAÇÕES DE COMENTÁRIOS ==========

  /// Validar comentário
  static String? validateComment(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Comentário não pode estar vazio';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < 2) {
      return 'Comentário deve ter pelo menos 2 caracteres';
    }

    if (trimmedValue.length > 500) {
      return 'Comentário deve ter no máximo 500 caracteres';
    }

    if (_containsInappropriateContent(trimmedValue)) {
      return 'Comentário contém conteúdo inadequado';
    }

    if (_isSpam(trimmedValue)) {
      return 'Comentário identificado como spam';
    }

    return null;
  }

  // ========== VALIDAÇÕES DE PERMISSÕES ==========

  /// Verificar se usuário pode criar comunidade
  static ValidationResult canUserCreateCommunity({
    required int userLevel,
    required int ownedCommunitiesCount,
    required DateTime? lastCommunityCreated,
  }) {
    // Verificar nível mínimo
    if (userLevel < 2) {
      return ValidationResult.error(
        'Você precisa ser nível 2 ou superior para criar comunidades',
      );
    }

    // Verificar limite de comunidades
    if (ownedCommunitiesCount >=
        CommunityConstants.maxOwnedCommunitiesPerUser) {
      return ValidationResult.error(
        'Você já possui o máximo de ${CommunityConstants.maxOwnedCommunitiesPerUser} comunidades',
      );
    }

    // Verificar cooldown
    if (lastCommunityCreated != null) {
      final timeSinceLastCreation =
          DateTime.now().difference(lastCommunityCreated);
      if (timeSinceLastCreation < CommunityConstants.cooldownCreateCommunity) {
        final remainingTime =
            CommunityConstants.cooldownCreateCommunity - timeSinceLastCreation;
        final hours = remainingTime.inHours;
        final minutes = remainingTime.inMinutes % 60;

        return ValidationResult.error(
          'Aguarde ${hours}h ${minutes}m antes de criar outra comunidade',
        );
      }
    }

    return ValidationResult.success();
  }

  /// Verificar se usuário pode entrar em comunidade
  static ValidationResult canUserJoinCommunity({
    required int joinedCommunitiesCount,
    required DateTime? lastCommunityJoined,
  }) {
    // Verificar limite de comunidades
    if (joinedCommunitiesCount >=
        CommunityConstants.maxJoinedCommunitiesPerUser) {
      return ValidationResult.error(
        'Você já participa do máximo de ${CommunityConstants.maxJoinedCommunitiesPerUser} comunidades',
      );
    }

    // Verificar cooldown
    if (lastCommunityJoined != null) {
      final timeSinceLastJoin = DateTime.now().difference(lastCommunityJoined);
      if (timeSinceLastJoin < CommunityConstants.cooldownJoinCommunities) {
        final remainingMinutes =
            (CommunityConstants.cooldownJoinCommunities - timeSinceLastJoin)
                .inMinutes;

        return ValidationResult.error(
          'Aguarde ${remainingMinutes} minutos antes de entrar em outra comunidade',
        );
      }
    }

    return ValidationResult.success();
  }

  // ========== VALIDAÇÕES DE MODERAÇÃO ==========

  /// Verificar se usuário pode moderar
  static ValidationResult canUserModerate({
    required int moderatedCommunitiesCount,
    required int userLevel,
    required int communityMembershipDays,
  }) {
    // Verificar nível mínimo
    if (userLevel < 5) {
      return ValidationResult.error(
        'Você precisa ser nível 5 ou superior para ser moderador',
      );
    }

    // Verificar limite de moderação
    if (moderatedCommunitiesCount >=
        CommunityConstants.maxModeratedCommunitiesPerUser) {
      return ValidationResult.error(
        'Você já modera o máximo de ${CommunityConstants.maxModeratedCommunitiesPerUser} comunidades',
      );
    }

    // Verificar tempo de participação
    if (communityMembershipDays < 7) {
      return ValidationResult.error(
        'Você precisa ser membro há pelo menos 7 dias para ser moderador',
      );
    }

    return ValidationResult.success();
  }

  // ========== MÉTODOS AUXILIARES PRIVADOS ==========

  /// Verificar palavras banidas
  static bool _containsBannedWords(String text) {
    final bannedWords = [
      'spam', 'scam', 'fake', 'hack', 'virus', 'malware',
      'admin', 'moderator', 'official', 'verified',
      // Adicionar mais palavras conforme necessário
    ];

    final lowercaseText = text.toLowerCase();
    return bannedWords
        .any((word) => lowercaseText.contains(word.toLowerCase()));
  }

  /// Verificar conteúdo inadequado
  static bool _containsInappropriateContent(String text) {
    final inappropriateWords = [
      // Lista de palavras inadequadas
      // Implementar conforme as políticas da plataforma
    ];

    final lowercaseText = text.toLowerCase();
    return inappropriateWords
        .any((word) => lowercaseText.contains(word.toLowerCase()));
  }

  /// Verificar se é spam
  static bool _isSpam(String text) {
    // Verificar caracteres repetidos
    if (RegExp(r'(.)\1{4,}').hasMatch(text)) {
      return true;
    }

    // Verificar URLs suspeitas
    if (RegExp(
            r'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+')
        .hasMatch(text)) {
      // Implementar verificação de URLs suspeitas
    }

    // Verificar padrões de spam
    final spamPatterns = [
      r'\b(buy|sell|cheap|free|offer|deal)\b.*\b(now|today|click|visit)\b',
      r'\b(win|winner|prize|lottery|money)\b',
      r'\b(urgent|limited|exclusive|special)\b.*\b(offer|deal)\b',
    ];

    final lowercaseText = text.toLowerCase();
    return spamPatterns
        .any((pattern) => RegExp(pattern).hasMatch(lowercaseText));
  }

  // ========== VALIDAÇÕES PERSONALIZADAS ==========

  /// Validar nome único (necessita verificação no backend)
  static Future<ValidationResult> validateUniqueCommunityName(
      String name) async {
    // Implementar verificação de nome único
    // Esta função deve fazer uma consulta ao backend/Firestore

    try {
      // Simulação - substituir por verificação real
      await Future.delayed(const Duration(milliseconds: 500));

      // Verificar no Firestore se já existe comunidade com este nome
      // final exists = await CommunityService.communityNameExists(name);
      // if (exists) {
      //   return ValidationResult.error('Este nome já está em uso');
      // }

      return ValidationResult.success();
    } catch (e) {
      return ValidationResult.error(
          'Erro ao verificar disponibilidade do nome');
    }
  }

  /// Validar quota de criação de comunidades
  static ValidationResult validateCreationQuota({
    required int communitiesCreatedToday,
    required bool isPremiumUser,
  }) {
    final maxDaily = isPremiumUser ? 5 : 1;

    if (communitiesCreatedToday >= maxDaily) {
      return ValidationResult.error(
        isPremiumUser
            ? 'Limite diário de 5 comunidades atingido'
            : 'Limite diário de 1 comunidade atingido. Upgrade para Premium para criar mais',
      );
    }

    return ValidationResult.success();
  }
}

/// Classe para resultado de validação
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult._({
    required this.isValid,
    this.errorMessage,
  });

  factory ValidationResult.success() {
    return const ValidationResult._(isValid: true);
  }

  factory ValidationResult.error(String message) {
    return ValidationResult._(isValid: false, errorMessage: message);
  }

  bool get isError => !isValid;
}

/// Extensões para facilitar validações
extension StringCommunityValidation on String? {
  String? get validateCommunityName =>
      CommunityValidators.validateCommunityName(this);
  String? get validateCommunityDescription =>
      CommunityValidators.validateCommunityDescription(this);
  String? get validateCommunityRules =>
      CommunityValidators.validateCommunityRules(this);
  String? get validateWelcomeMessage =>
      CommunityValidators.validateWelcomeMessage(this);
  String? get validateCommunityTag =>
      CommunityValidators.validateCommunityTag(this);
  String? get validatePostTitle => CommunityValidators.validatePostTitle(this);
  String? get validatePostContent =>
      CommunityValidators.validatePostContent(this);
  String? get validateComment => CommunityValidators.validateComment(this);
}

/// Constantes para validação
class CommunityValidationConstants {
  static const int minCommunityNameLength = 3;
  static const int maxCommunityNameLength = 50;
  static const int minDescriptionLength = 10;
  static const int maxDescriptionLength = 500;
  static const int maxRulesLength = 2000;
  static const int maxWelcomeMessageLength = 300;
  static const int maxTagLength = 20;
  static const int maxTagsCount = 10;
  static const int minPostTitleLength = 3;
  static const int maxPostTitleLength = 100;
  static const int minPostContentLength = 10;
  static const int maxPostContentLength = 5000;
  static const int minCommentLength = 2;
  static const int maxCommentLength = 500;
}

/// Tipos de validação para diferentes contextos
enum ValidationType {
  create, // Criação de comunidade
  edit, // Edição de comunidade
  join, // Entrada em comunidade
  post, // Criação de post
  comment, // Criação de comentário
  moderate, // Ações de moderação
}
