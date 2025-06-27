import 'package:flutter/material.dart';

/// Componente reutilizável para botões de acesso rápido
class QuickAccessButton extends StatelessWidget {
  final String text;
  final String? subtitle; // Novo parâmetro para subtítulo
  final VoidCallback onPressed;
  final IconData? leadingIcon; // New parameter for leading icon

  const QuickAccessButton({
    super.key,
    required this.text,
    this.subtitle, // Adicionado ao construtor
    required this.onPressed,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.withOpacity(0.8),
              Theme.of(context).primaryColor.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (leadingIcon != null) ...<Widget>[
                  Icon(
                    leadingIcon,
                    size: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize
                        .min, // Para que a coluna não ocupe todo o espaço vertical
                    children: [
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
