// CommunityProvider - Estado global das comunidades
// Arquivo criado automaticamente pelo script de estrutura
// Data: 2025-06-27 13:56:53
// Projeto: ClashUp - Sistema de Comunidades

// TODO: Implementar a classe/funcionalidade
// lib/features/communities/providers/community_provider.dart
// CommunityProvider - Estado global das comunidades
import 'package:clashup/core/utils/logger.dart';
import 'package:clashup/features/communities/models/community_model.dart';
import 'package:clashup/features/communities/services/community_service.dart';
import 'package:clashup/features/user/providers/user_provider.dart';
import 'package:clashup/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado das comunidades do usuário
class CommunityState {
  final List<CommunityModel> myCommunities;
  final List<CommunityModel> popularCommunities;
  final List<CommunityModel> recommendedCommunities;
  final List<CommunityModel> trendingCommunities;
  final bool isLoading;
  final String? error;
  final DateTime? lastUpdated;

  const CommunityState({
    this.myCommunities = const [],
    this.popularCommunities = const [],
    this.recommendedCommunities = const [],
    this.trendingCommunities = const [],
    this.isLoading = false,
    this.error,
    this.lastUpdated,
  });

  CommunityState copyWith({
    List<CommunityModel>? myCommunities,
    List<CommunityModel>? popularCommunities,
    List<CommunityModel>? recommendedCommunities,
    List<CommunityModel>? trendingCommunities,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return CommunityState(
      myCommunities: myCommunities ?? this.myCommunities,
      popularCommunities: popularCommunities ?? this.popularCommunities,
      recommendedCommunities:
          recommendedCommunities ?? this.recommendedCommunities,
      trendingCommunities: trendingCommunities ?? this.trendingCommunities,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// Notifier para gerenciar o estado das comunidades
class CommunityNotifier extends StateNotifier<CommunityState> {
  final CommunityService _communityService;
  final Ref _ref;

  CommunityNotifier(this._communityService, this._ref)
      : super(const CommunityState());

  /// Carregar todas as comunidades do usuário
  Future<void> loadUserCommunities({bool forceRefresh = false}) async {
    final user = _ref.read(authProvider).user;
    if (user == null) {
      AppLogger.warning(
          'CommunityProvider: Tentativa de carregar comunidades sem usuário logado');
      return;
    }

    // Verificar se precisa atualizar (cache de 5 minutos)
    if (!forceRefresh &&
        state.lastUpdated != null &&
        DateTime.now().difference(state.lastUpdated!).inMinutes < 5) {
      AppLogger.debug(
          'CommunityProvider: Usando cache das comunidades do usuário');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      AppLogger.info('CommunityProvider: Carregando comunidades do usuário',
          data: {
            'userId': user.uid,
            'forceRefresh': forceRefresh,
          });

      final communities = await _communityService.getUserCommunities(user.uid);

      state = state.copyWith(
        myCommunities: communities,
        isLoading: false,
        lastUpdated: DateTime.now(),
      );

      AppLogger.info('CommunityProvider: Comunidades do usuário carregadas',
          data: {
            'count': communities.length,
          });
    } catch (e) {
      AppLogger.error(
          'CommunityProvider: Erro ao carregar comunidades do usuário',
          error: e);
      state = state.copyWith(
        isLoading: false,
        error: 'Erro ao carregar suas comunidades',
      );
    }
  }

  /// Carregar comunidades populares
  Future<void> loadPopularCommunities({bool forceRefresh = false}) async {
    // Verificar se precisa atualizar (cache de 15 minutos)
    if (!forceRefresh &&
        state.popularCommunities.isNotEmpty &&
        state.lastUpdated != null &&
        DateTime.now().difference(state.lastUpdated!).inMinutes < 15) {
      AppLogger.debug(
          'CommunityProvider: Usando cache das comunidades populares');
      return;
    }

    try {
      AppLogger.info('CommunityProvider: Carregando comunidades populares');

      final communities = await _communityService.getPopularCommunities();

      state = state.copyWith(
        popularCommunities: communities,
        lastUpdated: DateTime.now(),
      );

      AppLogger.info('CommunityProvider: Comunidades populares carregadas',
          data: {
            'count': communities.length,
          });
    } catch (e) {
      AppLogger.error(
          'CommunityProvider: Erro ao carregar comunidades populares',
          error: e);
    }
  }

  /// Carregar comunidades por categoria
  Future<List<CommunityModel>> loadCommunitiesByCategory(
    CommunityCategory category, {
    int limit = 20,
  }) async {
    try {
      AppLogger.info('CommunityProvider: Carregando comunidades por categoria',
          data: {
            'category': category.name,
            'limit': limit,
          });

      final communities = await _communityService.getCommunitiesByCategory(
        category,
        limit: limit,
      );

      AppLogger.info('CommunityProvider: Comunidades por categoria carregadas',
          data: {
            'category': category.name,
            'count': communities.length,
          });

      return communities;
    } catch (e) {
      AppLogger.error(
          'CommunityProvider: Erro ao carregar comunidades por categoria',
          error: e);
      return [];
    }
  }

  /// Buscar comunidades por texto
  Future<List<CommunityModel>> searchCommunities(
    String query, {
    CommunityCategory? category,
    int limit = 20,
  }) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      AppLogger.info('CommunityProvider: Buscando comunidades', data: {
        'query': query,
        'category': category?.name,
        'limit': limit,
      });

      final communities = await _communityService.searchCommunities(
        query,
        limit: limit,
        category: category,
      );

      AppLogger.info('CommunityProvider: Busca de comunidades concluída',
          data: {
            'query': query,
            'results': communities.length,
          });

      return communities;
    } catch (e) {
      AppLogger.error('CommunityProvider: Erro ao buscar comunidades',
          error: e);
      return [];
    }
  }

  /// Entrar em uma comunidade
  Future<bool> joinCommunity(String communityId) async {
    final user = _ref.read(authProvider).user;
    if (user == null) {
      AppLogger.warning(
          'CommunityProvider: Tentativa de entrar em comunidade sem usuário logado');
      return false;
    }

    try {
      AppLogger.info('CommunityProvider: Entrando na comunidade', data: {
        'userId': user.uid,
        'communityId': communityId,
      });

      // Usar o serviço para entrar na comunidade
      final success =
          await _communityService.joinCommunity(communityId, user.uid);

      if (success) {
        // Atualizar o estado do usuário via UserProvider
        await _ref.read(userProvider.notifier).joinCommunity(communityId);

        // Recarregar comunidades do usuário
        await loadUserCommunities(forceRefresh: true);

        AppLogger.info(
            'CommunityProvider: Entrada na comunidade realizada com sucesso');
      }

      return success;
    } catch (e) {
      AppLogger.error('CommunityProvider: Erro ao entrar na comunidade',
          error: e);
      return false;
    }
  }

  /// Sair de uma comunidade
  Future<bool> leaveCommunity(String communityId) async {
    final user = _ref.read(authProvider).user;
    if (user == null) {
      AppLogger.warning(
          'CommunityProvider: Tentativa de sair de comunidade sem usuário logado');
      return false;
    }

    try {
      AppLogger.info('CommunityProvider: Saindo da comunidade', data: {
        'userId': user.uid,
        'communityId': communityId,
      });

      // Usar o serviço para sair da comunidade
      final success =
          await _communityService.leaveCommunity(communityId, user.uid);

      if (success) {
        // Atualizar o estado do usuário via UserProvider
        await _ref.read(userProvider.notifier).leaveCommunity(communityId);

        // Recarregar comunidades do usuário
        await loadUserCommunities(forceRefresh: true);

        AppLogger.info(
            'CommunityProvider: Saída da comunidade realizada com sucesso');
      }

      return success;
    } catch (e) {
      AppLogger.error('CommunityProvider: Erro ao sair da comunidade',
          error: e);
      return false;
    }
  }

  /// Criar nova comunidade
  Future<CommunityModel?> createCommunity({
    required String name,
    required String description,
    required CommunityCategory category,
    CommunityPrivacyType privacyType = CommunityPrivacyType.public,
    List<String> tags = const [],
    String? imageUrl,
    String? rules,
    String? welcomeMessage,
  }) async {
    final user = _ref.read(authProvider).user;
    if (user == null) {
      AppLogger.warning(
          'CommunityProvider: Tentativa de criar comunidade sem usuário logado');
      return null;
    }

    try {
      AppLogger.info('CommunityProvider: Criando nova comunidade', data: {
        'userId': user.uid,
        'name': name,
        'category': category.name,
      });

      final community = await _communityService.createCommunity(
        name: name,
        description: description,
        creatorId: user.uid,
        category: category,
        privacyType: privacyType,
        tags: tags,
        imageUrl: imageUrl,
        rules: rules,
        welcomeMessage: welcomeMessage,
      );

      // Atualizar o estado do usuário via UserProvider
      await _ref.read(userProvider.notifier).joinCommunity(community.id);

      // Recarregar comunidades do usuário
      await loadUserCommunities(forceRefresh: true);

      AppLogger.info('CommunityProvider: Comunidade criada com sucesso', data: {
        'communityId': community.id,
        'name': community.name,
      });

      return community;
    } catch (e) {
      AppLogger.error('CommunityProvider: Erro ao criar comunidade', error: e);
      return null;
    }
  }

  /// Verificar se usuário é membro de uma comunidade
  bool isUserMember(String communityId) {
    final user = _ref.read(authProvider).user;
    if (user == null) return false;

    return user.isMemberOf(communityId);
  }

  /// Obter comunidade por ID do cache local
  CommunityModel? getCommunityFromCache(String communityId) {
    // Buscar nas comunidades do usuário primeiro
    for (final community in state.myCommunities) {
      if (community.id == communityId) {
        return community;
      }
    }

    // Buscar nas comunidades populares
    for (final community in state.popularCommunities) {
      if (community.id == communityId) {
        return community;
      }
    }

    // Buscar nas comunidades recomendadas
    for (final community in state.recommendedCommunities) {
      if (community.id == communityId) {
        return community;
      }
    }

    return null;
  }

  /// Limpar cache e recarregar todas as comunidades
  Future<void> refreshAll() async {
    AppLogger.info('CommunityProvider: Refreshing all communities');

    state = state.copyWith(
      myCommunities: [],
      popularCommunities: [],
      recommendedCommunities: [],
      trendingCommunities: [],
      lastUpdated: null,
    );

    await Future.wait([
      loadUserCommunities(forceRefresh: true),
      loadPopularCommunities(forceRefresh: true),
    ]);
  }

  /// Limpar estado de erro
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider para o serviço de comunidades
final communityServiceProvider = Provider<CommunityService>((ref) {
  return CommunityService();
});

/// Provider principal para o estado das comunidades
final communityProvider =
    StateNotifierProvider<CommunityNotifier, CommunityState>((ref) {
  return CommunityNotifier(
    ref.read(communityServiceProvider),
    ref,
  );
});

/// Provider para comunidades do usuário (apenas)
final userCommunitiesProvider = Provider<List<CommunityModel>>((ref) {
  return ref.watch(communityProvider).myCommunities;
});

/// Provider para comunidades populares (apenas)
final popularCommunitiesProvider = Provider<List<CommunityModel>>((ref) {
  return ref.watch(communityProvider).popularCommunities;
});

/// Provider para verificar se está carregando
final isLoadingCommunitiesProvider = Provider<bool>((ref) {
  return ref.watch(communityProvider).isLoading;
});

/// Provider para erro atual
final communityErrorProvider = Provider<String?>((ref) {
  return ref.watch(communityProvider).error;
});

/// Provider para verificar se usuário é membro de uma comunidade específica
final isUserMemberProvider = Provider.family<bool, String>((ref, communityId) {
  final user = ref.watch(authProvider).user;
  if (user == null) return false;

  return user.isMemberOf(communityId);
});

/// Provider para obter comunidade específica do cache
final communityByIdProvider =
    Provider.family<CommunityModel?, String>((ref, communityId) {
  return ref
      .read(communityProvider.notifier)
      .getCommunityFromCache(communityId);
});
