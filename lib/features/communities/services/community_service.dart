// CommunityService - Operacoes CRUD no Firestore
// Arquivo criado automaticamente pelo script de estrutura
// Data: 2025-06-27 13:56:53
// Projeto: ClashUp - Sistema de Comunidades

// TODO: Implementar a classe/funcionalidade
// lib/features/communities/services/community_service.dart
// CommunityService - Operações CRUD no Firestore e integração com gamificação
import 'package:clashup/core/utils/logger.dart';
import 'package:clashup/features/communities/models/community_model.dart';
import 'package:clashup/services/analytics/analytics_integration.dart';
import 'package:clashup/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityService {
  static final _db = FirebaseFirestore.instance;
  static final _firestoreService = FirestoreService();

  // ========== OPERAÇÕES DE COMUNIDADE ==========

  /// Criar nova comunidade
  Future<CommunityModel> createCommunity({
    required String name,
    required String description,
    required String creatorId,
    required CommunityCategory category,
    CommunityPrivacyType privacyType = CommunityPrivacyType.public,
    List<String> tags = const [],
    String? imageUrl,
    String? rules,
    String? welcomeMessage,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      AppLogger.info('🏗️ Criando nova comunidade', data: {
        'name': name,
        'creatorId': creatorId,
        'category': category.name,
        'privacyType': privacyType.name,
      });

      // Criar modelo da comunidade
      final community = CommunityModel.create(
        name: name,
        description: description,
        creatorId: creatorId,
        category: category,
        privacyType: privacyType,
        tags: tags,
        imageUrl: imageUrl,
        rules: rules,
        welcomeMessage: welcomeMessage,
      );

      // Salvar no Firestore
      final docRef =
          await _db.collection('communities').add(community.toJson());
      final communityWithId = community.copyWith(id: docRef.id);

      // Atualizar com ID correto
      await docRef.update({'id': docRef.id});

      // Adicionar criador como membro automaticamente
      await _addUserToCommunity(communityWithId.id, creatorId, isCreator: true);

      // Atualizar estatísticas do usuário
      await _updateUserCommunityStats(creatorId, {
        'ownedCommunities': FieldValue.arrayUnion([communityWithId.id]),
        'joinedCommunities': FieldValue.arrayUnion([communityWithId.id]),
        'moderatedCommunities': FieldValue.arrayUnion([communityWithId.id]),
        'communityXpEarned':
            FieldValue.increment(100), // XP por criar comunidade
        'communityCoinsEarned':
            FieldValue.increment(50), // Coins por criar comunidade
        'xp': FieldValue.increment(100),
        'coins': FieldValue.increment(50),
      });

      stopwatch.stop();

      // Analytics
      await AnalyticsIntegration.manager.trackEvent(
        'community_created',
        parameters: {
          'community_id': communityWithId.id,
          'community_name': name,
          'category': category.name,
          'privacy_type': privacyType.name,
          'creator_id': creatorId,
          'duration_ms': stopwatch.elapsedMilliseconds,
        },
      );

      AppLogger.info('✅ Comunidade criada com sucesso', data: {
        'communityId': communityWithId.id,
        'name': name,
        'duration': '${stopwatch.elapsedMilliseconds}ms',
      });

      return communityWithId;
    } catch (e) {
      stopwatch.stop();
      AppLogger.error('❌ Erro ao criar comunidade', error: e, data: {
        'name': name,
        'creatorId': creatorId,
        'duration': '${stopwatch.elapsedMilliseconds}ms',
      });
      rethrow;
    }
  }

  /// Buscar comunidade por ID
  Future<CommunityModel?> getCommunity(String communityId) async {
    try {
      AppLogger.debug('📥 Buscando comunidade',
          data: {'communityId': communityId});

      final doc = await _db.collection('communities').doc(communityId).get();

      if (doc.exists) {
        final community = CommunityModel.fromJson(doc.data()!);
        AppLogger.debug('✅ Comunidade encontrada', data: {
          'communityId': communityId,
          'name': community.name,
          'membersCount': community.membersCount,
        });
        return community;
      }

      AppLogger.debug('⚠️ Comunidade não encontrada',
          data: {'communityId': communityId});
      return null;
    } catch (e) {
      AppLogger.error('❌ Erro ao buscar comunidade', error: e, data: {
        'communityId': communityId,
      });
      return null;
    }
  }

  /// Buscar comunidades do usuário
  Future<List<CommunityModel>> getUserCommunities(String userId) async {
    try {
      AppLogger.debug('📥 Buscando comunidades do usuário',
          data: {'userId': userId});

      final snapshot = await _db
          .collection('communities')
          .where('membersIds', arrayContains: userId)
          .where('isActive', isEqualTo: true)
          .orderBy('updatedAt', descending: true)
          .get();

      final communities = snapshot.docs
          .map((doc) => CommunityModel.fromJson(doc.data()))
          .toList();

      AppLogger.debug('✅ Comunidades encontradas', data: {
        'userId': userId,
        'count': communities.length,
      });

      return communities;
    } catch (e) {
      AppLogger.error('❌ Erro ao buscar comunidades do usuário',
          error: e,
          data: {
            'userId': userId,
          });
      return [];
    }
  }

  /// Buscar comunidades por categoria
  Future<List<CommunityModel>> getCommunitiesByCategory(
    CommunityCategory category, {
    int limit = 20,
    DocumentSnapshot? lastDoc,
  }) async {
    try {
      AppLogger.debug('📥 Buscando comunidades por categoria', data: {
        'category': category.name,
        'limit': limit,
      });

      Query query = _db
          .collection('communities')
          .where('category', isEqualTo: category.name)
          .where('isActive', isEqualTo: true)
          .where('privacyType', isEqualTo: CommunityPrivacyType.public.name)
          .orderBy('membersCount', descending: true)
          .limit(limit);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final snapshot = await query.get();
      final communities = snapshot.docs
          .map((doc) =>
              CommunityModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      AppLogger.debug('✅ Comunidades por categoria encontradas', data: {
        'category': category.name,
        'count': communities.length,
      });

      return communities;
    } catch (e) {
      AppLogger.error('❌ Erro ao buscar comunidades por categoria',
          error: e,
          data: {
            'category': category.name,
          });
      return [];
    }
  }

  /// Buscar comunidades populares
  Future<List<CommunityModel>> getPopularCommunities({int limit = 10}) async {
    try {
      AppLogger.debug('📥 Buscando comunidades populares',
          data: {'limit': limit});

      final snapshot = await _db
          .collection('communities')
          .where('isActive', isEqualTo: true)
          .where('privacyType', isEqualTo: CommunityPrivacyType.public.name)
          .orderBy('membersCount', descending: true)
          .limit(limit)
          .get();

      final communities = snapshot.docs
          .map((doc) => CommunityModel.fromJson(doc.data()))
          .toList();

      AppLogger.debug('✅ Comunidades populares encontradas', data: {
        'count': communities.length,
      });

      return communities;
    } catch (e) {
      AppLogger.error('❌ Erro ao buscar comunidades populares', error: e);
      return [];
    }
  }

  /// Buscar comunidades por texto
  Future<List<CommunityModel>> searchCommunities(
    String query, {
    int limit = 20,
    CommunityCategory? category,
  }) async {
    try {
      AppLogger.debug('🔍 Buscando comunidades por texto', data: {
        'query': query,
        'limit': limit,
        'category': category?.name,
      });

      // Busca simples por nome (Firebase não suporta full-text search nativamente)
      Query firestoreQuery = _db
          .collection('communities')
          .where('isActive', isEqualTo: true)
          .where('privacyType', isEqualTo: CommunityPrivacyType.public.name)
          .orderBy('membersCount', descending: true)
          .limit(limit);

      if (category != null) {
        firestoreQuery =
            firestoreQuery.where('category', isEqualTo: category.name);
      }

      final snapshot = await firestoreQuery.get();
      final allCommunities = snapshot.docs
          .map((doc) =>
              CommunityModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      // Filtrar por nome e descrição localmente
      final filteredCommunities = allCommunities.where((community) {
        final searchLower = query.toLowerCase();
        return community.name.toLowerCase().contains(searchLower) ||
            community.description.toLowerCase().contains(searchLower) ||
            community.tags
                .any((tag) => tag.toLowerCase().contains(searchLower));
      }).toList();

      AppLogger.debug('✅ Busca de comunidades concluída', data: {
        'query': query,
        'totalFound': allCommunities.length,
        'filteredCount': filteredCommunities.length,
      });

      return filteredCommunities;
    } catch (e) {
      AppLogger.error('❌ Erro ao buscar comunidades', error: e, data: {
        'query': query,
      });
      return [];
    }
  }

  // ========== OPERAÇÕES DE MEMBROS ==========

  /// Usuário entrar em comunidade
  Future<bool> joinCommunity(String communityId, String userId) async {
    final stopwatch = Stopwatch()..start();

    try {
      AppLogger.info('👋 Usuário entrando na comunidade', data: {
        'communityId': communityId,
        'userId': userId,
      });

      // Verificar se comunidade existe e está ativa
      final community = await getCommunity(communityId);
      if (community == null || !community.isActive) {
        AppLogger.warning('⚠️ Comunidade não encontrada ou inativa', data: {
          'communityId': communityId,
        });
        return false;
      }

      // Verificar se usuário já é membro
      final memberDoc = await _db
          .collection('communities')
          .doc(communityId)
          .collection('members')
          .doc(userId)
          .get();

      if (memberDoc.exists) {
        AppLogger.info('ℹ️ Usuário já é membro da comunidade', data: {
          'communityId': communityId,
          'userId': userId,
        });
        return false;
      }

      // Adicionar como membro
      await _addUserToCommunity(communityId, userId);

      // Atualizar estatísticas da comunidade
      await _db.collection('communities').doc(communityId).update({
        'membersCount': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Atualizar estatísticas do usuário
      await _updateUserCommunityStats(userId, {
        'joinedCommunities': FieldValue.arrayUnion([communityId]),
        'communityXpEarned':
            FieldValue.increment(25), // XP por entrar em comunidade
        'xp': FieldValue.increment(25),
        'communityActivity.$communityId': FieldValue.serverTimestamp(),
      });

      stopwatch.stop();

      // Analytics
      await AnalyticsIntegration.manager.trackEvent(
        'community_joined',
        parameters: {
          'community_id': communityId,
          'user_id': userId,
          'community_name': community.name,
          'community_members_count': community.membersCount + 1,
          'duration_ms': stopwatch.elapsedMilliseconds,
        },
      );

      AppLogger.info('✅ Usuário entrou na comunidade com sucesso', data: {
        'communityId': communityId,
        'userId': userId,
        'duration': '${stopwatch.elapsedMilliseconds}ms',
      });

      return true;
    } catch (e) {
      stopwatch.stop();
      AppLogger.error('❌ Erro ao usuário entrar na comunidade',
          error: e,
          data: {
            'communityId': communityId,
            'userId': userId,
            'duration': '${stopwatch.elapsedMilliseconds}ms',
          });
      return false;
    }
  }

  /// Usuário sair da comunidade
  Future<bool> leaveCommunity(String communityId, String userId) async {
    final stopwatch = Stopwatch()..start();

    try {
      AppLogger.info('👋 Usuário saindo da comunidade', data: {
        'communityId': communityId,
        'userId': userId,
      });

      // Verificar se comunidade existe
      final community = await getCommunity(communityId);
      if (community == null) {
        AppLogger.warning('⚠️ Comunidade não encontrada', data: {
          'communityId': communityId,
        });
        return false;
      }

      // Não permitir que o criador saia da própria comunidade
      if (community.isCreator(userId)) {
        AppLogger.warning('⚠️ Criador não pode sair da própria comunidade',
            data: {
              'communityId': communityId,
              'userId': userId,
            });
        return false;
      }

      // Remover da coleção de membros
      await _db
          .collection('communities')
          .doc(communityId)
          .collection('members')
          .doc(userId)
          .delete();

      // Atualizar estatísticas da comunidade
      await _db.collection('communities').doc(communityId).update({
        'membersCount': FieldValue.increment(-1),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Atualizar estatísticas do usuário
      await _updateUserCommunityStats(userId, {
        'joinedCommunities': FieldValue.arrayRemove([communityId]),
        'moderatedCommunities': FieldValue.arrayRemove([communityId]),
      });

      stopwatch.stop();

      // Analytics
      await AnalyticsIntegration.manager.trackEvent(
        'community_left',
        parameters: {
          'community_id': communityId,
          'user_id': userId,
          'community_name': community.name,
          'duration_ms': stopwatch.elapsedMilliseconds,
        },
      );

      AppLogger.info('✅ Usuário saiu da comunidade com sucesso', data: {
        'communityId': communityId,
        'userId': userId,
        'duration': '${stopwatch.elapsedMilliseconds}ms',
      });

      return true;
    } catch (e) {
      stopwatch.stop();
      AppLogger.error('❌ Erro ao usuário sair da comunidade', error: e, data: {
        'communityId': communityId,
        'userId': userId,
        'duration': '${stopwatch.elapsedMilliseconds}ms',
      });
      return false;
    }
  }

  // ========== MÉTODOS AUXILIARES PRIVADOS ==========

  /// Adicionar usuário à comunidade (método privado)
  Future<void> _addUserToCommunity(
    String communityId,
    String userId, {
    bool isCreator = false,
    bool isModerator = false,
  }) async {
    final memberData = {
      'userId': userId,
      'communityId': communityId,
      'joinedAt': FieldValue.serverTimestamp(),
      'isCreator': isCreator,
      'isModerator': isModerator || isCreator,
      'isActive': true,
    };

    await _db
        .collection('communities')
        .doc(communityId)
        .collection('members')
        .doc(userId)
        .set(memberData);
  }

  /// Atualizar estatísticas do usuário relacionadas a comunidades
  Future<void> _updateUserCommunityStats(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    try {
      await _firestoreService.updateUser(userId, updates);
      AppLogger.debug('✅ Estatísticas do usuário atualizadas', data: {
        'userId': userId,
        'fields': updates.keys.toList(),
      });
    } catch (e) {
      AppLogger.error('❌ Erro ao atualizar estatísticas do usuário',
          error: e,
          data: {
            'userId': userId,
            'updates': updates.keys.toList(),
          });
      rethrow;
    }
  }

  /// Verificar se usuário é membro da comunidade
  Future<bool> isUserMember(String communityId, String userId) async {
    try {
      final memberDoc = await _db
          .collection('communities')
          .doc(communityId)
          .collection('members')
          .doc(userId)
          .get();

      return memberDoc.exists;
    } catch (e) {
      AppLogger.error('❌ Erro ao verificar se usuário é membro',
          error: e,
          data: {
            'communityId': communityId,
            'userId': userId,
          });
      return false;
    }
  }

  /// Atualizar última atividade do usuário na comunidade
  Future<void> updateUserActivity(String communityId, String userId) async {
    try {
      // Atualizar atividade do usuário
      await _updateUserCommunityStats(userId, {
        'communityActivity.$communityId': FieldValue.serverTimestamp(),
      });

      AppLogger.debug('✅ Atividade do usuário atualizada', data: {
        'communityId': communityId,
        'userId': userId,
      });
    } catch (e) {
      AppLogger.error('❌ Erro ao atualizar atividade do usuário',
          error: e,
          data: {
            'communityId': communityId,
            'userId': userId,
          });
    }
  }
}
