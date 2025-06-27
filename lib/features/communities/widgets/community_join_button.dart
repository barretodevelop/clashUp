// CommunityJoinButton - Botao de entrar/sair
// Arquivo criado automaticamente pelo script de estrutura
// Data: 2025-06-27 13:56:53
// Projeto: ClashUp - Sistema de Comunidades

// TODO: Implementar a classe/funcionalidade

// lib/features/communities/widgets/community_join_button.dart
// CommunityJoinButton - Botão especializado para entrar/sair de comunidades
import 'package:clashup/features/communities/models/community_model.dart';
import 'package:flutter/material.dart';

enum CommunityJoinButtonSize {
  small,
  medium,
  large,
}

enum CommunityJoinButtonStyle {
  filled, // Botão preenchido
  outlined, // Botão com borda
  text, // Apenas texto
  icon, // Apenas ícone
}

class CommunityJoinButton extends StatefulWidget {
  final CommunityModel community;
  final bool isUserMember;
  final bool isLoading;
  final VoidCallback? onJoin;
  final VoidCallback? onLeave;
  final CommunityJoinButtonSize size;
  final CommunityJoinButtonStyle style;
  final bool showIcon;
  final bool showText;
  final String? customJoinText;
  final String? customLeaveText;
  final Color? customColor;

  const CommunityJoinButton({
    super.key,
    required this.community,
    this.isUserMember = false,
    this.isLoading = false,
    this.onJoin,
    this.onLeave,
    this.size = CommunityJoinButtonSize.medium,
    this.style = CommunityJoinButtonStyle.filled,
    this.showIcon = true,
    this.showText = true,
    this.customJoinText,
    this.customLeaveText,
    this.customColor,
  });

  @override
  State<CommunityJoinButton> createState() => _CommunityJoinButtonState();
}

class _CommunityJoinButtonState extends State<CommunityJoinButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handlePress() async {
    if (_isProcessing || widget.isLoading) return;

    setState(() {
      _isProcessing = true;
    });

    // Animação de feedback
    await _animationController.forward();
    await _animationController.reverse();

    try {
      if (widget.isUserMember) {
        widget.onLeave?.call();
      } else {
        widget.onJoin?.call();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = widget.isLoading || _isProcessing;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: _buildButton(context, theme, isDisabled),
        );
      },
    );
  }

  Widget _buildButton(BuildContext context, ThemeData theme, bool isDisabled) {
    switch (widget.style) {
      case CommunityJoinButtonStyle.filled:
        return _buildFilledButton(theme, isDisabled);
      case CommunityJoinButtonStyle.outlined:
        return _buildOutlinedButton(theme, isDisabled);
      case CommunityJoinButtonStyle.text:
        return _buildTextButton(theme, isDisabled);
      case CommunityJoinButtonStyle.icon:
        return _buildIconButton(theme, isDisabled);
    }
  }

  Widget _buildFilledButton(ThemeData theme, bool isDisabled) {
    final buttonColor = _getButtonColor(theme);
    final textColor = _getTextColor(theme);
    final size = _getButtonSize();

    return SizedBox(
      width: size.width,
      height: size.height,
      child: ElevatedButton(
        onPressed: isDisabled ? null : _handlePress,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: textColor,
          disabledBackgroundColor: theme.colorScheme.surfaceVariant,
          disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
          elevation: widget.isUserMember ? 0 : 2,
          padding: _getButtonPadding(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_getBorderRadius()),
            side: widget.isUserMember
                ? BorderSide(color: buttonColor, width: 1)
                : BorderSide.none,
          ),
        ),
        child: _buildButtonContent(theme, isDisabled),
      ),
    );
  }

  Widget _buildOutlinedButton(ThemeData theme, bool isDisabled) {
    final buttonColor = _getButtonColor(theme);
    final textColor = buttonColor;
    final size = _getButtonSize();

    return SizedBox(
      width: size.width,
      height: size.height,
      child: OutlinedButton(
        onPressed: isDisabled ? null : _handlePress,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor,
          disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
          side: BorderSide(
            color: isDisabled ? theme.colorScheme.outline : buttonColor,
            width: 1.5,
          ),
          padding: _getButtonPadding(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_getBorderRadius()),
          ),
        ),
        child: _buildButtonContent(theme, isDisabled),
      ),
    );
  }

  Widget _buildTextButton(ThemeData theme, bool isDisabled) {
    final buttonColor = _getButtonColor(theme);
    final size = _getButtonSize();

    return SizedBox(
      width: size.width,
      height: size.height,
      child: TextButton(
        onPressed: isDisabled ? null : _handlePress,
        style: TextButton.styleFrom(
          foregroundColor: buttonColor,
          disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
          padding: _getButtonPadding(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_getBorderRadius()),
          ),
        ),
        child: _buildButtonContent(theme, isDisabled),
      ),
    );
  }

  Widget _buildIconButton(ThemeData theme, bool isDisabled) {
    final buttonColor = _getButtonColor(theme);
    final size = _getIconButtonSize();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: widget.style == CommunityJoinButtonStyle.icon
            ? (widget.isUserMember ? Colors.transparent : buttonColor)
            : null,
        border: widget.isUserMember
            ? Border.all(color: buttonColor, width: 1.5)
            : null,
        borderRadius: BorderRadius.circular(size / 4),
      ),
      child: IconButton(
        onPressed: isDisabled ? null : _handlePress,
        icon: _buildIcon(theme, forIconButton: true),
        color: widget.isUserMember ? buttonColor : theme.colorScheme.onPrimary,
        splashRadius: size / 2.5,
      ),
    );
  }

  Widget _buildButtonContent(ThemeData theme, bool isDisabled) {
    if (isDisabled && (widget.isLoading || _isProcessing)) {
      return _buildLoadingContent(theme);
    }

    final children = <Widget>[];

    if (widget.showIcon) {
      children.add(_buildIcon(theme));
      if (widget.showText) {
        children.add(SizedBox(width: _getIconTextSpacing()));
      }
    }

    if (widget.showText) {
      children.add(_buildText(theme));
    }

    if (children.length == 1) {
      return children.first;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget _buildLoadingContent(ThemeData theme) {
    final children = <Widget>[];

    children.add(SizedBox(
      width: _getLoadingSize(),
      height: _getLoadingSize(),
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.style == CommunityJoinButtonStyle.filled
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.primary,
        ),
      ),
    ));

    if (widget.showText) {
      children.add(SizedBox(width: _getIconTextSpacing()));
      children.add(Text(_getLoadingText()));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget _buildIcon(ThemeData theme, {bool forIconButton = false}) {
    IconData icon;

    if (widget.isUserMember) {
      icon = _getLeaveIconForCommunity();
    } else {
      icon = _getJoinIconForCommunity();
    }

    return Icon(
      icon,
      size: forIconButton ? _getIconButtonIconSize() : _getIconSize(),
    );
  }

  Widget _buildText(ThemeData theme) {
    String text;

    if (widget.isUserMember) {
      text = widget.customLeaveText ?? _getLeaveTextForCommunity();
    } else {
      text = widget.customJoinText ?? _getJoinTextForCommunity();
    }

    return Text(
      text,
      style: _getTextStyle(theme),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Métodos auxiliares para cores e estilos
  Color _getButtonColor(ThemeData theme) {
    if (widget.customColor != null) {
      return widget.customColor!;
    }

    if (widget.isUserMember) {
      return theme.colorScheme.outline;
    } else {
      return theme.colorScheme.primary;
    }
  }

  Color _getTextColor(ThemeData theme) {
    if (widget.style == CommunityJoinButtonStyle.filled) {
      return widget.isUserMember
          ? _getButtonColor(theme)
          : theme.colorScheme.onPrimary;
    } else {
      return _getButtonColor(theme);
    }
  }

  // Métodos para tamanhos
  Size _getButtonSize() {
    switch (widget.size) {
      case CommunityJoinButtonSize.small:
        return widget.showText ? const Size(80, 32) : const Size(32, 32);
      case CommunityJoinButtonSize.medium:
        return widget.showText ? const Size(120, 40) : const Size(40, 40);
      case CommunityJoinButtonSize.large:
        return widget.showText
            ? const Size(double.infinity, 48)
            : const Size(48, 48);
    }
  }

  double _getIconButtonSize() {
    switch (widget.size) {
      case CommunityJoinButtonSize.small:
        return 32;
      case CommunityJoinButtonSize.medium:
        return 40;
      case CommunityJoinButtonSize.large:
        return 48;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case CommunityJoinButtonSize.small:
        return 16;
      case CommunityJoinButtonSize.medium:
        return 18;
      case CommunityJoinButtonSize.large:
        return 20;
    }
  }

  double _getIconButtonIconSize() {
    switch (widget.size) {
      case CommunityJoinButtonSize.small:
        return 16;
      case CommunityJoinButtonSize.medium:
        return 20;
      case CommunityJoinButtonSize.large:
        return 24;
    }
  }

  double _getLoadingSize() {
    switch (widget.size) {
      case CommunityJoinButtonSize.small:
        return 14;
      case CommunityJoinButtonSize.medium:
        return 16;
      case CommunityJoinButtonSize.large:
        return 18;
    }
  }

  EdgeInsets _getButtonPadding() {
    switch (widget.size) {
      case CommunityJoinButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case CommunityJoinButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case CommunityJoinButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    }
  }

  double _getBorderRadius() {
    switch (widget.size) {
      case CommunityJoinButtonSize.small:
        return 8;
      case CommunityJoinButtonSize.medium:
        return 10;
      case CommunityJoinButtonSize.large:
        return 12;
    }
  }

  double _getIconTextSpacing() {
    switch (widget.size) {
      case CommunityJoinButtonSize.small:
        return 4;
      case CommunityJoinButtonSize.medium:
        return 6;
      case CommunityJoinButtonSize.large:
        return 8;
    }
  }

  TextStyle? _getTextStyle(ThemeData theme) {
    switch (widget.size) {
      case CommunityJoinButtonSize.small:
        return theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        );
      case CommunityJoinButtonSize.medium:
        return theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        );
      case CommunityJoinButtonSize.large:
        return theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        );
    }
  }

  // Métodos para textos e ícones baseados no tipo de comunidade
  IconData _getJoinIconForCommunity() {
    switch (widget.community.privacyType) {
      case CommunityPrivacyType.public:
        return Icons.add;
      case CommunityPrivacyType.private:
        return Icons.lock_open;
      case CommunityPrivacyType.restricted:
        return Icons.pending;
    }
  }

  IconData _getLeaveIconForCommunity() {
    return Icons.check;
  }

  String _getJoinTextForCommunity() {
    switch (widget.size) {
      case CommunityJoinButtonSize.small:
        switch (widget.community.privacyType) {
          case CommunityPrivacyType.public:
            return 'Entrar';
          case CommunityPrivacyType.private:
            return 'Solicitar';
          case CommunityPrivacyType.restricted:
            return 'Solicitar';
        }
      case CommunityJoinButtonSize.medium:
      case CommunityJoinButtonSize.large:
        switch (widget.community.privacyType) {
          case CommunityPrivacyType.public:
            return 'Entrar na Comunidade';
          case CommunityPrivacyType.private:
            return 'Solicitar Acesso';
          case CommunityPrivacyType.restricted:
            return 'Solicitar Entrada';
        }
    }
  }

  String _getLeaveTextForCommunity() {
    switch (widget.size) {
      case CommunityJoinButtonSize.small:
        return 'Membro';
      case CommunityJoinButtonSize.medium:
        return 'Você é Membro';
      case CommunityJoinButtonSize.large:
        return 'Sair da Comunidade';
    }
  }

  String _getLoadingText() {
    if (widget.isUserMember) {
      return 'Saindo...';
    } else {
      return 'Entrando...';
    }
  }
}

/// Widget simplificado para casos de uso rápido
class QuickJoinButton extends StatelessWidget {
  final CommunityModel community;
  final bool isUserMember;
  final VoidCallback? onJoin;
  final VoidCallback? onLeave;

  const QuickJoinButton({
    super.key,
    required this.community,
    this.isUserMember = false,
    this.onJoin,
    this.onLeave,
  });

  @override
  Widget build(BuildContext context) {
    return CommunityJoinButton(
      community: community,
      isUserMember: isUserMember,
      onJoin: onJoin,
      onLeave: onLeave,
      size: CommunityJoinButtonSize.small,
      style: CommunityJoinButtonStyle.outlined,
    );
  }
}

/// Widget para botão apenas com ícone
class CommunityJoinIconButton extends StatelessWidget {
  final CommunityModel community;
  final bool isUserMember;
  final VoidCallback? onJoin;
  final VoidCallback? onLeave;

  const CommunityJoinIconButton({
    super.key,
    required this.community,
    this.isUserMember = false,
    this.onJoin,
    this.onLeave,
  });

  @override
  Widget build(BuildContext context) {
    return CommunityJoinButton(
      community: community,
      isUserMember: isUserMember,
      onJoin: onJoin,
      onLeave: onLeave,
      style: CommunityJoinButtonStyle.icon,
      showText: false,
    );
  }
}
