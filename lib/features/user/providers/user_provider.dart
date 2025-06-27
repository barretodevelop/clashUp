// lib/features/user/providers/user_provider.dart - Atualizado com sistema de Comunidades
import 'package:clashup/core/utils/logger.dart';
import 'package:clashup/features/communities/constants/community_constants.dart';
import 'package:clashup/models/user_model.dart';
import 'package:clashup/providers/auth_provider.dart';
import 'package:clashup/services/analytics/analytics_integration.dart';
import 'package:clashup/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages modifications to the user's data.
/// It now manages the full UserModel including community-related data.
class UserNotifier extends Notifier<UserModel?> {
  /// Initializes [UserNotifier] and sets up listener for AuthState changes.
  @override
  UserModel? build() {
    // This provider now mirrors the user object from AuthProvider.
    // It serves as the dedicated entry point for UI components to get user data
    // and for them to request modifications to it.
    return ref.watch(authProvider.select((state) => state.user));
  }

  /// Updates the user data in the provider's state.
  /// This is useful for local updates (e.g., after onboarding) without re-fetching from Firestore.
  void updateUser(UserModel updatedUser) {
    // This method is for local updates. It should update the central source of truth.
    ref.read(authProvider.notifier).updateUserWithOnboardingData(updatedUser);
  }

  /// Sets the user mode to a new value and updates the state.
  Future<void> setUserMode(UserModeEnum mode) async {
    final user = state;
    if (user != null && user.currentMood != mode.name) {
      // 1. Optimistically update the UI by updating the central state
      final updatedUser = user.copyWith(currentMood: () => mode.name);
      ref.read(authProvider.notifier).updateUserWithOnboardingData(updatedUser);

      // 2. Persist the change to Firestore
      try {
        await FirestoreService()
            .updateUser(user.uid, {'currentMood': mode.name});
        AppLogger.info(
            'UserNotifier: User mood updated in Firestore to ${mode.name}');
      } catch (e) {
        // 3. If Firestore update fails, revert the optimistic update
        // by refreshing the user data from the database.
        AppLogger.info(
            'UserNotifier: Failed to update mood in Firestore, reverting. Error: $e');
        await ref.read(authProvider.notifier).refreshUser();
      }
    }
  }

  /// Define o humor do usuário para um novo valor e atualiza o estado.
  Future<void> updateUserMood(String mood) async {
    final user = state;
    if (user != null && user.currentMood != mood) {
      // 1. Atualiza a UI de forma otimista, atualizando o estado central
      final updatedUser = user.copyWith(currentMood: () => mood);
      ref.read(authProvider.notifier).updateUserWithOnboardingData(updatedUser);

      // 2. Persiste a alteração no Firestore
      try {
        await FirestoreService().updateUser(user.uid, {'currentMood': mood});
        AppLogger.info(
            'UserNotifier: Humor do usuário atualizado no Firestore para $mood');
      } catch (e) {
        // 3. Se a atualização do Firestore falhar, reverte a atualização otimista
        // atualizando os dados do usuário a partir do banco de dados.
        AppLogger.error(
            'UserNotifier: Falha ao atualizar humor no Firestore, revertendo. Erro: $e');
        await ref.read(authProvider.notifier).refreshUser();
      }
    }
  }

  // ========== NOVOS MÉTODOS PARA SISTEMA DE COMUNIDADES ==========

  /// Adicionar usuário a uma comunidade
  Future<bool> joinCommunity(String communityId) async {
    final user = state;
    if (user == null) {
      AppLogger.warning(
          'UserNotifier: Tentativa de entrar em comunidade sem usuário logado');
      return false;
    }

    try {
      AppLogger.info('UserNotifier: Usuário entrando na comunidade', data: {
        'userId': user.uid,
        'communityId': communityId,
      });

      // 1. Atualização otimista
      final updatedCommunities = List<String>.from(user.joinedCommunities);
      if (!updatedCommunities.contains(communityId)) {
        updatedCommunities.add(communityId);
      }

      final updatedUser = user.copyWith(
        joinedCommunities: updatedCommunities,
        communityXpEarned:
            user.communityXpEarned + CommunityConstants.xpJoinCommunity,
        xp: user.xp + CommunityConstants.xpJoinCommunity,
        communityActivity: {
          ...user.communityActivity,
          communityId: DateTime.now(),
        },
      );

      ref.read(authProvider.notifier).updateUserWithOnboardingData(updatedUser);

      // 2. Persistir no Firestore
      await FirestoreService().updateUser(user.uid, {
        'joinedCommunities': FieldValue.arrayUnion([communityId]),
        'communityXpEarned':
            FieldValue.increment(CommunityConstants.xpJoinCommunity),
        'xp': FieldValue.increment(CommunityConstants.xpJoinCommunity),
        'communityActivity.$communityId': FieldValue.serverTimestamp(),
      });

      // 3. Analytics
      await AnalyticsIntegration.manager.trackEvent(
        CommunityConstants.eventCommunityJoined,
        parameters: {
          'user_id': user.uid,
          'community_id': communityId,
          'xp_earned': CommunityConstants.xpJoinCommunity,
        },
      );

      AppLogger.info('UserNotifier: Usuário entrou na comunidade com sucesso');
      return true;
    } catch (e) {
      AppLogger.error('UserNotifier: Erro ao entrar na comunidade', error: e);
      // Reverter mudanças otimistas
      await ref.read(authProvider.notifier).refreshUser();
      return false;
    }
  }

  /// Remover usuário de uma comunidade
  Future<bool> leaveCommunity(String communityId) async {
    final user = state;
    if (user == null) {
      AppLogger.warning(
          'UserNotifier: Tentativa de sair de comunidade sem usuário logado');
      return false;
    }

    try {
      AppLogger.info('UserNotifier: Usuário saindo da comunidade', data: {
        'userId': user.uid,
        'communityId': communityId,
      });

      // 1. Atualização otimista
      final updatedJoinedCommunities = List<String>.from(user.joinedCommunities)
        ..remove(communityId);
      final updatedOwnedCommunities = List<String>.from(user.ownedCommunities)
        ..remove(communityId);
      final updatedModeratedCommunities =
          List<String>.from(user.moderatedCommunities)..remove(communityId);

      final updatedUser = user.copyWith(
        joinedCommunities: updatedJoinedCommunities,
        ownedCommunities: updatedOwnedCommunities,
        moderatedCommunities: updatedModeratedCommunities,
      );

      ref.read(authProvider.notifier).updateUserWithOnboardingData(updatedUser);

      // 2. Persistir no Firestore
      await FirestoreService().updateUser(user.uid, {
        'joinedCommunities': FieldValue.arrayRemove([communityId]),
        'ownedCommunities': FieldValue.arrayRemove([communityId]),
        'moderatedCommunities': FieldValue.arrayRemove([communityId]),
      });

      // 3. Analytics
      await AnalyticsIntegration.manager.trackEvent(
        CommunityConstants.eventCommunityLeft,
        parameters: {
          'user_id': user.uid,
          'community_id': communityId,
        },
      );

      AppLogger.info('UserNotifier: Usuário saiu da comunidade com sucesso');
      return true;
    } catch (e) {
      AppLogger.error('UserNotifier: Erro ao sair da comunidade', error: e);
      // Reverter mudanças otimistas
      await ref.read(authProvider.notifier).refreshUser();
      return false;
    }
  }

  /// Conceder XP por atividade em comunidade
  Future<void> awardCommunityXP(int xp, String reason,
      {String? communityId}) async {
    final user = state;
    if (user == null) {
      AppLogger.warning(
          'UserNotifier: Tentativa de conceder XP sem usuário logado');
      return;
    }

    try {
      AppLogger.info('UserNotifier: Concedendo XP de comunidade', data: {
        'userId': user.uid,
        'xp': xp,
        'reason': reason,
        'communityId': communityId,
      });

      // 1. Atualização otimista
      final updatedUser = user.copyWith(
        communityXpEarned: user.communityXpEarned + xp,
        xp: user.xp + xp,
        communityActivity: communityId != null
            ? {
                ...user.communityActivity,
                communityId: DateTime.now(),
              }
            : user.communityActivity,
      );

      ref.read(authProvider.notifier).updateUserWithOnboardingData(updatedUser);

      // 2. Persistir no Firestore
      final updateData = {
        'communityXpEarned': FieldValue.increment(xp),
        'xp': FieldValue.increment(xp),
      };

      if (communityId != null) {
        updateData['communityActivity.$communityId'] =
            FieldValue.serverTimestamp();
      }

      await FirestoreService().updateUser(user.uid, updateData);

      // 3. Analytics
      await AnalyticsIntegration.manager.trackEvent(
        'community_xp_awarded',
        parameters: {
          'user_id': user.uid,
          'xp_amount': xp,
          'reason': reason,
          'community_id': communityId,
          'total_xp': user.xp + xp,
          'total_community_xp': user.communityXpEarned + xp,
        },
      );

      AppLogger.info('UserNotifier: XP de comunidade concedido com sucesso');
    } catch (e) {
      AppLogger.error('UserNotifier: Erro ao conceder XP de comunidade',
          error: e);
      // Reverter mudanças otimistas
      await ref.read(authProvider.notifier).refreshUser();
    }
  }

  /// Conceder coins por atividade em comunidade
  Future<void> awardCommunityCoins(int coins, String reason,
      {String? communityId}) async {
    final user = state;
    if (user == null) {
      AppLogger.warning(
          'UserNotifier: Tentativa de conceder coins sem usuário logado');
      return;
    }

    try {
      AppLogger.info('UserNotifier: Concedendo coins de comunidade', data: {
        'userId': user.uid,
        'coins': coins,
        'reason': reason,
        'communityId': communityId,
      });

      // 1. Atualização otimista
      final updatedUser = user.copyWith(
        communityCoinsEarned: user.communityCoinsEarned + coins,
        coins: user.coins + coins,
        communityActivity: communityId != null
            ? {
                ...user.communityActivity,
                communityId: DateTime.now(),
              }
            : user.communityActivity,
      );

      ref.read(authProvider.notifier).updateUserWithOnboardingData(updatedUser);

      // 2. Persistir no Firestore
      final updateData = {
        'communityCoinsEarned': FieldValue.increment(coins),
        'coins': FieldValue.increment(coins),
      };

      if (communityId != null) {
        updateData['communityActivity.$communityId'] =
            FieldValue.serverTimestamp();
      }

      await FirestoreService().updateUser(user.uid, updateData);

      // 3. Analytics
      await AnalyticsIntegration.manager.trackEvent(
        'community_coins_awarded',
        parameters: {
          'user_id': user.uid,
          'coins_amount': coins,
          'reason': reason,
          'community_id': communityId,
          'total_coins': user.coins + coins,
          'total_community_coins': user.communityCoinsEarned + coins,
        },
      );

      AppLogger.info(
          'UserNotifier: Coins de comunidade concedidas com sucesso');
    } catch (e) {
      AppLogger.error('UserNotifier: Erro ao conceder coins de comunidade',
          error: e);
      // Reverter mudanças otimistas
      await ref.read(authProvider.notifier).refreshUser();
    }
  }

  /// Incrementar contador de posts em comunidades
  Future<void> incrementCommunityPosts({String? communityId}) async {
    final user = state;
    if (user == null) {
      AppLogger.warning(
          'UserNotifier: Tentativa de incrementar posts sem usuário logado');
      return;
    }

    try {
      AppLogger.info('UserNotifier: Incrementando contador de posts', data: {
        'userId': user.uid,
        'communityId': communityId,
      });

      // 1. Atualização otimista
      final updatedUser = user.copyWith(
        communityPostsCount: user.communityPostsCount + 1,
        communityActivity: communityId != null
            ? {
                ...user.communityActivity,
                communityId: DateTime.now(),
              }
            : user.communityActivity,
      );

      ref.read(authProvider.notifier).updateUserWithOnboardingData(updatedUser);

      // 2. Persistir no Firestore
      final updateData = {
        'communityPostsCount': FieldValue.increment(1),
      };

      if (communityId != null) {
        updateData['communityActivity.$communityId'] =
            FieldValue.serverTimestamp();
      }

      await FirestoreService().updateUser(user.uid, updateData);

      // 3. Verificar se deve conceder recompensas por milestone
      await _checkPostMilestones(user.communityPostsCount + 1);

      AppLogger.info(
          'UserNotifier: Contador de posts incrementado com sucesso');
    } catch (e) {
      AppLogger.error('UserNotifier: Erro ao incrementar contador de posts',
          error: e);
      // Reverter mudanças otimistas
      await ref.read(authProvider.notifier).refreshUser();
    }
  }

  /// Atualizar atividade do usuário em uma comunidade
  Future<void> updateCommunityActivity(String communityId) async {
    final user = state;
    if (user == null) {
      AppLogger.warning(
          'UserNotifier: Tentativa de atualizar atividade sem usuário logado');
      return;
    }

    try {
      AppLogger.debug('UserNotifier: Atualizando atividade da comunidade',
          data: {
            'userId': user.uid,
            'communityId': communityId,
          });

      // 1. Atualização otimista
      final updatedUser = user.copyWith(
        communityActivity: {
          ...user.communityActivity,
          communityId: DateTime.now(),
        },
      );

      ref.read(authProvider.notifier).updateUserWithOnboardingData(updatedUser);

      // 2. Persistir no Firestore
      await FirestoreService().updateUser(user.uid, {
        'communityActivity.$communityId': FieldValue.serverTimestamp(),
      });

      AppLogger.debug(
          'UserNotifier: Atividade da comunidade atualizada com sucesso');
    } catch (e) {
      AppLogger.error('UserNotifier: Erro ao atualizar atividade da comunidade',
          error: e);
      // Em caso de erro, não reverter pois é uma atualização menor
    }
  }

  /// Conceder badge de comunidade
  Future<void> awardCommunityBadge(String badgeId, {int quantity = 1}) async {
    final user = state;
    if (user == null) {
      AppLogger.warning(
          'UserNotifier: Tentativa de conceder badge sem usuário logado');
      return;
    }

    try {
      AppLogger.info('UserNotifier: Concedendo badge de comunidade', data: {
        'userId': user.uid,
        'badgeId': badgeId,
        'quantity': quantity,
      });

      // 1. Atualização otimista
      final updatedBadges = Map<String, int>.from(user.communityBadges);
      updatedBadges[badgeId] = (updatedBadges[badgeId] ?? 0) + quantity;

      final updatedUser = user.copyWith(communityBadges: updatedBadges);
      ref.read(authProvider.notifier).updateUserWithOnboardingData(updatedUser);

      // 2. Persistir no Firestore
      await FirestoreService().updateUser(user.uid, {
        'communityBadges.$badgeId': FieldValue.increment(quantity),
      });

      // 3. Conceder XP do badge se aplicável
      final badgeConfig = CommunityConstants.communityBadges[badgeId];
      if (badgeConfig != null && badgeConfig['xpReward'] != null) {
        final xpReward = badgeConfig['xpReward'] as int;
        await awardCommunityXP(xpReward, 'Badge: ${badgeConfig['name']}');
      }

      // 4. Analytics
      await AnalyticsIntegration.manager.trackEvent(
        'community_badge_awarded',
        parameters: {
          'user_id': user.uid,
          'badge_id': badgeId,
          'badge_name': badgeConfig?['name'] ?? badgeId,
          'quantity': quantity,
          'total_badges':
              updatedBadges.values.fold(0, (sum, count) => sum + count),
        },
      );

      AppLogger.info('UserNotifier: Badge de comunidade concedido com sucesso');
    } catch (e) {
      AppLogger.error('UserNotifier: Erro ao conceder badge de comunidade',
          error: e);
      // Reverter mudanças otimistas
      await ref.read(authProvider.notifier).refreshUser();
    }
  }

  // ========== MÉTODOS AUXILIARES PRIVADOS ==========

  /// Verificar milestones de posts e conceder recompensas
  Future<void> _checkPostMilestones(int postCount) async {
    final milestones = [1, 10, 25, 50, 100, 250, 500];

    if (milestones.contains(postCount)) {
      String badgeId;
      int xpBonus = 0;
      int coinsBonus = 0;

      switch (postCount) {
        case 1:
          await awardCommunityXP(
              CommunityConstants.xpFirstPost, 'Primeiro post em comunidade');
          return;
        case 10:
          xpBonus = 50;
          coinsBonus = 25;
          break;
        case 25:
          xpBonus = 100;
          coinsBonus = 50;
          break;
        case 50:
          badgeId = 'conversation_starter';
          xpBonus = 150;
          coinsBonus = 75;
          break;
        case 100:
          badgeId = 'community_champion';
          xpBonus = 300;
          coinsBonus = 150;
          break;
        case 250:
          xpBonus = 500;
          coinsBonus = 250;
          break;
        case 500:
          xpBonus = 1000;
          coinsBonus = 500;
          break;
      }

      if (xpBonus > 0) {
        await awardCommunityXP(xpBonus, 'Milestone: $postCount posts');
      }
      if (coinsBonus > 0) {
        await awardCommunityCoins(coinsBonus, 'Milestone: $postCount posts');
      }
      // if (badgeId.isNotEmpty) {
      //   await awardCommunityBadge(badgeId);
      // }
    }
  }
}

/// Provider for [UserNotifier].
final userProvider = NotifierProvider<UserNotifier, UserModel?>(
  UserNotifier.new,
);

/// An enum to represent different user "modes" or statuses.
enum UserModeEnum { triste, alegre, aventureiro, calmo, misterioso }

/// Extension to provide display names and icons for [UserModeEnum] values.
extension UserModeExtension on UserModeEnum {
  String get displayName {
    switch (this) {
      case UserModeEnum.triste:
        return 'Triste';
      case UserModeEnum.alegre:
        return 'Alegre';
      case UserModeEnum.aventureiro:
        return 'Aventureiro';
      case UserModeEnum.calmo:
        return 'Calmo';
      case UserModeEnum.misterioso:
        return 'Misterioso';
    }
  }

  IconData get icon {
    switch (this) {
      case UserModeEnum.triste:
        return Icons.sentiment_dissatisfied;
      case UserModeEnum.alegre:
        return Icons.sentiment_satisfied_alt;
      case UserModeEnum.aventureiro:
        return Icons.hiking;
      case UserModeEnum.calmo:
        return Icons.self_improvement;
      case UserModeEnum.misterioso:
        return Icons.blur_on;
    }
  }
}

// Helper to convert UserModeEnum to UserModel's currentMood string
extension UserModeEnumToName on UserModeEnum {
  String get name {
    return toString().split('.').last;
  }
}
