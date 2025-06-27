// CommunitySearchBar - Barra de busca customizada
// Arquivo criado automaticamente pelo script de estrutura
// Data: 2025-06-27 13:56:53
// Projeto: ClashUp - Sistema de Comunidades

// TODO: Implementar a classe/funcionalidade

// lib/features/communities/widgets/community_search_bar.dart
// CommunitySearchBar - Barra de busca customizada para comunidades
import 'package:clashup/features/communities/models/community_model.dart';
import 'package:flutter/material.dart';

enum SearchBarStyle {
  minimal, // Apenas campo de busca
  extended, // Com filtros e opções
  floating, // Estilo floating
  embedded, // Integrado à página
}

class CommunitySearchBar extends StatefulWidget {
  final String? initialQuery;
  final CommunityCategory? initialCategory;
  final SearchBarStyle style;
  final Function(String query)? onSearch;
  final Function(String query, CommunityCategory? category)? onAdvancedSearch;
  final Function(CommunityCategory? category)? onCategoryChanged;
  final VoidCallback? onFilter;
  final VoidCallback? onClear;
  final bool showFilters;
  final bool showCategories;
  final bool showVoiceSearch;
  final bool autofocus;
  final String hintText;
  final List<String> recentSearches;
  final List<String> suggestedTags;

  const CommunitySearchBar({
    super.key,
    this.initialQuery,
    this.initialCategory,
    this.style = SearchBarStyle.extended,
    this.onSearch,
    this.onAdvancedSearch,
    this.onCategoryChanged,
    this.onFilter,
    this.onClear,
    this.showFilters = true,
    this.showCategories = true,
    this.showVoiceSearch = false,
    this.autofocus = false,
    this.hintText = 'Buscar comunidades...',
    this.recentSearches = const [],
    this.suggestedTags = const [],
  });

  @override
  State<CommunitySearchBar> createState() => _CommunitySearchBarState();
}

class _CommunitySearchBarState extends State<CommunitySearchBar>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  CommunityCategory? _selectedCategory;
  bool _isExpanded = false;
  bool _showSuggestions = false;
  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _selectedCategory = widget.initialCategory;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _showSuggestions = query.isNotEmpty;
      _filteredSuggestions = _buildFilteredSuggestions(query);
    });

    // Debounce search
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_controller.text == query && query.trim().isNotEmpty) {
        _performSearch(query);
      }
    });
  }

  void _performSearch(String query) {
    setState(() {
      _showSuggestions = false;
    });

    if (widget.onAdvancedSearch != null) {
      widget.onAdvancedSearch!(query.trim(), _selectedCategory);
    } else {
      widget.onSearch?.call(query.trim());
    }
  }

  void _onCategorySelected(CommunityCategory? category) {
    setState(() {
      _selectedCategory = category;
    });

    widget.onCategoryChanged?.call(category);

    // Refazer busca se houver query
    if (_controller.text.trim().isNotEmpty) {
      _performSearch(_controller.text);
    }
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _clearSearch() {
    _controller.clear();
    setState(() {
      _selectedCategory = null;
      _showSuggestions = false;
      _filteredSuggestions = [];
    });

    widget.onClear?.call();
  }

  List<String> _buildFilteredSuggestions(String query) {
    final allSuggestions = [
      ...widget.recentSearches,
      ...widget.suggestedTags,
    ];

    if (query.isEmpty) return allSuggestions.take(5).toList();

    final queryLower = query.toLowerCase();
    return allSuggestions
        .where((suggestion) => suggestion.toLowerCase().contains(queryLower))
        .take(5)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.style) {
      case SearchBarStyle.minimal:
        return _buildMinimalSearchBar();
      case SearchBarStyle.extended:
        return _buildExtendedSearchBar();
      case SearchBarStyle.floating:
        return _buildFloatingSearchBar();
      case SearchBarStyle.embedded:
        return _buildEmbeddedSearchBar();
    }
  }

  Widget _buildMinimalSearchBar() {
    final theme = Theme.of(context);

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        onChanged: _onSearchChanged,
        onSubmitted: _performSearch,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildExtendedSearchBar() {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Barra principal
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Campo de busca
              TextField(
                controller: _controller,
                autofocus: widget.autofocus,
                onChanged: _onSearchChanged,
                onSubmitted: _performSearch,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_controller.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _clearSearch,
                        ),
                      if (widget.showVoiceSearch)
                        IconButton(
                          icon: const Icon(Icons.mic),
                          onPressed: () {
                            // Implementar busca por voz
                          },
                        ),
                      if (widget.showFilters)
                        IconButton(
                          icon: Icon(
                            _isExpanded ? Icons.expand_less : Icons.expand_more,
                          ),
                          onPressed: _toggleExpanded,
                        ),
                    ],
                  ),
                ),
              ),

              // Filtros expandidos
              if (widget.showCategories)
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: _isExpanded ? 60 : 0,
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: child,
                      ),
                    );
                  },
                  child: _buildCategoryFilter(),
                ),
            ],
          ),
        ),

        // Sugestões
        if (_showSuggestions && _filteredSuggestions.isNotEmpty)
          _buildSuggestions(),
      ],
    );
  }

  Widget _buildFloatingSearchBar() {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            autofocus: widget.autofocus,
            onChanged: _onSearchChanged,
            onSubmitted: _performSearch,
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.search),
              ),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _clearSearch,
                    )
                  : null,
            ),
          ),
          if (_showSuggestions && _filteredSuggestions.isNotEmpty)
            _buildSuggestions(floating: true),
        ],
      ),
    );
  }

  Widget _buildEmbeddedSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            autofocus: widget.autofocus,
            onChanged: _onSearchChanged,
            onSubmitted: _performSearch,
            decoration: InputDecoration(
              hintText: widget.hintText,
              filled: true,
              fillColor:
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _clearSearch,
                    )
                  : null,
            ),
          ),
          if (widget.showCategories) ...[
            const SizedBox(height: 12),
            _buildCategoryFilter(),
          ],
          if (_showSuggestions && _filteredSuggestions.isNotEmpty)
            _buildSuggestions(),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final theme = Theme.of(context);

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            'Categoria:',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Todas
                  _buildCategoryChip(null, 'Todas', theme),
                  const SizedBox(width: 8),

                  // Categorias
                  ...CommunityCategory.values.map((category) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildCategoryChip(
                            category, category.displayName, theme),
                      )),
                ],
              ),
            ),
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
            Text(category.emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
          ],
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        _onCategorySelected(selected ? category : null);
      },
      backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.primary,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildSuggestions({bool floating = false}) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: floating
            ? const BorderRadius.vertical(bottom: Radius.circular(28))
            : const BorderRadius.vertical(bottom: Radius.circular(16)),
        border: floating
            ? null
            : Border(
                top: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.1),
                ),
              ),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _filteredSuggestions.length,
        itemBuilder: (context, index) {
          final suggestion = _filteredSuggestions[index];
          final isRecent = widget.recentSearches.contains(suggestion);

          return ListTile(
            dense: true,
            leading: Icon(
              isRecent ? Icons.history : Icons.tag,
              size: 18,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            title: Text(
              suggestion,
              style: theme.textTheme.bodyMedium,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.north_west, size: 16),
              onPressed: () {
                _controller.text = suggestion;
                _performSearch(suggestion);
              },
            ),
            onTap: () {
              _controller.text = suggestion;
              _performSearch(suggestion);
            },
          );
        },
      ),
    );
  }
}

/// Widget simplificado para busca rápida
class QuickCommunitySearch extends StatelessWidget {
  final Function(String)? onSearch;
  final String hintText;

  const QuickCommunitySearch({
    super.key,
    this.onSearch,
    this.hintText = 'Buscar...',
  });

  @override
  Widget build(BuildContext context) {
    return CommunitySearchBar(
      style: SearchBarStyle.minimal,
      onSearch: onSearch,
      hintText: hintText,
      showFilters: false,
      showCategories: false,
    );
  }
}

/// Widget para busca com filtros
class FilteredCommunitySearch extends StatelessWidget {
  final Function(String, CommunityCategory?)? onSearch;
  final List<String> recentSearches;

  const FilteredCommunitySearch({
    super.key,
    this.onSearch,
    this.recentSearches = const [],
  });

  @override
  Widget build(BuildContext context) {
    return CommunitySearchBar(
      style: SearchBarStyle.extended,
      onAdvancedSearch: onSearch,
      recentSearches: recentSearches,
      showFilters: true,
      showCategories: true,
    );
  }
}

/// Widget para busca em modal/overlay
class ModalCommunitySearch extends StatelessWidget {
  final Function(String)? onSearch;
  final VoidCallback? onClose;

  const ModalCommunitySearch({
    super.key,
    this.onSearch,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CommunitySearchBar(
                  style: SearchBarStyle.floating,
                  onSearch: onSearch,
                  autofocus: true,
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: onClose,
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
