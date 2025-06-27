// CommunitySearchScreen - Busca de comunidades
// Arquivo criado automaticamente pelo script de estrutura
// Data: 2025-06-27 13:56:54
// Projeto: ClashUp - Sistema de Comunidades

// TODO: Implementar a classe/funcionalidade
// lib/features/communities/screens/community_search_screen.dart
// CommunitySearchScreen - Busca avançada de comunidades
import 'package:clashup/core/utils/logger.dart';
import 'package:clashup/features/communities/models/community_model.dart';
import 'package:clashup/features/communities/providers/community_provider.dart';
import 'package:clashup/features/communities/widgets/community_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunitySearchScreen extends ConsumerStatefulWidget {
  final String? initialQuery;
  final CommunityCategory? initialCategory;

  const CommunitySearchScreen({
    super.key,
    this.initialQuery,
    this.initialCategory,
  });

  @override
  ConsumerState<CommunitySearchScreen> createState() =>
      _CommunitySearchScreenState();
}

class _CommunitySearchScreenState extends ConsumerState<CommunitySearchScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late TabController _tabController;

  List<CommunityModel> _searchResults = [];
  List<CommunityModel> _categoryResults = [];
  List<CommunityModel> _popularResults = [];

  bool _isSearching = false;
  bool _isLoadingCategory = false;
  bool _isLoadingPopular = false;

  String _currentQuery = '';
  CommunityCategory? _selectedCategory;

  final Map<CommunityCategory, List<CommunityModel>> _categoryCache = {};

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _tabController = TabController(length: 3, vsync: this);
    _selectedCategory = widget.initialCategory;
    _currentQuery = widget.initialQuery ?? '';

    // Carregar dados iniciais
    _loadPopularCommunities();
    if (_selectedCategory != null) {
      _loadCommunityByCategory(_selectedCategory!);
    }
    if (_currentQuery.isNotEmpty) {
      _performSearch(_currentQuery);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _currentQuery = '';
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _currentQuery = query.trim();
    });

    try {
      AppLogger.info('Buscando comunidades', data: {'query': query});

      final results =
          await ref.read(communityProvider.notifier).searchCommunities(
                query.trim(),
                category: _selectedCategory,
              );

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });

        AppLogger.info('Busca concluída', data: {
          'query': query,
          'results': results.length,
        });
      }
    } catch (e) {
      AppLogger.error('Erro na busca de comunidades', error: e);
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao buscar comunidades'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadCommunityByCategory(CommunityCategory category) async {
    // Verificar cache primeiro
    if (_categoryCache.containsKey(category)) {
      setState(() {
        _categoryResults = _categoryCache[category]!;
      });
      return;
    }

    setState(() {
      _isLoadingCategory = true;
    });

    try {
      final results =
          await ref.read(communityProvider.notifier).loadCommunitiesByCategory(
                category,
                limit: 50,
              );

      if (mounted) {
        setState(() {
          _categoryResults = results;
          _isLoadingCategory = false;
        });

        // Adicionar ao cache
        _categoryCache[category] = results;
      }
    } catch (e) {
      AppLogger.error('Erro ao carregar comunidades por categoria', error: e);
      if (mounted) {
        setState(() {
          _isLoadingCategory = false;
        });
      }
    }
  }

  Future<void> _loadPopularCommunities() async {
    setState(() {
      _isLoadingPopular = true;
    });

    try {
      await ref
          .read(communityProvider.notifier)
          .loadPopularCommunities(forceRefresh: false);
      final popular = ref.read(popularCommunitiesProvider);

      if (mounted) {
        setState(() {
          _popularResults = popular;
          _isLoadingPopular = false;
        });
      }
    } catch (e) {
      AppLogger.error('Erro ao carregar comunidades populares', error: e);
      if (mounted) {
        setState(() {
          _isLoadingPopular = false;
        });
      }
    }
  }

  void _onCategorySelected(CommunityCategory? category) {
    setState(() {
      _selectedCategory = category;
    });

    if (category != null) {
      _loadCommunityByCategory(category);
      _tabController.animateTo(1); // Ir para aba de categoria
    }

    // Re-executar busca se houver query
    if (_currentQuery.isNotEmpty) {
      _performSearch(_currentQuery);
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = null;
      _currentQuery = '';
      _searchController.clear();
      _searchResults = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Comunidades'),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // Barra de busca
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar comunidades...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _performSearch('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor:
                        theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  ),
                  onChanged: (value) {
                    // Debounce para evitar muitas requisições
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (value == _searchController.text) {
                        _performSearch(value);
                      }
                    });
                  },
                  onSubmitted: _performSearch,
                ),
              ),

              // Filtro de categoria
              _buildCategoryFilter(),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Tabs
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search),
                    const SizedBox(width: 4),
                    const Text('Busca'),
                    if (_isSearching) ...[
                      const SizedBox(width: 4),
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ],
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.category),
                    const SizedBox(width: 4),
                    const Text('Categoria'),
                    if (_isLoadingCategory) ...[
                      const SizedBox(width: 4),
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ],
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.trending_up),
                    const SizedBox(width: 4),
                    const Text('Popular'),
                    if (_isLoadingPopular) ...[
                      const SizedBox(width: 4),
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          // Conteúdo das tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSearchTab(),
                _buildCategoryTab(),
                _buildPopularTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final theme = Theme.of(context);

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'Categoria:',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Todas as categorias
                  _buildCategoryChip(null, 'Todas', theme),
                  const SizedBox(width: 8),

                  // Categorias específicas
                  ...CommunityCategory.values.map((category) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildCategoryChip(
                            category, category.displayName, theme),
                      )),
                ],
              ),
            ),
          ),

          // Limpar filtros
          if (_selectedCategory != null || _currentQuery.isNotEmpty)
            TextButton(
              onPressed: _clearFilters,
              child: const Text('Limpar'),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
      CommunityCategory? category, String label, ThemeData theme) {
    final isSelected = _selectedCategory == category;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (category != null) ...[
            Text(category.emoji),
            const SizedBox(width: 4),
          ],
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        _onCategorySelected(selected ? category : null);
      },
      backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.primary,
    );
  }

  Widget _buildSearchTab() {
    if (_currentQuery.isEmpty) {
      return _buildEmptyState(
        'Digite algo para buscar',
        'Use a barra de busca acima para encontrar comunidades',
        Icons.search,
      );
    }

    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchResults.isEmpty) {
      return _buildEmptyState(
        'Nenhuma comunidade encontrada',
        'Tente usar termos diferentes ou explore outras categorias',
        Icons.search_off,
      );
    }

    return _buildCommunityList(_searchResults);
  }

  Widget _buildCategoryTab() {
    if (_selectedCategory == null) {
      return _buildCategorySelection();
    }

    if (_isLoadingCategory) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_categoryResults.isEmpty) {
      return _buildEmptyState(
        'Nenhuma comunidade nesta categoria',
        'Seja o primeiro a criar uma comunidade de ${_selectedCategory!.displayName}!',
        Icons.category,
      );
    }

    return _buildCommunityList(_categoryResults);
  }

  Widget _buildPopularTab() {
    if (_isLoadingPopular) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_popularResults.isEmpty) {
      return _buildEmptyState(
        'Nenhuma comunidade popular ainda',
        'As comunidades mais ativas aparecerão aqui',
        Icons.trending_up,
      );
    }

    return _buildCommunityList(_popularResults);
  }

  Widget _buildCommunityList(List<CommunityModel> communities) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: communities.length,
      itemBuilder: (context, index) {
        final community = communities[index];
        final isUserMember = ref.watch(isUserMemberProvider(community.id));

        return CommunityCard(
          community: community,
          isJoined: isUserMember,
          onTap: () => _navigateToCommunityDetail(community),
          onJoin: () => _joinCommunity(community),
          onLeave: () => _leaveCommunity(community),
        );
      },
    );
  }

  Widget _buildCategorySelection() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Escolha uma Categoria',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Explore comunidades por categoria para encontrar algo do seu interesse.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: CommunityCategory.values.length,
              itemBuilder: (context, index) {
                final category = CommunityCategory.values[index];
                return _buildCategoryCard(category, theme);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(CommunityCategory category, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _onCategorySelected(category),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primaryContainer.withOpacity(0.3),
                theme.colorScheme.secondaryContainer.withOpacity(0.3),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                category.emoji,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 8),
              Text(
                category.displayName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String description, IconData icon) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCommunityDetail(CommunityModel community) {
    // TODO: Implementar navegação para detalhes da comunidade
    AppLogger.info('Navegando para detalhes da comunidade', data: {
      'communityId': community.id,
      'name': community.name,
    });
  }

  Future<void> _joinCommunity(CommunityModel community) async {
    try {
      final success = await ref
          .read(communityProvider.notifier)
          .joinCommunity(community.id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Você entrou na comunidade ${community.name}!'),
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
    }
  }

  Future<void> _leaveCommunity(CommunityModel community) async {
    try {
      final success = await ref
          .read(communityProvider.notifier)
          .leaveCommunity(community.id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Você saiu da comunidade ${community.name}'),
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
    }
  }
}
