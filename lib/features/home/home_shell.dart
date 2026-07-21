import 'package:flutter/material.dart';

import '../../core/theme.dart';
import 'home_feed_screen.dart';
import '../matches/matches_screen.dart';
import '../profile/profile_screen.dart';
import '../add_pet/add_pet_screen.dart';
import '../explore/explore_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _idx = 0;

  final _pages = const [
    HomeFeedScreen(),
    MatchesScreen(),
    AddPetScreen(),
    ExploreScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _idx, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        onDestinationSelected: (i) => setState(() => _idx = i),
        indicatorColor: AppColors.primaryContainer.withValues(alpha: 0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(
              Icons.explore,
              color: AppColors.primaryContainer,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(
              Icons.favorite,
              color: AppColors.primaryContainer,
            ),
            label: 'Matches',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(
              Icons.add_circle,
              color: AppColors.primaryContainer,
            ),
            label: 'Add Pet',
          ),
          NavigationDestination(
            icon: Icon(Icons.home_work_outlined),
            selectedIcon: Icon(
              Icons.home_work,
              color: AppColors.primaryContainer,
            ),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.primaryContainer),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
