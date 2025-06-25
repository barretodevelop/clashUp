import 'package:aplicativo_social/features/home/presentation/widgets/quick_access_button.dart';
import 'package:aplicativo_social/features/home/presentation/widgets/user_mode_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Constants for consistent spacing
const double _smallSpacing = 16.0;
const double _mediumSpacing = 32.0;

class HomeContent extends ConsumerWidget {
  final ValueChanged<int> onNavigateToTab;

  const HomeContent({Key? key, required this.onNavigateToTab})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Center the main column content
                  children: <Widget>[
                    // CircleAvatar for news/profile image
                    _ProfileAvatar(),
                    const SizedBox(height: _smallSpacing),

                    // User Mode Card (replaces economy chips in content area)
                    const UserModeCard(), // Modified to not require userMode

                    const SizedBox(height: _mediumSpacing),

                    // Spacer to push Quick Access to the bottom if content is short
                    const Spacer(),

                    // Quick Access Section
                    _QuickAccessSection(onNavigateToTab: onNavigateToTab),
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

/// Private widget to encapsulate the profile avatar logic.
class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dimensões para o conteúdo da imagem (excluindo a borda)
    const double imageContentWidth = 180.0;
    const double imageContentHeight =
        imageContentWidth * (4 / 3); // Proporção 3x4

    const double borderWidth = 4.0; // Espessura da borda branca
    const double borderRadius = 8.0; // Bordas menos arredondadas

    return Container(
      // O tamanho total do container, incluindo a borda
      width: imageContentWidth + (borderWidth * 2),
      height: imageContentHeight + (borderWidth * 2),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surface, // Use theme surface color for border
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .surface, // Use theme surface color for border
          width: borderWidth,
        ),
      ),
      child: ClipRRect(
        // Aplica o mesmo raio de borda à imagem para corresponder à forma do container
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.network(
          'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
          fit: BoxFit
              .cover, // Garante que a imagem cubra a área, cortando se necessário
          width:
              imageContentWidth, // Define explicitamente as dimensões da imagem
          height:
              imageContentHeight, // Define explicitamente as dimensões da imagem
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
                color: Theme.of(context)
                    .primaryColor, // Cor do tema para o indicador de progresso
              ),
            );
          },
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
            return Container(
              color: Theme.of(context)
                  .colorScheme
                  .surface
                  .withOpacity(0.5), // Adjusted for theme
              child: Icon(
                Icons.broken_image,
                size: imageContentWidth /
                    2, // Tamanho do ícone relativo à largura da imagem
                color: Theme.of(context)
                    .colorScheme
                    .onSurface, // Adjusted for theme
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Private widget to encapsulate the quick access buttons section.
class _QuickAccessSection extends StatelessWidget {
  final ValueChanged<int> onNavigateToTab;

  const _QuickAccessSection({super.key, required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Align text and buttons to the start
      children: [
        // Text(
        //   "Acesso Rápido",
        //   style: Theme.of(context).textTheme.titleLarge?.copyWith(
        //         fontWeight: FontWeight.bold,
        //       ),
        // ),
        const SizedBox(height: _smallSpacing),
        QuickAccessButton(
          leadingIcon: Icons.radar,
          text: "Ir para o Radar de Almas",
          subtitle: "Descubra novas conexões e almas afins",
          onPressed: () => onNavigateToTab(1), // Navigate to Radar tab
        ),
        const SizedBox(height: _smallSpacing),
        QuickAccessButton(
          leadingIcon: Icons.people,
          text: "Ver Amigos Revelados",
          subtitle: "Conecte-se com quem você já interagiu",
          onPressed: () => onNavigateToTab(2), // Navigate to Amigos tab
        ),
        const SizedBox(height: _smallSpacing),
        QuickAccessButton(
          leadingIcon: Icons.group,
          text: "Explorar Comunidades",
          subtitle: "Encontre grupos com interesses em comum",
          onPressed: () => onNavigateToTab(3), // Navigate to Comunidades tab
        ),
        const SizedBox(height: _smallSpacing),
        QuickAccessButton(
          leadingIcon: Icons.flag,
          text: "Participar de Desafios",
          subtitle: "Teste suas habilidades e ganhe recompensas",
          onPressed: () => onNavigateToTab(4), // Navigate to Desafios tab
        ),
        const SizedBox(height: _smallSpacing),
      ],
    );
  }
}
