import 'package:clashup/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:clashup/features/home/presentation/widgets/home_content.dart'; // Ou o otimizado
import 'package:clashup/features/home/presentation/widgets/settings_bottom_sheet.dart';
import 'package:flutter/material.dart'; // Moved import to avoid conflict
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
      HomeContent(
          onNavigateToTab: _navigateToTab), // Ou use OptimizedHomeContent
      const Center(child: Text('Radar de Almas')),
      const Center(child: Text('Amigos')),
      const Center(child: Text('Comunidades')),
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
      appBar: CustomAppBar(
        // Use o novo AppBar
        onNotificationsPressed: () {
          // Handle notifications
        },
        onPersonPressed: () {
          // Navigate to profile
        },
        onSettingsPressed: _showSettingsBottomSheet,
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
