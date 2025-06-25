import 'package:aplicativo_social/core/providers/theme_provider.dart';
import 'package:aplicativo_social/core/theme/app_theme.dart'; // Import AppTheme
import 'package:aplicativo_social/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode appThemeMode = ref.watch(appThemeProvider);

    return MaterialApp(
      title: 'Conexao', // Consider using AppStrings.appTitle here
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Use AppTheme for light theme
      darkTheme: AppTheme.darkTheme, // Use AppTheme for dark theme
      themeMode: appThemeMode,
      // Removed debug show checkedModeBanner
      home: const HomeScreen(),
    );
  }
}

/// Componente reutilizável para os cards de resumo (not used anymore in HomeContent, but kept for completeness if needed elsewhere)
class _SummaryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 48) / 2,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
