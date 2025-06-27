import 'package:clashup/features/user/providers/user_provider.dart';
import 'package:clashup/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OptimizedUserModeCard extends ConsumerStatefulWidget {
  const OptimizedUserModeCard({Key? key}) : super(key: key);

  @override
  ConsumerState<OptimizedUserModeCard> createState() =>
      _OptimizedUserModeCardState();
}

class _OptimizedUserModeCardState extends ConsumerState<OptimizedUserModeCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  UserModeEnum? _animatingUserMode;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // Animação mais longa
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Atualiza o estado após a animação
        if (_animatingUserMode != null) {
          ref.read(userProvider.notifier).setUserMode(_animatingUserMode!);
        }
        setState(() {
          _animatingUserMode = null;
        });
        _animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onModeSelected(UserModeEnum selectedMode) {
    final UserModel? userModel = ref.read(userProvider);

    // If no user is loaded, or the selected mode is already the current mode, do nothing.
    if (userModel == null) {
      // Optionally, show a message that user data is not loaded
      return;
    }

    // Convert currentMood string to UserModeEnum for comparison
    final UserModeEnum? currentModeEnum = UserModeEnum.values
        .firstWhereOrNull((e) => e.name == userModel.currentMood);

    if (currentModeEnum != selectedMode) {
      setState(() {
        _animatingUserMode = selectedMode;
      });
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? userModel = ref.watch(userProvider);

    // Default to a mode if userModel is null or currentMood is not set
    final UserModeEnum currentMode = userModel != null &&
            userModel.currentMood != null
        ? UserModeEnum.values.firstWhere((e) => e.name == userModel.currentMood,
            orElse: () => UserModeEnum.alegre)
        : UserModeEnum.alegre; // Default mode if no user or mood

    return Stack(
      children: [
        // Lista horizontal sem card wrapper
        SizedBox(
          height: 70, // Altura compacta
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: UserModeEnum.values.length,
            itemBuilder: (context, index) {
              final mode = UserModeEnum.values[index];
              final isSelected = currentMode == mode;

              return _ColorfulModeOption(
                mode: mode,
                isSelected: isSelected,
                onTap: () => _onModeSelected(mode),
              );
            },
          ),
        ),

        // Animação do emoji grande subindo
        if (_animatingUserMode != null)
          AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget? child) {
              return Positioned.fill(
                child: Center(
                  child: Transform.translate(
                    offset: Offset(
                        0, -(_animation.value * 80)), // Sobe mais alto (80px)
                    child: Opacity(
                      opacity:
                          1.0 - _animation.value, // Desaparece gradualmente
                      child: Transform.scale(
                        scale: 1.0 +
                            (_animation.value *
                                1.5), // Cresce muito mais (150%)
                        child: Icon(
                          _animatingUserMode!.icon,
                          size: 60, // Emoji bem maior
                          color: _getModeColor(_animatingUserMode!),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  // Cores distintas para cada modo
  Color _getModeColor(UserModeEnum mode) {
    switch (mode) {
      case UserModeEnum.triste:
        return const Color(0xFF2196F3); // Azul
      case UserModeEnum.alegre:
        return const Color(0xFFFFC107); // Amarelo
      case UserModeEnum.aventureiro:
        return const Color(0xFF4CAF50); // Verde
      case UserModeEnum.calmo:
        return const Color(0xFF9C27B0); // Roxo
      case UserModeEnum.misterioso:
        return const Color(0xFF607D8B); // Azul acinzentado
    }
  }
}

// Helper extension to find enum by name (similar to firstWhereOrNull)
extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

class _ColorfulModeOption extends StatefulWidget {
  final UserModeEnum mode;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorfulModeOption({
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ColorfulModeOption> createState() => _ColorfulModeOptionState();
}

class _ColorfulModeOptionState extends State<_ColorfulModeOption>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  // Cores distintas para cada modo
  Color _getModeColor(UserModeEnum mode) {
    switch (mode) {
      case UserModeEnum.triste:
        return const Color(0xFF2196F3); // Azul
      case UserModeEnum.alegre:
        return const Color(0xFFFFC107); // Amarelo
      case UserModeEnum.aventureiro:
        return const Color(0xFF4CAF50); // Verde
      case UserModeEnum.calmo:
        return const Color(0xFF9C27B0); // Roxo
      case UserModeEnum.misterioso:
        return const Color(0xFF607D8B); // Azul acinzentado
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final modeColor = _getModeColor(widget.mode);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: widget.onTap,
              onTapDown: (_) => _hoverController.forward(),
              onTapUp: (_) => _hoverController.reverse(),
              onTapCancel: () => _hoverController.reverse(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? modeColor
                      : modeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: widget.isSelected
                      ? Border.all(color: modeColor, width: 2)
                      : Border.all(color: modeColor.withOpacity(0.3), width: 1),
                  boxShadow: widget.isSelected
                      ? [
                          BoxShadow(
                            color: modeColor.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.mode.icon,
                      size: widget.isSelected ? 26 : 22,
                      color: widget.isSelected ? Colors.white : modeColor,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.mode.displayName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 9,
                        fontWeight: widget.isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: widget.isSelected ? Colors.white : modeColor,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
