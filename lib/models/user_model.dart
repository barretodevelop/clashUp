//lib/models/user_model.dart - Versão Corrigida com Onboarding (Atualizada conforme seu código)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // For mapEquals

class UserModel {
  final String uid;
  final String username;
  final String displayName;
  final String avatar;
  final String email;
  final int level;
  final int xp;
  final int coins;
  final int gems;
  final DateTime createdAt;
  final Map<String, dynamic> aiConfig;
  final String? currentMood; // Adicionado: Humor atual do usuário

  // ✅ NOVOS CAMPOS PARA ONBOARDING
  final String? codinome; // Nome anônimo escolhido
  final String? avatarId; // ID do avatar selecionado
  final DateTime? birthDate; // Data de nascimento
  final List<String> interesses; // Lista de interesses
  final String? relationshipGoal; // Objetivo: amizade, namoro, etc
  final int connectionLevel; // Nível de exigência 1-10
  final bool onboardingCompleted; // Se completou onboarding
  final DateTime? onboardingCompletedAt; // Quando completou

  // Campos para controle de Login Diário e Streak
  final DateTime? lastLoginDate;
  final int? loginStreak;
  final Map<String, bool> clashupedFeatures;

  const UserModel({
    required this.uid,
    required this.username,
    required this.displayName,
    required this.avatar,
    required this.email,
    required this.level,
    required this.xp,
    required this.coins,
    required this.gems,
    required this.createdAt,
    required this.aiConfig,
    this.currentMood,
    // Novos campos com defaults seguros
    this.codinome,
    this.avatarId,
    this.birthDate,
    this.interesses = const [],
    this.relationshipGoal,
    this.connectionLevel = 5,
    this.onboardingCompleted = false, // ✅ DEFAULT FALSE
    this.onboardingCompletedAt,
    this.lastLoginDate,
    this.loginStreak,
    this.clashupedFeatures = const {}, // Default to an empty map
  });

  // ✅ GETTER PARA VERIFICAR SE PRECISA DE ONBOARDING
  bool get needsOnboarding {
    // A propriedade `onboardingCompleted` é a única fonte de verdade para determinar
    // se o fluxo de onboarding foi finalizado.
    return !onboardingCompleted;
  }

  // ✅ GETTER PARA VERIFICAR SE É MENOR DE IDADE
  bool get isMinor {
    if (birthDate == null) return false;
    final age = DateTime.now().difference(birthDate!).inDays ~/ 365;
    return age < 18;
  }

  // ✅ GETTER PARA IDADE
  int? get age {
    if (birthDate == null) return null;
    return DateTime.now().difference(birthDate!).inDays ~/ 365;
  }

  /// Cria uma instância a partir de um Map (ex: vindo de JSON ou Firebase)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      username: json['username'] ?? '',
      displayName: json['displayName'] ?? '',
      avatar: json['avatar'] ?? '',
      email: json['email'] ?? '',
      level: json['level'] ?? 1,
      xp: json['xp'] ?? 0,
      coins: json['coins'] ?? 200,
      gems: json['gems'] ?? 20,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      aiConfig: Map<String, dynamic>.from(json['aiConfig'] ?? {}),
      currentMood: json['currentMood'] as String?,

      // ✅ NOVOS CAMPOS COM FALLBACKS SEGUROS
      codinome: json['codinome'],
      avatarId: json['avatarId'],
      lastLoginDate: (json['lastLoginDate'] is Timestamp)
          ? (json['lastLoginDate'] as Timestamp).toDate()
          : null,
      loginStreak: json['loginStreak'] as int?,
      birthDate: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'])
          : null,
      interesses: List<String>.from(json['interesses'] ?? []),
      relationshipGoal: json['relationshipGoal'],
      connectionLevel: json['connectionLevel'] ?? 5,
      onboardingCompleted:
          json['onboardingCompleted'] ?? false, // ✅ DEFAULT FALSE
      onboardingCompletedAt: json['onboardingCompletedAt'] != null
          ? DateTime.tryParse(json['onboardingCompletedAt'])
          : null,
      clashupedFeatures: Map<String, bool>.from(
        json['clashupedFeatures'] as Map? ?? {},
      ),
    );
  }

  /// Converte a instância para JSON (ex: salvar no SharedPreferences ou Firebase)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'displayName': displayName,
      'avatar': avatar,
      'email': email,
      'level': level,
      'xp': xp,
      'coins': coins,
      'gems': gems,
      'createdAt': createdAt.toIso8601String(),
      'currentMood': currentMood,
      'aiConfig': aiConfig,

      // ✅ NOVOS CAMPOS
      'codinome': codinome,
      'avatarId': avatarId,
      'birthDate': birthDate?.toIso8601String(),
      'interesses': interesses,
      'relationshipGoal': relationshipGoal,
      'connectionLevel': connectionLevel,
      'onboardingCompleted': onboardingCompleted,
      'onboardingCompletedAt': onboardingCompletedAt?.toIso8601String(),
      'lastLoginDate': lastLoginDate?.toIso8601String(),
      'loginStreak': loginStreak,
    };
    // clashupedFeatures will be handled by copyWith or direct update in Firestore
  }

  /// Permite copiar a instância com modificações
  UserModel copyWith({
    String? uid,
    String? username,
    String? displayName,
    String? avatar,
    String? email,
    int? level,
    int? xp,
    int? coins,
    int? gems,
    DateTime? createdAt,
    ValueGetter<String?>? currentMood, // Usar ValueGetter para permitir null
    Map<String, dynamic>? aiConfig,
    String? codinome,
    String? avatarId,
    DateTime? birthDate,
    List<String>? interesses,
    String? relationshipGoal,
    int? connectionLevel,
    bool? onboardingCompleted,
    DateTime? onboardingCompletedAt,
    DateTime? lastLoginDate,
    int? loginStreak,
    Map<String, bool>? clashupedFeatures,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      gems: gems ?? this.gems,
      createdAt: createdAt ?? this.createdAt,
      aiConfig: aiConfig ?? this.aiConfig,
      currentMood: currentMood != null ? currentMood() : this.currentMood,
      codinome: codinome ?? this.codinome,
      avatarId: avatarId ?? this.avatarId,
      birthDate: birthDate ?? this.birthDate,
      interesses: interesses ?? this.interesses,
      relationshipGoal: relationshipGoal ?? this.relationshipGoal,
      connectionLevel: connectionLevel ?? this.connectionLevel,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      onboardingCompletedAt:
          onboardingCompletedAt ?? this.onboardingCompletedAt,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      loginStreak: loginStreak ?? this.loginStreak,
      clashupedFeatures:
          clashupedFeatures ?? Map<String, bool>.from(this.clashupedFeatures),
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, username: $username, currentMood: $currentMood, onboardingCompleted: $onboardingCompleted, needsOnboarding: $needsOnboarding)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.uid == uid &&
        other.username == username &&
        other.displayName == displayName &&
        other.avatar == avatar &&
        other.email == email &&
        other.level == level &&
        other.xp == xp &&
        other.coins == coins &&
        other.gems == gems &&
        other.createdAt == createdAt &&
        mapEquals(other.aiConfig, aiConfig) &&
        other.currentMood == currentMood &&
        other.codinome == codinome &&
        other.avatarId == avatarId &&
        other.birthDate == birthDate &&
        listEquals(other.interesses, interesses) &&
        other.relationshipGoal == relationshipGoal &&
        other.connectionLevel == connectionLevel &&
        other.onboardingCompleted == onboardingCompleted &&
        other.onboardingCompletedAt == onboardingCompletedAt &&
        other.lastLoginDate == lastLoginDate && // Already included, good.
        other.loginStreak == loginStreak && // Already included, good.
        mapEquals(other.clashupedFeatures, clashupedFeatures);
  }

  @override
  int get hashCode {
    return Object.hashAll([
      uid,
      username,
      displayName,
      avatar,
      email,
      level,
      xp,
      coins,
      gems,
      createdAt,
      aiConfig,
      currentMood,
      codinome,
      avatarId,
      birthDate,
      interesses,
      relationshipGoal,
      connectionLevel,
      onboardingCompleted,
      onboardingCompletedAt,
      lastLoginDate,
      loginStreak,
      clashupedFeatures,
    ]);
  }

  /// Factory para criar usuário inicial após login (pré-onboarding)
  factory UserModel.createInitial({
    required String uid,
    required String email,
    String? displayName,
    String? photoURL,
  }) {
    return UserModel(
      uid: uid,
      username: displayName ?? 'Usuário',
      displayName: displayName ?? 'Usuário',
      avatar: photoURL ?? '👤',
      email: email,
      level: 1,
      xp: 0,
      coins: 200, // bonus inicial
      gems: 20, // bonus inicial
      createdAt: DateTime.now(),
      aiConfig: {'apiUrl': '', 'apiKey': '', 'enabled': false},
      currentMood: null, // Humor inicial nulo
      // Campos de onboarding vazios/padrão
      codinome: '',
      avatarId: '',
      birthDate: null,
      interesses: [],
      connectionLevel: 5,
      onboardingCompleted: false,
      onboardingCompletedAt: null,
      relationshipGoal: null,
      lastLoginDate: null, // Provide initial null value
      loginStreak: 0, // Provide initial 0 value
      clashupedFeatures: {}, // Initialize with empty map
    );
  }

  get messagesCount => null;

  get photosCount => null;

  get videosCount => null;

  get fansCount => null;
}
