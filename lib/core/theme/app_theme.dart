import 'package:flutter/material.dart';

class AppTheme {
  // Changed to a class with static getters for themes
  // Cores principais mais balanceadas
  static const _primarySeed = Color.fromARGB(223, 87, 6, 116);
  static const _surfaceLight = Color(0xFFF8F9FA);
  static const _surfaceDark = Color(0xFF1A1A1F);
  static const _cardLight = Color(0xFFFFFFFF);
  static const _cardDark = Color(0xFF242429);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primarySeed,
          brightness: Brightness.light,
          surface: _surfaceLight,
          onSurface: const Color(0xFF1C1B1F),
          background: _surfaceLight,
          onBackground: const Color(0xFF1C1B1F),
        ).copyWith(
          primary: _primarySeed,
          onPrimary: Colors.white,
          secondary: const Color(0xFF9C27B0),
          onSecondary: Colors.white,
          tertiary: const Color(0xFF00BCD4),
          onTertiary: Colors.white,
          surface: _cardLight,
          onSurface: const Color(0xFF1C1B1F),
          surfaceVariant: const Color(0xFFF3F4F6),
          onSurfaceVariant: const Color(0xFF49454F),
          outline: const Color(0xFF79747E),
          outlineVariant: const Color(0xFFCAC4D0),
        ),

        scaffoldBackgroundColor: _surfaceLight,

        // Typography com cores adequadas
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: Color(0xFF1C1B1F),
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
            color: Color(0xFF1C1B1F),
          ),
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
            color: Color(0xFF1C1B1F),
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            color: Color(0xFF1C1B1F),
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
            color: Color(0xFF1C1B1F),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.1,
            color: Color(0xFF49454F),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
            color: Color(0xFF49454F),
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
            color: Color(0xFF79747E),
          ),
        ),

        // AppBar com melhor contraste
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF1C1B1F),
          iconTheme: IconThemeData(color: Color(0xFF1C1B1F)),
          titleTextStyle: TextStyle(
            color: Color(0xFF1C1B1F),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        // Cards com contraste adequado
        cardTheme: CardThemeData(
          elevation: 2,
          color: _cardLight,
          shadowColor: const Color(0xFF000000).withOpacity(0.1),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: Color(0xFFE7E0EC),
              width: 1,
            ),
          ),
        ),

        // Botões com estilo claro
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            backgroundColor: _primarySeed,
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFFE8E8E8),
            disabledForegroundColor: const Color(0xFF9E9E9E),
            shadowColor: _primarySeed.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),

        // Navigation bar com cores visíveis
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          backgroundColor: _cardLight,
          selectedItemColor: _primarySeed,
          unselectedItemColor: const Color(0xFF79747E),
          elevation: 8,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C1B1F),
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF79747E),
          ),
        ),

        // Input decoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF3F4F6),
          hintStyle: const TextStyle(color: Color(0xFF79747E)),
          labelStyle: const TextStyle(color: Color(0xFF49454F)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE7E0EC)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFE7E0EC),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: _primarySeed,
              width: 2,
            ),
          ),
        ),

        // Chip theme
        chipTheme: ChipThemeData(
          backgroundColor: _primarySeed.withOpacity(0.12),
          selectedColor: _primarySeed,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1C1B1F),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide.none,
        ),

        // Icon theme
        iconTheme: const IconThemeData(
          color: Color(0xFF49454F),
          size: 24,
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primarySeed,
          brightness: Brightness.dark,
          surface: _cardDark,
          onSurface: const Color(0xFFE6E1E5),
          background: _surfaceDark,
          onBackground: const Color(0xFFE6E1E5),
        ).copyWith(
          primary: const Color(0xFF7F87FF),
          onPrimary: const Color(0xFF000000),
          secondary: const Color(0xFFD1BADB),
          onSecondary: const Color(0xFF3B2948),
          tertiary: const Color(0xFF9DCFDF),
          onTertiary: const Color(0xFF003544),
          surface: _cardDark,
          onSurface: const Color(0xFFE6E1E5),
          surfaceVariant: const Color(0xFF49454F),
          onSurfaceVariant: const Color(0xFFCAC4D0),
          outline: const Color(0xFF938F99),
          outlineVariant: const Color(0xFF49454F),
        ),

        scaffoldBackgroundColor: _surfaceDark,

        // Typography para dark mode com cores claras
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: Color(0xFFE6E1E5),
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
            color: Color(0xFFE6E1E5),
          ),
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
            color: Color(0xFFE6E1E5),
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            color: Color(0xFFE6E1E5),
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
            color: Color(0xFFE6E1E5),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.1,
            color: Color(0xFFCAC4D0),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
            color: Color(0xFFCAC4D0),
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
            color: Color(0xFF938F99),
          ),
        ),

        // AppBar para dark mode com ícones visíveis
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFFE6E1E5),
          iconTheme: IconThemeData(color: Color(0xFFE6E1E5)),
          titleTextStyle: TextStyle(
            color: Color(0xFFE6E1E5),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        // Cards para dark mode
        cardTheme: CardThemeData(
          elevation: 4,
          color: _cardDark,
          shadowColor: const Color(0xFF000000).withOpacity(0.5),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: Color(0xFF49454F),
              width: 1,
            ),
          ),
        ),

        // Botões para dark mode
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 4,
            backgroundColor: const Color(0xFF7F87FF),
            foregroundColor: const Color(0xFF000000),
            disabledBackgroundColor: const Color(0xFF3C3C3C),
            disabledForegroundColor: const Color(0xFF6C6C6C),
            shadowColor: const Color(0xFF7F87FF).withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),

        // Navigation bar para dark mode
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          backgroundColor: _cardDark,
          selectedItemColor: Color(0xFF7F87FF),
          unselectedItemColor: Color(0xFF938F99),
          elevation: 8,
          selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE6E1E5),
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF938F99),
          ),
        ),

        // Input decoration para dark mode
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF36343B),
          hintStyle: const TextStyle(color: Color(0xFF938F99)),
          labelStyle: const TextStyle(color: Color(0xFFCAC4D0)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF49454F)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF49454F),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF7F87FF),
              width: 2,
            ),
          ),
        ),

        // Chip theme para dark mode
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF7F87FF).withOpacity(0.24),
          selectedColor: const Color(0xFF7F87FF),
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFFE6E1E5),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide.none,
        ),

        // Icon theme para dark mode
        iconTheme: const IconThemeData(
          color: Color(0xFFCAC4D0),
          size: 24,
        ),
      );
}
