import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Duration duration;
  final double scaleDown;
  final double scaleUp;
  final bool enableHoverEffect;

  const AnimatedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.duration = const Duration(milliseconds: 120),
    this.scaleDown = 0.97,
    this.scaleUp = 1.0,
    this.enableHoverEffect = true,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: widget.scaleUp,
      end: widget.scaleDown,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _handleTapEnd();
  }

  void _handleTapCancel() {
    _handleTapEnd();
  }

  void _handleTapEnd() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse().then((_) {
        if (mounted && widget.onPressed != null) {
          widget.onPressed!();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        ),
      ),
    );
  }
}

// Versão mais simples para casos onde só precisamos do efeito básico
class SimpleAnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const SimpleAnimatedButton({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  State<SimpleAnimatedButton> createState() => _SimpleAnimatedButtonState();
}

class _SimpleAnimatedButtonState extends State<SimpleAnimatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => _handleTapEnd(),
      onTapCancel: () => _handleTapEnd(),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }

  void _handleTapEnd() {
    setState(() => _isPressed = false);
    if (widget.onPressed != null) {
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) widget.onPressed!();
      });
    }
  }
}

// Button com ripple effect personalizado
class RippleAnimatedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final Color? highlightColor;

  const RippleAnimatedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.borderRadius,
    this.splashColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        splashColor:
            splashColor ?? Theme.of(context).primaryColor.withOpacity(0.1),
        highlightColor:
            highlightColor ?? Theme.of(context).primaryColor.withOpacity(0.05),
        child: child,
      ),
    );
  }
}
