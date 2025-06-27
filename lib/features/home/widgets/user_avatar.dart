import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final Color? backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final VoidCallback? onTap;

  const CustomCircleAvatar({
    Key? key,
    this.imageUrl,
    this.name,
    this.size = 120.0,
    this.backgroundColor,
    this.borderColor = Colors.white,
    this.borderWidth = 4.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: (size - borderWidth * 2) / 2,
          backgroundColor:
              backgroundColor ?? colorScheme.primary.withOpacity(0.2),
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
          child: imageUrl == null ? _buildDefaultAvatar(context) : null,
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (name != null && name!.isNotEmpty) {
      return Text(
        name![0].toUpperCase(),
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
      );
    }

    return Container(
      width: size * 0.6,
      height: size * 0.6,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular((size * 0.6) / 2),
      ),
      child: Icon(
        Icons.person,
        size: size * 0.4,
        color: Colors.white,
      ),
    );
  }
}
