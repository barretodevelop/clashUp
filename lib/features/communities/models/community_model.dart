// CommunityModel - Dados basicos da comunidade
// Arquivo criado automaticamente pelo script de estrutura
// Data: 2025-06-27 13:56:53
// Projeto: ClashUp - Sistema de Comunidades

// TODO: Implementar a classe/funcionalidade
// lib/features/communities/models/community_model.dart
// CommunityModel - Dados básicos da comunidade
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum CommunityPrivacyType {
  public, // Qualquer um pode ver e entrar
  private, // Apenas por convite
  restricted, // Qualquer um pode ver, mas precisa de aprovação para entrar
}

enum CommunityCategory {
  technology,
  music,
  sports,
  games,
  movies,
  books,
  food,
  travel,
  lifestyle,
  education,
  business,
  art,
  health,
  relationships,
  humor,
  other,
}

class CommunityModel {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final String? bannerUrl;
  final String creatorId;
  final List<String> moderatorIds;
  final List<String> tags;
  final CommunityCategory category;
  final CommunityPrivacyType privacyType;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Estatísticas
  final int membersCount;
  final int postsCount;
  final int activeUsersCount; // Usuários ativos nos últimos 7 dias
  final Map<String, int> weeklyStats; // Estatísticas semanais

  // Configurações
  final bool allowPosts; // Membros podem criar posts
  final bool allowComments; // Membros podem comentar
  final bool requireApproval; // Posts precisam de aprovação
  final bool isVerified; // Comunidade verificada
  final bool isActive; // Comunidade ativa (não arquivada)
  final bool isPremium; // Comunidade premium

  // Gamificação
  final int communityLevel; // Nível da comunidade baseado na atividade
  final int communityXp; // XP total da comunidade
  final Map<String, dynamic> achievements; // Conquistas da comunidade

  // Regras e informações extras
  final String? rules; // Regras da comunidade
  final String? welcomeMessage; // Mensagem de boas-vindas
  final Map<String, dynamic> customSettings; // Configurações personalizadas

  const CommunityModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.bannerUrl,
    required this.creatorId,
    this.moderatorIds = const [],
    this.tags = const [],
    required this.category,
    this.privacyType = CommunityPrivacyType.public,
    required this.createdAt,
    required this.updatedAt,
    this.membersCount = 1, // Criador é o primeiro membro
    this.postsCount = 0,
    this.activeUsersCount = 1,
    this.weeklyStats = const {},
    this.allowPosts = true,
    this.allowComments = true,
    this.requireApproval = false,
    this.isVerified = false,
    this.isActive = true,
    this.isPremium = false,
    this.communityLevel = 1,
    this.communityXp = 0,
    this.achievements = const {},
    this.rules,
    this.welcomeMessage,
    this.customSettings = const {},
  });

  // Getters úteis
  bool get isPublic => privacyType == CommunityPrivacyType.public;
  bool get isPrivate => privacyType == CommunityPrivacyType.private;
  bool get isRestricted => privacyType == CommunityPrivacyType.restricted;
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  bool get hasBanner => bannerUrl != null && bannerUrl!.isNotEmpty;
  bool get hasRules => rules != null && rules!.isNotEmpty;
  bool get hasWelcomeMessage =>
      welcomeMessage != null && welcomeMessage!.isNotEmpty;

  // Verificar se usuário é moderador
  bool isModerator(String userId) =>
      moderatorIds.contains(userId) || creatorId == userId;

  // Verificar se usuário é criador
  bool isCreator(String userId) => creatorId == userId;

  /// Factory constructor para criar do JSON/Firestore
  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'],
      bannerUrl: json['bannerUrl'],
      creatorId: json['creatorId'] ?? '',
      moderatorIds: List<String>.from(json['moderatorIds'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      category: CommunityCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => CommunityCategory.other,
      ),
      privacyType: CommunityPrivacyType.values.firstWhere(
        (e) => e.name == json['privacyType'],
        orElse: () => CommunityPrivacyType.public,
      ),
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
              DateTime.now(),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
              DateTime.now(),
      membersCount: json['membersCount'] as int? ?? 1,
      postsCount: json['postsCount'] as int? ?? 0,
      activeUsersCount: json['activeUsersCount'] as int? ?? 1,
      weeklyStats: Map<String, int>.from(json['weeklyStats'] as Map? ?? {}),
      allowPosts: json['allowPosts'] as bool? ?? true,
      allowComments: json['allowComments'] as bool? ?? true,
      requireApproval: json['requireApproval'] as bool? ?? false,
      isVerified: json['isVerified'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      isPremium: json['isPremium'] as bool? ?? false,
      communityLevel: json['communityLevel'] as int? ?? 1,
      communityXp: json['communityXp'] as int? ?? 0,
      achievements:
          Map<String, dynamic>.from(json['achievements'] as Map? ?? {}),
      rules: json['rules'],
      welcomeMessage: json['welcomeMessage'],
      customSettings:
          Map<String, dynamic>.from(json['customSettings'] as Map? ?? {}),
    );
  }

  /// Converter para JSON/Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'bannerUrl': bannerUrl,
      'creatorId': creatorId,
      'moderatorIds': moderatorIds,
      'tags': tags,
      'category': category.name,
      'privacyType': privacyType.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'membersCount': membersCount,
      'postsCount': postsCount,
      'activeUsersCount': activeUsersCount,
      'weeklyStats': weeklyStats,
      'allowPosts': allowPosts,
      'allowComments': allowComments,
      'requireApproval': requireApproval,
      'isVerified': isVerified,
      'isActive': isActive,
      'isPremium': isPremium,
      'communityLevel': communityLevel,
      'communityXp': communityXp,
      'achievements': achievements,
      'rules': rules,
      'welcomeMessage': welcomeMessage,
      'customSettings': customSettings,
    };
  }

  /// CopyWith para imutabilidade
  CommunityModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? bannerUrl,
    String? creatorId,
    List<String>? moderatorIds,
    List<String>? tags,
    CommunityCategory? category,
    CommunityPrivacyType? privacyType,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? membersCount,
    int? postsCount,
    int? activeUsersCount,
    Map<String, int>? weeklyStats,
    bool? allowPosts,
    bool? allowComments,
    bool? requireApproval,
    bool? isVerified,
    bool? isActive,
    bool? isPremium,
    int? communityLevel,
    int? communityXp,
    Map<String, dynamic>? achievements,
    String? rules,
    String? welcomeMessage,
    Map<String, dynamic>? customSettings,
  }) {
    return CommunityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      creatorId: creatorId ?? this.creatorId,
      moderatorIds: moderatorIds ?? this.moderatorIds,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      privacyType: privacyType ?? this.privacyType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      membersCount: membersCount ?? this.membersCount,
      postsCount: postsCount ?? this.postsCount,
      activeUsersCount: activeUsersCount ?? this.activeUsersCount,
      weeklyStats: weeklyStats ?? this.weeklyStats,
      allowPosts: allowPosts ?? this.allowPosts,
      allowComments: allowComments ?? this.allowComments,
      requireApproval: requireApproval ?? this.requireApproval,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      isPremium: isPremium ?? this.isPremium,
      communityLevel: communityLevel ?? this.communityLevel,
      communityXp: communityXp ?? this.communityXp,
      achievements: achievements ?? this.achievements,
      rules: rules ?? this.rules,
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
      customSettings: customSettings ?? this.customSettings,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommunityModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.bannerUrl == bannerUrl &&
        other.creatorId == creatorId &&
        listEquals(other.moderatorIds, moderatorIds) &&
        listEquals(other.tags, tags) &&
        other.category == category &&
        other.privacyType == privacyType &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.membersCount == membersCount &&
        other.postsCount == postsCount &&
        other.activeUsersCount == activeUsersCount &&
        mapEquals(other.weeklyStats, weeklyStats) &&
        other.allowPosts == allowPosts &&
        other.allowComments == allowComments &&
        other.requireApproval == requireApproval &&
        other.isVerified == isVerified &&
        other.isActive == isActive &&
        other.isPremium == isPremium &&
        other.communityLevel == communityLevel &&
        other.communityXp == communityXp &&
        mapEquals(other.achievements, achievements) &&
        other.rules == rules &&
        other.welcomeMessage == welcomeMessage &&
        mapEquals(other.customSettings, customSettings);
  }

  @override
  int get hashCode {
    return Object.hashAll([
      id,
      name,
      description,
      imageUrl,
      bannerUrl,
      creatorId,
      moderatorIds,
      tags,
      category,
      privacyType,
      createdAt,
      updatedAt,
      membersCount,
      postsCount,
      activeUsersCount,
      weeklyStats,
      allowPosts,
      allowComments,
      requireApproval,
      isVerified,
      isActive,
      isPremium,
      communityLevel,
      communityXp,
      achievements,
      rules,
      welcomeMessage,
      customSettings,
    ]);
  }

  @override
  String toString() {
    return 'CommunityModel(id: $id, name: $name, category: $category, membersCount: $membersCount, privacyType: $privacyType)';
  }

  /// Factory para criar nova comunidade
  factory CommunityModel.create({
    required String name,
    required String description,
    required String creatorId,
    required CommunityCategory category,
    CommunityPrivacyType privacyType = CommunityPrivacyType.public,
    List<String> tags = const [],
    String? imageUrl,
    String? rules,
    String? welcomeMessage,
  }) {
    final now = DateTime.now();
    return CommunityModel(
      id: '', // Será definido pelo Firestore
      name: name,
      description: description,
      creatorId: creatorId,
      category: category,
      privacyType: privacyType,
      tags: tags,
      imageUrl: imageUrl,
      rules: rules,
      welcomeMessage: welcomeMessage,
      createdAt: now,
      updatedAt: now,
      moderatorIds: [creatorId], // Criador é automaticamente moderador
    );
  }
}

/// Extensões para CommunityCategory
extension CommunityCategoryExtension on CommunityCategory {
  String get displayName {
    switch (this) {
      case CommunityCategory.technology:
        return 'Tecnologia';
      case CommunityCategory.music:
        return 'Música';
      case CommunityCategory.sports:
        return 'Esportes';
      case CommunityCategory.games:
        return 'Jogos';
      case CommunityCategory.movies:
        return 'Filmes';
      case CommunityCategory.books:
        return 'Livros';
      case CommunityCategory.food:
        return 'Comida';
      case CommunityCategory.travel:
        return 'Viagem';
      case CommunityCategory.lifestyle:
        return 'Estilo de Vida';
      case CommunityCategory.education:
        return 'Educação';
      case CommunityCategory.business:
        return 'Negócios';
      case CommunityCategory.art:
        return 'Arte';
      case CommunityCategory.health:
        return 'Saúde';
      case CommunityCategory.relationships:
        return 'Relacionamentos';
      case CommunityCategory.humor:
        return 'Humor';
      case CommunityCategory.other:
        return 'Outros';
    }
  }

  String get emoji {
    switch (this) {
      case CommunityCategory.technology:
        return '💻';
      case CommunityCategory.music:
        return '🎵';
      case CommunityCategory.sports:
        return '⚽';
      case CommunityCategory.games:
        return '🎮';
      case CommunityCategory.movies:
        return '🎬';
      case CommunityCategory.books:
        return '📚';
      case CommunityCategory.food:
        return '🍕';
      case CommunityCategory.travel:
        return '✈️';
      case CommunityCategory.lifestyle:
        return '🌟';
      case CommunityCategory.education:
        return '🎓';
      case CommunityCategory.business:
        return '💼';
      case CommunityCategory.art:
        return '🎨';
      case CommunityCategory.health:
        return '💪';
      case CommunityCategory.relationships:
        return '❤️';
      case CommunityCategory.humor:
        return '😂';
      case CommunityCategory.other:
        return '📂';
    }
  }
}
