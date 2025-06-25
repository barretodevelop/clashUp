import 'package:aplicativo_social/core/providers/theme_provider.dart';
import 'package:aplicativo_social/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:aplicativo_social/features/home/presentation/widgets/home_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0; // Represents the actual index in _pages

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      HomeContent(onNavigateToTab: _navigateToTab),
      const Center(child: Text('Radar de Almas')), // Index 1
      const Center(child: Text('Amigos')), // Index 2
      const Center(child: Text('Comunidades')), // Index 3
      const Center(child: Text('Desafios')), // Index 4
    ];
  }

  /// Maps the BottomNavigationBar's index to the actual page index.
  void _onItemTapped(int navBarIndex) {
    int pageIndex;
    if (navBarIndex == 0) {
      pageIndex = 0; // Home
    } else if (navBarIndex == 1) {
      pageIndex = 2; // Amigos
    } else if (navBarIndex == 2) {
      pageIndex = 3; // Comunidades
    } else if (navBarIndex == 3) {
      pageIndex = 4; // Desafios
    } else {
      pageIndex = 0; // Fallback to Home
    }
    setState(() {
      _selectedIndex = pageIndex;
    });
  }

  /// Navigates to a specific page index directly. Used by HomeContent and FAB.
  void _navigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Maps the actual page index to the BottomNavigationBar's index for highlighting.
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

  void _showThemeSelectionDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Selecionar Tema'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.light_mode),
                title: const Text('Claro'),
                onTap: () {
                  ref.read(appThemeProvider.notifier).setTheme(ThemeMode.light);
                  Navigator.of(dialogContext).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Escuro'),
                onTap: () {
                  ref.read(appThemeProvider.notifier).setTheme(ThemeMode.dark);
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRadarFab() {
    return FloatingActionButton(
      onPressed: () {
        _navigateToTab(1); // Navigate to Radar tab (index 1)
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          16.0,
        ), // Square with rounded corners
      ),
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(
        Icons.radar,
        color: Colors.white,
        size: 30, // Make the icon a bit larger
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onNotificationsPressed: () {}, // Handle notifications
        onPersonPressed: () {
          // Navigate to profile
        },
        onSettingsPressed: _showThemeSelectionDialog,
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: _buildRadarFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getBottomNavIndex(_selectedIndex),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Amigos"),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Comunidades",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: "Desafios"),
        ],
      ),
    );
  }
}
