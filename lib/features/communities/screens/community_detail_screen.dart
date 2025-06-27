// CommunityDetailScreen - Detalhes de uma comunidade especifica
// Arquivo criado automaticamente pelo script de estrutura
// Data: 2025-06-27 13:56:53
// Projeto: ClashUp - Sistema de Comunidades

// TODO: Implementar a classe/funcionalidade
// lib/features/communities/screens/community_detail_screen.dart
// CommunityDetailScreen - Detalhes de uma comunidade específica
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clashup/core/utils/logger.dart';
import 'package:clashup/features/communities/constants/community_constants.dart';
import 'package:clashup/features/communities/models/community_model.dart';
import 'package:clashup/features/communities/providers/community_provider.dart';
import 'package:clashup/features/communities/services/community_service.dart';
import 'package:clashup/features/communities/widgets/community_stats_widget.dart';
import 'package:clashup/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommunityDetailScreen extends ConsumerStatefulWidget {
  final String communityId;
  final CommunityModel? initialCommunity; // Para otimização

  const CommunityDetailScreen({
    super.key,
    required this.communityId,
    this.initialCommunity,
  });

  @override
  ConsumerState<CommunityDetailScreen> createState() =>
      _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends ConsumerState<CommunityDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CommunityModel? _community;
  bool _isLoading = false;
  String? _error;
  bool _isJoining = false;
  bool _isLeaving = false;

  final _communityService = CommunityService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _community = widget.initialCommunity;

    if (_community == null) {
      _loadCommunityDetails();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCommunityDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final community =
          await _communityService.getCommunity(widget.communityId);

      if (mounted) {
        setState(() {
          _community = community;
          _isLoading = false;
        });
      }
    } catch (e) {
      AppLogger.error('Erro ao carregar detalhes da comunidade', error: e);
      if (mounted) {
        setState(() {
          _error = 'Erro ao carregar comunidade';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _joinCommunity() async {
    if (_isJoining || _community == null) return;

    setState(() {
      _isJoining = true;
    });

    try {
      final success = await ref
          .read(communityProvider.notifier)
          .joinCommunity(_community!.id);

      if (success && mounted) {
        setState(() {
          _community = _community!.copyWith(
            membersCount: _community!.membersCount + 1,
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Você entrou na comunidade ${_community!.name}!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao entrar na comunidade'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isJoining = false;
        });
      }
    }
  }

  Future<void> _leaveCommunity() async {
    if (_isLeaving || _community == null) return;

    // Confirmar saída
    final shouldLeave = await _showLeaveConfirmation();
    if (!shouldLeave) return;

    setState(() {
      _isLeaving = true;
    });

    try {
      final success = await ref
          .read(communityProvider.notifier)
          .leaveCommunity(_community!.id);

      if (success && mounted) {
        setState(() {
          _community = _community!.copyWith(
            membersCount: _community!.membersCount - 1,
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Você saiu da comunidade ${_community!.name}'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao sair da comunidade'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLeaving = false;
        });
      }
    }
  }

  Future<bool> _showLeaveConfirmation() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sair da Comunidade'),
            content: Text(
                'Tem certeza que deseja sair da comunidade "${_community?.name}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Sair'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Carregando...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: _buildErrorState(),
      );
    }

    if (_community == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Comunidade não encontrada')),
        body: const Center(
          child: Text('Esta comunidade não existe ou foi removida.'),
        ),
      );
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(),
        ],
        body: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildPostsTab(),
                  _buildMembersTab(),
                  _buildAboutTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildJoinLeaveButton(),
    );
  }

  Widget _buildSliverAppBar() {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Banner da comunidade
            Container(
              width: double.infinity,
              height: double.infinity,
              child: _community!.hasBanner
                  ? CachedNetworkImage(
                      imageUrl: _community!.bannerUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _buildBannerPlaceholder(),
                      errorWidget: (context, url, error) =>
                          _buildBannerPlaceholder(),
                    )
                  : _buildBannerPlaceholder(),
            ),

            // Overlay gradient
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),

            // Informações da comunidade
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Imagem da comunidade
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _community!.hasImage
                              ? CachedNetworkImage(
                                  imageUrl: _community!.imageUrl!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      _buildImagePlaceholder(),
                                  errorWidget: (context, url, error) =>
                                      _buildImagePlaceholder(),
                                )
                              : _buildImagePlaceholder(),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Nome e categoria
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _community!.name,
                                    style:
                                        theme.textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (_community!.isVerified) ...[
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.verified,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                ],
                                if (_community!.isPremium) ...[
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  _community!.category.emoji,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _community!.category.displayName,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  _getPrivacyIcon(),
                                  color: Colors.white70,
                                  size: 16,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Estatísticas rápidas
                  Row(
                    children: [
                      _buildQuickStat('${_community!.membersCount}', 'membros'),
                      const SizedBox(width: 16),
                      _buildQuickStat('${_community!.postsCount}', 'posts'),
                      const SizedBox(width: 16),
                      _buildQuickStat(
                          'Nv. ${CommunityConstants.calculateCommunityLevel(_community!.membersCount)}',
                          'nível'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Visão Geral'),
          Tab(text: 'Posts'),
          Tab(text: 'Membros'),
          Tab(text: 'Sobre'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Descrição
          if (_community!.description.isNotEmpty) ...[
            Text(
              'Descrição',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _community!.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
          ],

          // Estatísticas
          Text(
            'Estatísticas',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          CommunityStatsWidget(community: _community!),

          const SizedBox(height: 24),

          // Tags
          if (_community!.tags.isNotEmpty) ...[
            Text(
              'Tags',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _community!.tags
                  .map((tag) => Chip(
                        label: Text('#$tag'),
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceVariant,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Informações adicionais
          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    return const Center(
      child: Text('Posts da comunidade em breve!'),
    );
  }

  Widget _buildMembersTab() {
    return const Center(
      child: Text('Lista de membros em breve!'),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Regras
          if (_community!.hasRules) ...[
            Text(
              'Regras da Comunidade',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _community!.rules!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
          ],

          // Mensagem de boas-vindas
          if (_community!.hasWelcomeMessage) ...[
            Text(
              'Mensagem de Boas-vindas',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: Text(
                _community!.welcomeMessage!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Informações do criador
          _buildCreatorInfo(),
        ],
      ),
    );
  }

  Widget _buildJoinLeaveButton() {
    final user = ref.watch(authProvider).user;
    if (user == null) return const SizedBox.shrink();

    final isUserMember = user.isMemberOf(_community!.id);
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: isUserMember
              ? ElevatedButton.icon(
                  onPressed: _isLeaving ? null : _leaveCommunity,
                  icon: _isLeaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.exit_to_app),
                  label: Text(_isLeaving ? 'Saindo...' : 'Sair da Comunidade'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: _isJoining ? null : _joinCommunity,
                  icon: _isJoining
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add),
                  label:
                      Text(_isJoining ? 'Entrando...' : 'Entrar na Comunidade'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                ),
        ),
      ),
    );
  }

  // Widgets auxiliares
  Widget _buildBannerPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.secondary.withOpacity(0.3),
          ],
        ),
      ),
      child: Center(
        child: Text(
          _community?.category.emoji ?? '🏘️',
          style: const TextStyle(fontSize: 80),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          _community?.category.emoji ?? '🏘️',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildQuickStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informações',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
              'Criada', timeago.format(_community!.createdAt, locale: 'pt_BR')),
          _buildInfoRow('Privacidade', _getPrivacyText()),
          _buildInfoRow('Nível',
              'Nível ${CommunityConstants.calculateCommunityLevel(_community!.membersCount)}'),
          _buildInfoRow(
              'Posts permitidos', _community!.allowPosts ? 'Sim' : 'Não'),
          _buildInfoRow('Comentários permitidos',
              _community!.allowComments ? 'Sim' : 'Não'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatorInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Criador da Comunidade',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'ID: ${_community!.creatorId}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
          // TODO: Buscar informações completas do criador
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Erro desconhecido',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadCommunityDetails,
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPrivacyIcon() {
    switch (_community!.privacyType) {
      case CommunityPrivacyType.public:
        return Icons.public;
      case CommunityPrivacyType.private:
        return Icons.lock;
      case CommunityPrivacyType.restricted:
        return Icons.lock_open;
    }
  }

  String _getPrivacyText() {
    switch (_community!.privacyType) {
      case CommunityPrivacyType.public:
        return 'Pública';
      case CommunityPrivacyType.private:
        return 'Privada';
      case CommunityPrivacyType.restricted:
        return 'Restrita';
    }
  }
}
