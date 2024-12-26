import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';
import '../screens/home_screen.dart';
import '../screens/shop_screen.dart';

import '../screens/mydbn_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    // const MatchesScreen(),
    const ShopScreen(),
    const MyDBNScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 0 ? Icons.home : Icons.home_outlined,
              weight: 0.5,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 1 ? Icons.sports_soccer : Icons.sports_soccer_outlined,
              weight: 0.5,
            ),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 2 ? Icons.shopping_bag : Icons.shopping_bag_outlined,
              weight: 0.5,
            ),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 3 ? Icons.person : Icons.person_outline,
              weight: 0.5,
            ),
            label: 'MyDBN',
          ),
        ],
        backgroundColor: AppColors.primaryBlue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withAlpha(153),
        showUnselectedLabels: true,
      ),
    );
  }
}
