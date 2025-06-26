import 'package:clashup/core/router/app_router.dart';
import 'package:clashup/core/theme/app_theme.dart';
import 'package:clashup/core/utils/logger.dart';
import 'package:clashup/features/user/providers/user_provider.dart';
import 'package:clashup/providers/auth_provider.dart';
import 'package:clashup/providers/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClashUp extends ConsumerWidget {
  const ClashUp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode appThemeMode = ref.watch(appThemeProvider);

    return MaterialApp.router(
      title: 'ClashUp', // Hardcoded for now, consider AppStrings.appTitle
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme.copyWith(
        scaffoldBackgroundColor: Colors.transparent, // CHAVE: Transparente
      ),
      darkTheme: AppTheme.darkTheme.copyWith(
        scaffoldBackgroundColor: Colors.transparent, // CHAVE: Transparente
      ),
      themeMode: appThemeMode,

      // ========== 🎯 SISTEMA DE NAVEGAÇÃO SIMPLIFICADO ==========
      routerConfig: AppRouter.createRouter(ref),
      builder: (context, child) {
        return _AppBuilder(child: child);
      },
    );
  }
}

/// ✅ Builder com error handling e overlays
class _AppBuilder extends ConsumerWidget {
  final Widget? child;

  const _AppBuilder({this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeProvider);
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    // This Container applies the global gradient background to the entire app.
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  const Color.fromARGB(255, 18, 15, 20), // Very dark top
                  const Color.fromARGB(255, 30, 26, 31), // Dark mid
                  const Color.fromARGB(255, 40, 36, 41), // Dark base
                ]
              : [
                  const Color.fromARGB(255, 237, 235, 238), // Very light top
                  const Color(0xFFF1F5F9), // Light mid
                  const Color(0xFFE2E8F0), // Bluish base
                ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: GestureDetector(
        // ✅ Fechar teclado ao tocar fora
        onTap: () {
          final currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild!.unfocus();
          }
        },
        child: Stack(
          children: [
            // ✅ App principal
            child ?? const _EmergencyScreen(),
            // ✅ Debug overlay apenas em desenvolvimento
            if (kDebugMode) ...[
              // const Positioned(top: 100, right: 10, child: _DebugOverlay()),
            ],
          ],
        ),
      ),
    );
  }
}

/// ✅ Debug overlay simplificado
class _DebugOverlay extends ConsumerWidget {
  const _DebugOverlay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Changed to ConsumerWidget
    final authState = ref.watch(authProvider);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'DEBUG',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
          Text(
            'Auth: ${authState.isAuthenticated ? "✅" : "❌"}',
            style: const TextStyle(color: Colors.green, fontSize: 10),
          ),
          Text(
            'Loading: ${authState.isLoading ? "⏳" : "✅"}',
            style: const TextStyle(color: Colors.yellow, fontSize: 10),
          ),
          Text(
            'Onboarding: ${authState.isAuthenticated && ref.watch(userProvider)?.needsOnboarding == true ? "📝" : "✅"}', // Check UserProvider for onboarding
            style: const TextStyle(color: Colors.blue, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

/// ✅ Tela de emergência para casos críticos
class _EmergencyScreen extends StatelessWidget {
  const _EmergencyScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 64,
                color: Colors.red.shade600,
              ),
              const SizedBox(height: 16),
              Text(
                'Erro Crítico',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'O sistema de navegação falhou. '
                'Reinicie o aplicativo.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.red.shade700),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Tentar recriar o app
                  AppLogger.error('🚨 Emergency restart requested');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Reiniciar App'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
