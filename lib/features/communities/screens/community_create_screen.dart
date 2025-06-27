// CommunityCreateScreen - Criar nova comunidade
// Arquivo criado automaticamente pelo script de estrutura
// Data: 2025-06-27 13:56:53
// Projeto: ClashUp - Sistema de Comunidades

// TODO: Implementar a classe/funcionalidade
// lib/features/communities/screens/community_create_screen.dart
// CommunityCreateScreen - Criar nova comunidade
import 'package:clashup/core/constants/app_constants.dart';
import 'package:clashup/core/utils/logger.dart';
import 'package:clashup/features/communities/constants/community_constants.dart';
import 'package:clashup/features/communities/models/community_model.dart';
import 'package:clashup/features/communities/providers/community_provider.dart';
import 'package:clashup/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityCreateScreen extends ConsumerStatefulWidget {
  const CommunityCreateScreen({super.key});

  @override
  ConsumerState<CommunityCreateScreen> createState() =>
      _CommunityCreateScreenState();
}

class _CommunityCreateScreenState extends ConsumerState<CommunityCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rulesController = TextEditingController();
  final _welcomeMessageController = TextEditingController();
  final _tagController = TextEditingController();

  CommunityCategory _selectedCategory = CommunityCategory.other;
  CommunityPrivacyType _selectedPrivacy = CommunityPrivacyType.public;
  List<String> _tags = [];
  bool _isCreating = false;
  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _rulesController.dispose();
    _welcomeMessageController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _createCommunity() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = ref.read(authProvider).user;
    if (user == null) {
      _showErrorSnackBar('Você precisa estar logado para criar uma comunidade');
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      final community =
          await ref.read(communityProvider.notifier).createCommunity(
                name: _nameController.text.trim(),
                description: _descriptionController.text.trim(),
                category: _selectedCategory,
                privacyType: _selectedPrivacy,
                tags: _tags,
                rules: _rulesController.text.trim().isNotEmpty
                    ? _rulesController.text.trim()
                    : null,
                welcomeMessage: _welcomeMessageController.text.trim().isNotEmpty
                    ? _welcomeMessageController.text.trim()
                    : null,
              );

      if (community != null && mounted) {
        AppLogger.info('Comunidade criada com sucesso', data: {
          'communityId': community.id,
          'name': community.name,
        });

        Navigator.of(context).pop(community);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Comunidade "${community.name}" criada com sucesso!'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'Ver',
              onPressed: () {
                // Navegar para a comunidade criada
              },
            ),
          ),
        );
      } else {
        _showErrorSnackBar('Erro ao criar comunidade. Tente novamente.');
      }
    } catch (e) {
      AppLogger.error('Erro ao criar comunidade', error: e);
      _showErrorSnackBar('Erro ao criar comunidade: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty &&
        !_tags.contains(tag) &&
        _tags.length < CommunityConstants.maxTagsCount &&
        tag.length <= CommunityConstants.maxTagLength) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Comunidade'),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        actions: [
          if (_currentStep == 2)
            TextButton(
              onPressed: _isCreating ? null : _createCommunity,
              child: _isCreating
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Criar'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Progress indicator
            _buildStepIndicator(),

            // Content
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: PageController(initialPage: _currentStep),
                children: [
                  _buildBasicInfoStep(),
                  _buildDetailsStep(),
                  _buildSettingsStep(),
                ],
              ),
            ),

            // Navigation buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          for (int i = 0; i < 3; i++) ...[
            _buildStepCircle(i, theme),
            if (i < 2) _buildStepLine(i, theme),
          ],
        ],
      ),
    );
  }

  Widget _buildStepCircle(int index, ThemeData theme) {
    final isActive = index == _currentStep;
    final isCompleted = index < _currentStep;

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isCompleted || isActive
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceVariant,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isCompleted
            ? Icon(
                Icons.check,
                color: theme.colorScheme.onPrimary,
                size: 16,
              )
            : Text(
                '${index + 1}',
                style: TextStyle(
                  color: isActive
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }

  Widget _buildStepLine(int index, ThemeData theme) {
    final isCompleted = index < _currentStep;

    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isCompleted
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informações Básicas',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vamos começar com as informações essenciais da sua comunidade.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),

          const SizedBox(height: 32),

          // Nome da comunidade
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nome da Comunidade *',
              hintText: 'Ex: Desenvolvedores Flutter',
              prefixIcon: Icon(Icons.groups),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nome é obrigatório';
              }
              if (value.trim().length <
                  CommunityConstants.minCommunityNameLength) {
                return 'Nome deve ter pelo menos ${CommunityConstants.minCommunityNameLength} caracteres';
              }
              if (value.trim().length >
                  CommunityConstants.maxCommunityNameLength) {
                return 'Nome deve ter no máximo ${CommunityConstants.maxCommunityNameLength} caracteres';
              }
              if (!AppConstants.isValidCommunityName(value.trim())) {
                return 'Nome contém caracteres inválidos';
              }
              return null;
            },
            maxLength: CommunityConstants.maxCommunityNameLength,
          ),

          const SizedBox(height: 20),

          // Categoria
          DropdownButtonFormField<CommunityCategory>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Categoria *',
              prefixIcon: Icon(Icons.category),
              border: OutlineInputBorder(),
            ),
            items: CommunityCategory.values.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Row(
                  children: [
                    Text(category.emoji, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(category.displayName),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedCategory = value;
                });
              }
            },
          ),

          const SizedBox(height: 20),

          // Descrição
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descrição *',
              hintText: 'Descreva o propósito e objetivo da sua comunidade...',
              prefixIcon: Icon(Icons.description),
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Descrição é obrigatória';
              }
              if (value.trim().length <
                  CommunityConstants.minCommunityDescriptionLength) {
                return 'Descrição deve ter pelo menos ${CommunityConstants.minCommunityDescriptionLength} caracteres';
              }
              if (value.trim().length >
                  CommunityConstants.maxCommunityDescriptionLength) {
                return 'Descrição deve ter no máximo ${CommunityConstants.maxCommunityDescriptionLength} caracteres';
              }
              return null;
            },
            maxLength: CommunityConstants.maxCommunityDescriptionLength,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detalhes e Configurações',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Configure as regras e mensagens da sua comunidade.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),

          const SizedBox(height: 32),

          // Tags
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tags',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _tagController,
                      decoration: const InputDecoration(
                        hintText: 'Adicionar tag...',
                        border: OutlineInputBorder(),
                      ),
                      onFieldSubmitted: (_) => _addTag(),
                      maxLength: CommunityConstants.maxTagLength,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addTag,
                    child: const Text('Adicionar'),
                  ),
                ],
              ),
              if (_tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _tags.map((tag) {
                    return Chip(
                      label: Text('#$tag'),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () => _removeTag(tag),
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.3),
                    );
                  }).toList(),
                ),
              ],
              Text(
                '${_tags.length}/${CommunityConstants.maxTagsCount} tags',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Regras da comunidade
          TextFormField(
            controller: _rulesController,
            decoration: const InputDecoration(
              labelText: 'Regras da Comunidade (Opcional)',
              hintText: 'Defina as regras e diretrizes da sua comunidade...',
              prefixIcon: Icon(Icons.rule),
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            maxLength: CommunityConstants.maxCommunityRulesLength,
          ),

          const SizedBox(height: 20),

          // Mensagem de boas-vindas
          TextFormField(
            controller: _welcomeMessageController,
            decoration: const InputDecoration(
              labelText: 'Mensagem de Boas-vindas (Opcional)',
              hintText: 'Mensagem que novos membros verão ao entrar...',
              prefixIcon: Icon(Icons.waving_hand),
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
            maxLength: CommunityConstants.maxWelcomeMessageLength,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsStep() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configurações Finais',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Defina quem pode ver e participar da sua comunidade.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),

          const SizedBox(height: 32),

          // Privacidade
          Text(
            'Privacidade da Comunidade',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          Column(
            children: CommunityPrivacyType.values.map((privacy) {
              return RadioListTile<CommunityPrivacyType>(
                value: privacy,
                groupValue: _selectedPrivacy,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedPrivacy = value;
                    });
                  }
                },
                title: Text(_getPrivacyTitle(privacy)),
                subtitle: Text(_getPrivacyDescription(privacy)),
                secondary: Icon(_getPrivacyIcon(privacy)),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // Resumo
          _buildSummary(theme),
        ],
      ),
    );
  }

  Widget _buildSummary(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.summarize,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Resumo da Comunidade',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Nome', _nameController.text.trim()),
          _buildSummaryRow('Categoria',
              '${_selectedCategory.emoji} ${_selectedCategory.displayName}'),
          _buildSummaryRow('Privacidade', _getPrivacyTitle(_selectedPrivacy)),
          if (_tags.isNotEmpty)
            _buildSummaryRow('Tags', _tags.map((tag) => '#$tag').join(', ')),
          if (_rulesController.text.trim().isNotEmpty)
            _buildSummaryRow('Regras', 'Definidas'),
          if (_welcomeMessageController.text.trim().isNotEmpty)
            _buildSummaryRow('Mensagem de Boas-vindas', 'Definida'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Não definido' : value,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
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
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  child: const Text('Voltar'),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _currentStep == 2
                    ? (_isCreating ? null : _createCommunity)
                    : _nextStep,
                child: _currentStep == 2
                    ? (_isCreating
                        ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                              SizedBox(width: 8),
                              Text('Criando...'),
                            ],
                          )
                        : const Text('Criar Comunidade'))
                    : const Text('Próximo'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPrivacyTitle(CommunityPrivacyType privacy) {
    switch (privacy) {
      case CommunityPrivacyType.public:
        return 'Pública';
      case CommunityPrivacyType.private:
        return 'Privada';
      case CommunityPrivacyType.restricted:
        return 'Restrita';
    }
  }

  String _getPrivacyDescription(CommunityPrivacyType privacy) {
    switch (privacy) {
      case CommunityPrivacyType.public:
        return 'Qualquer pessoa pode ver e entrar na comunidade';
      case CommunityPrivacyType.private:
        return 'Apenas pessoas convidadas podem ver e entrar';
      case CommunityPrivacyType.restricted:
        return 'Qualquer pessoa pode ver, mas precisa de aprovação para entrar';
    }
  }

  IconData _getPrivacyIcon(CommunityPrivacyType privacy) {
    switch (privacy) {
      case CommunityPrivacyType.public:
        return Icons.public;
      case CommunityPrivacyType.private:
        return Icons.lock;
      case CommunityPrivacyType.restricted:
        return Icons.lock_open;
    }
  }
}
