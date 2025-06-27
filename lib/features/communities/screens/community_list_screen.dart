// CommunityListScreen - Lista das comunidades do usuario
// Arquivo criado automaticamente pelo script de estrutura
// Data: 2025-06-27 13:56:53
// Projeto: ClashUp - Sistema de Comunidades

// TODO: Implementar a classe/funcionalidade
// lib/features/communities/screens/community_list_screen.dart
// CommunityListScreen - Lista das comunidades do usuário
import 'package:clashup/core/utils/logger.dart';
import 'package:clashup/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityListScreen extends ConsumerStatefulWidget {
  const CommunityListScreen({super.key});

  @override
  ConsumerState<CommunityListScreen> createState() =>
      _CommunityListScreenState();
}

class _CommunityListScreenState extends ConsumerState<CommunityListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserCommunities();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserCommunities() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // TODO: Implementar carregamento real das comunidades via provider
      await Future.delayed(const Duration(seconds: 1)); // Simular carregamento

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      AppLogger.error('Erro ao carregar comunidades', error: e);
      setState(() {
        _isLoading = false;
        _error = 'Erro ao carregar suas comunidades';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          // Header personalizado
          _buildHeader(context, theme),

          // Tabs
          _buildTabBar(context, theme),

          // Conteúdo das tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMyCommunities(context),
                _buildDiscoverCommunities(context),
                _buildTrendingCommunities(context),
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: _buildCreateCommunityFab(context, theme),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Comunidades',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Conecte-se com pessoas que compartilham seus interesses',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showSearchBottomSheet(context),
                  icon: Icon(
                    Icons.search,
                    color: theme.colorScheme.primary,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: theme.colorScheme.onPrimary,
        unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.7),
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Minhas'),
          Tab(text: 'Descobrir'),
          Tab(text: 'Trending'),
        ],
      ),
    );
  }

  Widget _buildMyCommunities(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error != null) {
      return _buildErrorState(_error!);
    }

    // Simulando lista vazia por enquanto
    return _buildEmptyMyCommunitiesState();
  }

  Widget _buildDiscoverCommunities(BuildContext context) {
    return _buildPlaceholderContent(
      'Descobrir Comunidades',
      'Explore novas comunidades baseadas nos seus interesses',
      Icons.explore,
    );
  }

  Widget _buildTrendingCommunities(BuildContext context) {
    return _buildPlaceholderContent(
      'Comunidades em Alta',
      'Veja as comunidades mais populares do momento',
      Icons.trending_up,
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Carregando suas comunidades...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops!',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadUserCommunities,
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyMyCommunitiesState() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.groups,
                size: 60,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Nenhuma comunidade ainda',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Encontre pessoas com os mesmos interesses que você! '
              'Crie sua primeira comunidade ou junte-se a uma existente.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showCreateCommunityDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Criar Comunidade'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Expanded(
                //   child: OutlinedButton.icon(
                //     onPressed: () {
                //       _tabController.animateTo(1); // Ir para aba Descobrir
                //     },
                //     icon: const Icon(Icons.explore),
                //     label: const Text('Explorar'),
                //     style: OutlinedButton.styleFrom(
                //       padding: const EdgeInsets.symmetric(
                //         horizontal: 24,
                //         vertical: 12,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderContent(
      String title, String subtitle, IconData icon) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 50,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Text(
                'Em breve! Esta funcionalidade será implementada nas próximas versões.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateCommunityFab(BuildContext context, ThemeData theme) {
    return FloatingActionButton.extended(
      onPressed: () => _showCreateCommunityDialog(context),
      icon: const Icon(Icons.add),
      label: const Text('Criar'),
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
    );
  }

  void _showCreateCommunityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Criar Comunidade'),
        content: const Text(
          'A funcionalidade de criar comunidades será implementada em breve!\n\n'
          'Em breve você poderá:\n'
          '• Criar comunidades personalizadas\n'
          '• Definir regras e moderadores\n'
          '• Convidar amigos\n'
          '• Ganhar XP e badges especiais',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  void _showSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Handle indicator
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar comunidades...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Placeholder for search results
              Expanded(
                child: Center(
                  child: Text(
                    'Busca de comunidades será implementada em breve!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
