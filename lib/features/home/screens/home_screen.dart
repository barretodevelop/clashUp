// lib/features/home/screens/home_screen.dart - Atualizado com sistema de Comunidades
import 'package:clashup/features/communities/screens/community_list_screen.dart'; // NOVA IMPORTAÇÃO
import 'package:clashup/features/home/widgets/custom_app_bar.dart';
import 'package:clashup/features/home/widgets/home_content.dart';
import 'package:clashup/features/home/widgets/settings_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      HomeContent(onNavigateToTab: _navigateToTab),
      const Center(child: Text('Radar de Almas')),
      const Center(child: Text('Amigos')),
      const CommunityListScreen(), // ✅ NOVA TELA DE COMUNIDADES
      const Center(child: Text('Desafios')),
    ];
  }

  void _onItemTapped(int navBarIndex) {
    int pageIndex;
    if (navBarIndex == 0) {
      pageIndex = 0; // Home
    } else if (navBarIndex == 1) {
      pageIndex = 2; // Amigos
    } else if (navBarIndex == 2) {
      pageIndex = 3; // Comunidades ✅ AGORA CONECTADO À TELA REAL
    } else if (navBarIndex == 3) {
      pageIndex = 4; // Desafios
    } else {
      pageIndex = 0; // Fallback to Home
    }
    setState(() {
      _selectedIndex = pageIndex;
    });
  }

  void _navigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _getBottomNavIndex(int selectedPageIndex) {
    if (selectedPageIndex == 0) {
      return 0; // Home
    } else if (selectedPageIndex == 2) {
      return 1; // Amigos
    } else if (selectedPageIndex == 3) {
      return 2; // Comunidades
    } else if (selectedPageIndex == 4) {
      return 3; // Desafios
    }
    return 0; // If Radar (index 1) or invalid index, highlight Home
  }

  void _showSettingsBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const SettingsBottomSheet();
      },
    );
  }

  Widget _buildRadarFab() {
    final theme = Theme.of(context);

    return FloatingActionButton(
      onPressed: () {
        _navigateToTab(1); // Navigate to Radar tab (index 1)
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      child: const Icon(
        Icons.radar,
        size: 28,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 3
          ? null
          : CustomAppBar(
              // ✅ Não mostrar AppBar na tela de comunidades
              onNotificationsPressed: () {
                // Handle notifications
              },
              onPersonPressed: () {
                // Navigate to profile
              },
              onSettingsPressed: _showSettingsBottomSheet,
            ),
      body: _pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 1
          ? _buildRadarFab()
          : null, // ✅ Só mostrar FAB no Radar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getBottomNavIndex(_selectedIndex),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor:
            Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: "Amigos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            activeIcon: Icon(Icons.groups),
            label: "Comunidades", // ✅ AGORA COM FUNCIONALIDADE REAL
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag_outlined),
            activeIcon: Icon(Icons.flag),
            label: "Desafios",
          ),
        ],
      ),
    );
  }
}

/// Widget personalizado para indicar recursos em desenvolvimento
class _DevelopmentPlaceholder extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _DevelopmentPlaceholder({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 60,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.construction,
                        size: 32,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Em Desenvolvimento',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Esta funcionalidade será implementada em breve!\n'
                        'Fique atento às atualizações.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
