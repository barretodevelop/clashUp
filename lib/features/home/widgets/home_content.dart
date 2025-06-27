import 'package:clashup/features/home/widgets/quick_access_button.dart';
import 'package:clashup/features/user/providers/user_provider.dart';
import 'package:clashup/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeContent extends ConsumerStatefulWidget {
  final ValueChanged<int> onNavigateToTab;

  const HomeContent({Key? key, required this.onNavigateToTab})
      : super(key: key);

  @override
  ConsumerState<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends ConsumerState<HomeContent>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Welcome Section com animação fade
          // Pass userModel to WelcomeSection
          FadeTransition(
            opacity: _fadeAnimation,
            child: _WelcomeSection(userModel: ref.watch(userProvider)),
          ),

          const SizedBox(height: 16),

          // // // User Mode Card com animação slide
          // // SlideTransition(
          // //   position: _slideAnimation,
          // //   child: const OptimizedUserModeCard(),
          // // ),

          // const SizedBox(height: 40),

          // Quick Actions com staggered animation
          _QuickActionsGrid(
            onNavigateToTab: widget.onNavigateToTab,
            slideAnimation: _slideAnimation,
          ),
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  final ValueChanged<int> onNavigateToTab;
  final Animation<Offset> slideAnimation;

  const _QuickActionsGrid({
    required this.onNavigateToTab,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final actions = [
      QuickAccessButton(
        leadingIcon: Icons.radar,
        text: 'Radar de Almas',
        subtitle: 'Descubra conexões',
        onPressed: () => onNavigateToTab(1),
      ),
      QuickAccessButton(
        leadingIcon: Icons.radar,
        text: 'Amigos',
        subtitle: 'Suas conexões',
        onPressed: () => onNavigateToTab(2),
      ),
      QuickAccessButton(
        leadingIcon: Icons.radar,
        text: 'Comunidades',
        subtitle: 'Encontre grupos',
        onPressed: () => onNavigateToTab(3),
      ),
      QuickAccessButton(
        leadingIcon: Icons.radar,
        text: 'Desafios',
        subtitle: 'Teste habilidades',
        onPressed: () => onNavigateToTab(4),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acesso Rápido',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        ...actions
            .map((action) => _AnimatedActionCard(
                  action: action,
                  slideAnimation: slideAnimation,
                ))
            .toList(),
      ],
    );
  }
}

class _AnimatedActionCard extends StatefulWidget {
  final QuickAccessButton action;
  final Animation<Offset> slideAnimation;

  const _AnimatedActionCard({
    required this.action,
    required this.slideAnimation,
  });

  @override
  State<_AnimatedActionCard> createState() => _AnimatedActionCardState();
}

class _AnimatedActionCardState extends State<_AnimatedActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: widget.slideAnimation,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Material(
                elevation: _isHovered ? 8 : 2,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: widget.action.onPressed,
                  onHover: _onHover,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: _isHovered
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.green.withOpacity(0.8),
                                // Theme.of(context)
                                //     .colorScheme
                                //     .primary
                                //     .withOpacity(0.08),
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.03),
                              ],
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            widget.action.leadingIcon,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.action.text,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              if (widget.action.subtitle != null)
                                Text(
                                  widget.action.subtitle!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color
                                            ?.withOpacity(0.7),
                                      ),
                                ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  final UserModel? userModel;

  const _WelcomeSection({super.key, this.userModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.surface.withOpacity(0.1),
            theme.colorScheme.surfaceBright.withOpacity(0.1)
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Mensagem de boas-vindas
          Text(
            'Bem-vindo de volta!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Descubra novas conexões e viva experiências únicas',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20), // Espaçamento adicionado após a descrição

          // Avatar e Nome
          _ProfileAvatar(userModel: userModel),
          const SizedBox(height: 12),

          Text(
            userModel?.displayName ?? 'Usuário',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),

          if (userModel?.username != null) ...[
            const SizedBox(height: 4),
            Text(
              '@${userModel!.username}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Estatísticas do Perfil
          _buildProfileStats(context),

          const SizedBox(height: 20),

          // Badges/Qualidades
          _buildUserBadges(context),
        ],
      ),
    );
  }

  Widget _buildProfileStats(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, 'Recados', userModel?.messagesCount ?? 114,
              Icons.message_outlined),
          _buildVerticalDivider(context),
          _buildStatItem(context, 'Fotos', userModel?.photosCount ?? 0,
              Icons.photo_outlined),
          _buildVerticalDivider(context),
          _buildStatItem(context, 'Vídeos', userModel?.videosCount ?? 5,
              Icons.videocam_outlined),
          _buildVerticalDivider(context),
          _buildStatItem(context, 'Fãs', userModel?.fansCount ?? 15,
              Icons.favorite_outline),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, String label, int count, IconData icon) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 40,
      width: 1,
      color: theme.colorScheme.outline.withOpacity(0.2),
    );
  }

  Widget _buildUserBadges(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: _buildBadge(
              context, 'Confiável', '😊😊', theme.colorScheme.primary),
        ),
        const SizedBox(width: 8),
        Expanded(
          child:
              _buildBadge(context, 'Legal', '😎', theme.colorScheme.secondary),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildBadge(context, 'Sexy', '💖', Colors.pink),
        ),
      ],
    );
  }

  Widget _buildBadge(
      BuildContext context, String label, String emoji, Color color) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatefulWidget {
  final UserModel? userModel;
  const _ProfileAvatar({super.key, this.userModel});

  @override
  State<_ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<_ProfileAvatar> {
  late String currentMood;

  @override
  void initState() {
    super.initState();
    currentMood = widget.userModel?.currentMood ?? '😊';
  }

  void _updateMood(String newMood) {
    setState(() {
      currentMood = newMood;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Corrigindo o link do placeholder que estava entre colchetes
    final String avatarUrl =
        widget.userModel?.avatar ?? 'https://via.placeholder.com/150';
    final String displayName = widget.userModel?.displayName ?? 'Anônimo';

    return GestureDetector(
      // GestureDetector envolve todo o Stack agora
      onTap: () => _showMoodBottomSheet(context),
      child: Stack(
        clipBehavior: Clip
            .none, // Permite que o emoji "saia" um pouco dos limites do avatar
        children: [
          // Container principal do avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                avatarUrl,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: theme.colorScheme.primary,
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return Container(
                    color: theme.colorScheme.surfaceVariant,
                    child: Center(
                      child: Text(
                        displayName.isNotEmpty
                            ? displayName[0].toUpperCase()
                            : '?',
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(color: theme.colorScheme.onSurface),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Emoji de humor posicionado na parte inferior direita DENTRO do avatar
          Positioned(
            bottom: -10, // Ajuste esses valores conforme a sua preferência
            right:
                -10, // Para que o emoji fique mais para fora ou para dentro do círculo
            child: Container(
              padding: const EdgeInsets.all(4),
              // A decoração comentada foi removida, mantendo o container simples
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Text(
                  currentMood,
                  key: ValueKey<String>(
                      currentMood), // Chave para AnimatedSwitcher
                  style: const TextStyle(
                      fontSize: 32), // Font size aumentado para 32
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMoodBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final desiredBottomSheetHeight = screenHeight *
        0.6; // Ajuste este valor conforme necessário (0.5 para metade)

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled:
          true, // Mantenha isso para que a bottom sheet possa crescer se necessário
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Importante para a altura inicial
          children: [
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Como você está se sentindo?',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Escolha seu humor atual',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            // --- AQUI ESTÁ A MUDANÇA: Limitando a altura do GridView com SingleChildScrollView ---
            SizedBox(
              height: desiredBottomSheetHeight -
                  (24 * 2 +
                      4 +
                      20 +
                      theme.textTheme.titleLarge!.fontSize! +
                      8 +
                      theme.textTheme.bodyMedium!.fontSize! +
                      24 +
                      20),
              child: SingleChildScrollView(
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    // Emojis "normais"
                    _buildMoodOption(context, '😊', 'Alegre', true),
                    _buildMoodOption(context, '😢', 'Triste', true),
                    _buildMoodOption(context, '😌', 'Calmo', true),
                    _buildMoodOption(context, '😴', 'Sonolento', true),
                    _buildMoodOption(context, '😎', 'Confiante', true),
                    _buildMoodOption(context, '🤔', 'Pensativo', true),
                    _buildMoodOption(context, '😃', 'Feliz', true),
                    _buildMoodOption(context, '😅', 'Aliviado', true),
                    _buildMoodOption(context, '😂', 'Rindo', true),
                    _buildMoodOption(context, '🥰', 'Apaixonado', true),
                    _buildMoodOption(context, '🤩', 'Estrelado', true),
                    _buildMoodOption(context, '😇', 'Anjo', true),
                    _buildMoodOption(context, '🤗', 'Abraçando', true),
                    _buildMoodOption(context, '🥳', 'Festeiro', true),
                    _buildMoodOption(context, '🤓', 'Nerd', true),
                    _buildMoodOption(context, '👍', 'OK', true),

                    // Emojis que precisam de coins (status: false)
                    _buildMoodOption(context, '😤', 'Irritado', false),
                    _buildMoodOption(context, '🤯', 'Chocado', false),
                    _buildMoodOption(context, '🥶', 'Com Frio', false),
                    _buildMoodOption(context, '🥵', 'Com Calor', false),
                    _buildMoodOption(context, '🤢', 'Enjoado', false),
                    _buildMoodOption(context, '🤮', 'Vomitanto', false),
                    _buildMoodOption(context, '🤯', 'Explodindo', false),
                    _buildMoodOption(context, '🤑', 'Rico', false),
                    _buildMoodOption(context, '😈', 'Diabinho', false),
                    _buildMoodOption(context, '👻', 'Fantasma', false),
                    _buildMoodOption(context, '👽', 'Alien', false),
                    _buildMoodOption(context, '🤖', 'Robô', false),
                    _buildMoodOption(context, '💩', 'Cocô', false),
                    _buildMoodOption(context, '💯', 'Cem', false),
                    _buildMoodOption(context, '👑', 'Coroa', false),
                    _buildMoodOption(context, '🔥', 'Fogo', false),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodOption(
      BuildContext context, String emoji, String label, bool status) {
    final theme = Theme.of(context);
    final isSelected = currentMood == emoji;

    final Color effectiveBorderColor = status
        ? (isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.outline.withOpacity(0.2))
        : Colors.grey.withOpacity(0.3); // Cor da borda quando desabilitado

    final Color effectiveBackgroundColor = status
        ? (isSelected
            ? theme.colorScheme.primary.withOpacity(0.2)
            : theme.colorScheme.surfaceVariant.withOpacity(0.5))
        : Colors.grey.withOpacity(0.1); // Cor de fundo quando desabilitado

    final Color effectiveTextColor = status
        ? (isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface.withOpacity(0.8))
        : Colors.grey.withOpacity(0.6); // Cor do texto quando desabilitado

    // Não defina uma cor explícita para o Text do emoji aqui, deixe o Icon.lock_outline lidar com o visual de desativado
    // Se precisar de um tom acinzentado no emoji, ajuste diretamente no Text se `!status`

    return GestureDetector(
      onTap: status // Apenas permite o toque se 'status' for true
          ? () {
              _updateMood(emoji);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Humor atualizado para $label'),
                  duration: const Duration(seconds: 2),
                  backgroundColor: theme.colorScheme.primary,
                ),
              );
            }
          : () {
              // Mensagem para emojis bloqueados
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Este humor está bloqueado! Precisa de coins para desbloquear.'),
                  duration: const Duration(seconds: 2),
                  backgroundColor:
                      theme.colorScheme.error, // Cor para indicar erro/bloqueio
                ),
              );
            },
      child: Container(
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: effectiveBorderColor,
            width: isSelected && status
                ? 2
                : 1, // Borda mais grossa apenas se selecionado e habilitado
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              // Usar Stack para sobrepor o cadeado
              alignment: Alignment.center,
              children: [
                Text(
                  emoji,
                  style: TextStyle(
                    fontSize: isSelected && status ? 26 : 24,
                    // Se o status for falso, torne o emoji um pouco opaco
                    color: status ? null : Colors.grey.withOpacity(0.7),
                  ),
                ),
                if (!status) // Mostra o cadeado se não estiver habilitado
                  Icon(
                    Icons.lock_outline,
                    size: 24,
                    color: Colors.white.withOpacity(0.7), // Cor do cadeado
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
                fontWeight:
                    isSelected && status ? FontWeight.bold : FontWeight.w500,
                color: effectiveTextColor, // Aplica a cor de "apagado"
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (!status) // Adiciona texto de "coins" se não estiver habilitado
              Text(
                '100 Coins', // Exemplo de custo
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber, // Cor para destacar o custo
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// class _WelcomeSection extends StatelessWidget {
//   final UserModel? userModel;

//   const _WelcomeSection({super.key, this.userModel});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surface,
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             theme.colorScheme.primary.withOpacity(0.1),
//             theme.colorScheme.surface.withOpacity(0.1),
//             theme.colorScheme.surfaceBright.withOpacity(0.1)
//           ],
//           stops: const [0.0, 0.5, 1.0],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: theme.colorScheme.outline.withOpacity(0.2),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         children: [
//           // Mensagem de boas-vindas
//           Text(
//             'Bem-vindo de volta!',
//             style: theme.textTheme.headlineSmall?.copyWith(
//               fontWeight: FontWeight.w600,
//               color: theme.colorScheme.onSurface,
//             ),
//           ),
//           const SizedBox(height: 8),
//           // Avatar e Nome
//           _ProfileAvatar(
//               userModel:
//                   userModel), // Não precisa mais de callbacks se o humor ficar interno
//           const SizedBox(height: 12),

//           Text(
//             userModel?.displayName ?? 'Usuário',
//             style: theme.textTheme.titleLarge?.copyWith(
//               fontWeight: FontWeight.bold,
//               color: theme.colorScheme.onSurface,
//             ),
//           ),

//           if (userModel?.username != null) ...[
//             const SizedBox(height: 4),
//             Text(
//               '@${userModel!.username}',
//               style: theme.textTheme.bodyMedium?.copyWith(
//                 color: theme.colorScheme.onSurface.withOpacity(0.6),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],

//           const SizedBox(height: 20),

//           // Estatísticas do Perfil
//           _buildProfileStats(context),

//           const SizedBox(height: 20),

//           // Badges/Qualidades
//           _buildUserBadges(context),

//           const SizedBox(height: 20),

//           Text(
//             'Descubra novas conexões e viva experiências únicas',
//             style: theme.textTheme.bodyMedium?.copyWith(
//               color: theme.colorScheme.onSurface.withOpacity(0.7),
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProfileStats(BuildContext context) {
//     final theme = Theme.of(context);

//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: theme.colorScheme.outline.withOpacity(0.1),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildStatItem(context, 'Recados', userModel?.messagesCount ?? 114,
//               Icons.message_outlined),
//           _buildVerticalDivider(context),
//           _buildStatItem(context, 'Fotos', userModel?.photosCount ?? 0,
//               Icons.photo_outlined),
//           _buildVerticalDivider(context),
//           _buildStatItem(context, 'Vídeos', userModel?.videosCount ?? 5,
//               Icons.videocam_outlined),
//           _buildVerticalDivider(context),
//           _buildStatItem(context, 'Fãs', userModel?.fansCount ?? 15,
//               Icons.favorite_outline),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatItem(
//       BuildContext context, String label, int count, IconData icon) {
//     final theme = Theme.of(context);

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(
//           icon,
//           size: 20,
//           color: theme.colorScheme.primary,
//         ),
//         const SizedBox(height: 4),
//         Text(
//           count.toString(),
//           style: theme.textTheme.titleMedium?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: theme.colorScheme.onSurface,
//           ),
//         ),
//         Text(
//           label,
//           style: theme.textTheme.bodySmall?.copyWith(
//             color: theme.colorScheme.onSurface.withOpacity(0.6),
//             fontSize: 11,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildVerticalDivider(BuildContext context) {
//     final theme = Theme.of(context);
//     return Container(
//       height: 40,
//       width: 1,
//       color: theme.colorScheme.outline.withOpacity(0.2),
//     );
//   }

//   Widget _buildUserBadges(BuildContext context) {
//     final theme = Theme.of(context);

//     return Row(
//       children: [
//         Expanded(
//           child: _buildBadge(
//               context, 'Confiável', '😊😊', theme.colorScheme.primary),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child:
//               _buildBadge(context, 'Legal', '😎', theme.colorScheme.secondary),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: _buildBadge(context, 'Sexy', '💖', Colors.pink),
//         ),
//       ],
//     );
//   }

//   Widget _buildBadge(
//       BuildContext context, String label, String emoji, Color color) {
//     final theme = Theme.of(context);

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: color.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             emoji,
//             style: const TextStyle(fontSize: 16),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: theme.textTheme.bodySmall?.copyWith(
//               color: color,
//               fontWeight: FontWeight.w600,
//               fontSize: 11,
//             ),
//             overflow: TextOverflow.ellipsis,
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ProfileAvatar extends StatefulWidget {
//   final UserModel? userModel;
//   const _ProfileAvatar({super.key, this.userModel});

//   @override
//   State<_ProfileAvatar> createState() => _ProfileAvatarState();
// }

// class _ProfileAvatarState extends State<_ProfileAvatar> {
//   late String currentMood;

//   @override
//   void initState() {
//     super.initState();
//     currentMood = widget.userModel?.currentMood ?? '😊';
//   }

//   void _updateMood(String newMood) {
//     setState(() {
//       currentMood = newMood;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final String avatarUrl = widget.userModel?.avatar ??
//         '[https://via.placeholder.com/150](https://via.placeholder.com/150)';
//     final String displayName = widget.userModel?.displayName ?? 'Anônimo';

//     return GestureDetector(
//       // GestureDetector envolve todo o Stack agora
//       onTap: () => _showMoodBottomSheet(context),
//       child: Stack(
//         clipBehavior: Clip
//             .none, // Permite que o emoji "saia" um pouco dos limites do avatar
//         children: [
//           // Container principal do avatar
//           Container(
//             width: 100,
//             height: 100,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: theme.colorScheme.primary.withOpacity(0.1),
//               boxShadow: [
//                 BoxShadow(
//                   color: theme.colorScheme.primary.withOpacity(0.3),
//                   blurRadius: 20,
//                   offset: const Offset(0, 8),
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(50),
//               child: Image.network(
//                 avatarUrl,
//                 fit: BoxFit.cover,
//                 width: 100,
//                 height: 100,
//                 loadingBuilder: (BuildContext context, Widget child,
//                     ImageChunkEvent? loadingProgress) {
//                   if (loadingProgress == null) {
//                     return child;
//                   }
//                   return Center(
//                     child: CircularProgressIndicator(
//                       value: loadingProgress.expectedTotalBytes != null
//                           ? loadingProgress.cumulativeBytesLoaded /
//                               loadingProgress.expectedTotalBytes!
//                           : null,
//                       color: theme.colorScheme.primary,
//                     ),
//                   );
//                 },
//                 errorBuilder: (BuildContext context, Object error,
//                     StackTrace? stackTrace) {
//                   return Container(
//                     color: theme.colorScheme.surfaceVariant,
//                     child: Center(
//                       child: Text(
//                         displayName.isNotEmpty
//                             ? displayName[0].toUpperCase()
//                             : '?',
//                         style: theme.textTheme.headlineMedium
//                             ?.copyWith(color: theme.colorScheme.onSurface),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),

//           // Emoji de humor posicionado na parte inferior direita DENTRO do avatar
//           Positioned(
//             bottom: -10, // Ajuste esses valores conforme a sua preferência
//             right:
//                 -10, // Para que o emoji fique mais para fora ou para dentro do círculo
//             child: Container(
//               padding: const EdgeInsets.all(4),
//               // decoration: BoxDecoration(
//               //   shape: BoxShape.circle,
//               //   color: theme.colorScheme.surface,
//               //   boxShadow: [
//               //     BoxShadow(
//               //       color: Colors.black.withOpacity(0.2),
//               //       blurRadius: 4,
//               //       offset: const Offset(0, 1),
//               //     ),
//               //   ],
//               // ),
//               child: AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 300),
//                 transitionBuilder: (Widget child, Animation<double> animation) {
//                   return ScaleTransition(scale: animation, child: child);
//                 },
//                 child: Text(
//                   currentMood,
//                   key: ValueKey<String>(
//                       currentMood), // Chave para AnimatedSwitcher
//                   style: const TextStyle(fontSize: 32),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showMoodBottomSheet(BuildContext context) {
//     final theme = Theme.of(context);

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         decoration: BoxDecoration(
//           color: theme.colorScheme.surface,
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(24),
//             topRight: Radius.circular(24),
//           ),
//         ),
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 50,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: theme.colorScheme.outline.withOpacity(0.3),
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Como você está se sentindo?',
//               style: theme.textTheme.titleLarge?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: theme.colorScheme.onSurface,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Escolha seu humor atual',
//               style: theme.textTheme.bodyMedium?.copyWith(
//                 color: theme.colorScheme.onSurface.withOpacity(0.7),
//               ),
//             ),
//             const SizedBox(height: 24),
//             GridView.count(
//               shrinkWrap: true,
//               crossAxisCount: 4,
//               mainAxisSpacing: 16,
//               crossAxisSpacing: 16,
//               children: [
//                 _buildMoodOption(context, '😊', 'Alegre', true),
//                 _buildMoodOption(context, '😢', 'Triste', true),
//                 _buildMoodOption(context, '😌', 'Calmo', true),
//                 _buildMoodOption(context, '😴', 'Sonolento', true),
//                 _buildMoodOption(context, '😎', 'Confiante', true),
//                 _buildMoodOption(context, '🤔', 'Pensativo', true),
//                 _buildMoodOption(context, '😍', 'Apaixonado', true),
//                 _buildMoodOption(context, '🤩', 'Animado', true),
//                 _buildMoodOption(context, '😤', 'Irritado', false),
//                 _buildMoodOption(context, '🥳', 'Festeiro', true),
//                 _buildMoodOption(context, '😇', 'Zen', false),
//                 _buildMoodOption(context, '🤗', 'Carinhoso', false),
//               ],
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMoodOption(
//       BuildContext context, String emoji, String label, bool status) {
//     final theme = Theme.of(context);
//     final isSelected = currentMood == emoji;

//     return GestureDetector(
//       onTap: () {
//         _updateMood(emoji);
//         Navigator.pop(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Humor atualizado para $label'),
//             duration: const Duration(seconds: 2),
//             backgroundColor: theme.colorScheme.primary,
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: isSelected
//               ? theme.colorScheme.primary.withOpacity(0.2)
//               : theme.colorScheme.surfaceVariant.withOpacity(0.5),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isSelected
//                 ? theme.colorScheme.primary
//                 : theme.colorScheme.outline.withOpacity(0.2),
//             width: isSelected ? 2 : 1,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               emoji,
//               style: TextStyle(
//                 fontSize: isSelected ? 26 : 24,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: theme.textTheme.bodySmall?.copyWith(
//                 fontSize: 10,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
//                 color: isSelected
//                     ? theme.colorScheme.primary
//                     : theme.colorScheme.onSurface.withOpacity(0.8),
//               ),
//               textAlign: TextAlign.center,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
