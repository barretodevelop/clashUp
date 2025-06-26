import 'package:clashup/core/constants/app_constants.dart';
import 'package:clashup/core/utils/logger.dart';
import 'package:clashup/onboarding/constants/onboarding_data.dart';
import 'package:clashup/onboarding/providers/onboarding_provider.dart';
import 'package:clashup/onboarding/widgets/avatar_selection_grid.dart';
import 'package:clashup/onboarding/widgets/onboarding_progress_bar.dart';
import 'package:clashup/onboarding/widgets/step_navigation_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnonymousIdentityScreen extends ConsumerStatefulWidget {
  const AnonymousIdentityScreen({super.key});

  @override
  ConsumerState<AnonymousIdentityScreen> createState() =>
      _AnonymousIdentityScreenState();
}

class _AnonymousIdentityScreenState
    extends ConsumerState<AnonymousIdentityScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _codinomeController = TextEditingController();
  final FocusNode _codinomeFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    AppLogger.info('🎭 AnonymousIdentityScreen: Iniciado');

    // Configurar animações
    _animationController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    // Iniciar animação
    _animationController.forward();

    // Atualizar step no provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(onboardingProvider.notifier).goToStep(1);
    });

    // Setup listeners
    _codinomeController.addListener(_onCodinomeChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _codinomeController.dispose();
    _codinomeFocus.dispose();
    super.dispose();
  }

  void _onCodinomeChanged() {
    final text = _codinomeController.text;
    ref.read(onboardingProvider.notifier).setCodinome(text);
  }

  void _onAvatarSelected(String avatarId) {
    ref.read(onboardingProvider.notifier).setAvatar(avatarId);

    // Dar foco ao campo de nome se ainda não tiver nome
    if (_codinomeController.text.isEmpty) {
      _codinomeFocus.requestFocus();
    }
  }

  void _handleNext() {
    // Fechar teclado antes de navegar
    FocusScope.of(context).unfocus();

    AppLogger.info('➡️ AnonymousIdentityScreen: Próxima tela (via provider)');
    ref.read(onboardingProvider.notifier).nextStep();
  }

  void _handleBack() {
    FocusScope.of(context).unfocus();
    AppLogger.info('⬅️ AnonymousIdentityScreen: Tela anterior (via provider)');
    ref.read(onboardingProvider.notifier).previousStep();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);
    final theme = Theme.of(context);
    final canAdvance = ref.watch(canAdvanceProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Progress Bar
                      const OnboardingProgressBar(),

                      const SizedBox(height: 32),

                      // Main Content
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Center(
                                child: Text(
                                  OnboardingConstants.stepTitles[1]!,
                                  style:
                                      theme.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Subtitle
                              Center(
                                child: Text(
                                  OnboardingConstants.stepSubtitles[1]!,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.8),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Avatar Selection
                              Text(
                                'Escolha seu avatar:',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),

                              const SizedBox(height: 16),

                              AvatarSelectionGrid(
                                selectedAvatarId: onboardingState.avatarId,
                                onAvatarSelected: _onAvatarSelected,
                              ),

                              const SizedBox(height: 32),

                              // Info Text
                              Text(
                                'Este será seu nome público no app. Você pode mudá-lo depois.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),

                              // Preview Card
                              if (onboardingState.avatarId != null &&
                                  onboardingState.codinome != null &&
                                  onboardingState.codinome!.isNotEmpty) ...[
                                const SizedBox(height: 24),
                                Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        // Avatar Preview
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: theme.colorScheme.primary
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              OnboardingConstants.freeAvatars
                                                  .firstWhere(
                                                    (a) =>
                                                        a.id ==
                                                        onboardingState
                                                            .avatarId,
                                                  )
                                                  .emoji,
                                              style: const TextStyle(
                                                fontSize: 24,
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 12),

                                        // Name Preview
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                onboardingState.codinome!,
                                                style: theme
                                                    .textTheme.titleMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: theme
                                                      .colorScheme.onSurface,
                                                ),
                                              ),
                                              Text(
                                                'Como outros te verão',
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                  color: theme
                                                      .colorScheme.onSurface
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Icon(
                                          Icons.visibility_outlined,
                                          color: theme.colorScheme.primary,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],

                              const SizedBox(height: 24),

                              // Name Input
                              Text(
                                'Como quer ser chamado?',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),

                              const SizedBox(height: 12),

                              TextFormField(
                                controller: _codinomeController,
                                focusNode: _codinomeFocus,
                                decoration: InputDecoration(
                                  hintText: 'Digite seu nome anônimo...',
                                  counterText:
                                      '${_codinomeController.text.length}/${OnboardingConstants.maxCodinomeLength}', // Display character count
                                  prefixIcon: onboardingState.avatarId != null
                                      ? Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            OnboardingConstants.freeAvatars
                                                .firstWhere(
                                                  (a) =>
                                                      a.id ==
                                                      onboardingState.avatarId,
                                                )
                                                .emoji,
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        )
                                      : const Icon(Icons.person_outline),
                                  suffixIcon: _codinomeController
                                          .text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            _codinomeController.clear();
                                            ref
                                                .read(
                                                  onboardingProvider.notifier,
                                                )
                                                .setCodinome('');
                                          },
                                        )
                                      : null,
                                ),
                                maxLength:
                                    OnboardingConstants.maxCodinomeLength,
                                textCapitalization: TextCapitalization.words,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z0-9\s]'),
                                  ),
                                ],
                                onFieldSubmitted: (_) {
                                  if (canAdvance) {
                                    _handleNext();
                                  }
                                },
                              ),

                              const SizedBox(height: 12),

                              // Error Display
                              if (onboardingState.error != null) ...[
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.error.withOpacity(
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: theme.colorScheme.error
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: theme.colorScheme.error,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          onboardingState.error!,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: theme.colorScheme.error,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),

                      // Bottom Navigation
                      StepNavigationButtons(
                        onNext: canAdvance ? _handleNext : null,
                        onBack: _handleBack,
                        nextText: OnboardingConstants.stepButtons[1]!,
                        backText: 'Voltar',
                        showBack: true,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
