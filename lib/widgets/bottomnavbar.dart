import 'package:chawi_hotel/screens/search_screen.dart';
import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../utils/constants/colors.dart';

class Bottomnavscreen extends StatefulWidget {
  const Bottomnavscreen({super.key});

  @override
  State<Bottomnavscreen> createState() => _BottomnavscreenState();
}

class _BottomnavscreenState extends State<Bottomnavscreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [HomeScreen(), SearchScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 8,
        backgroundColor: const Color.fromARGB(157, 2, 58, 44),
        unselectedItemColor: AppColors.primary,
        selectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.hotel), label: 'Search')
        ],
      ),
    );
  }
}
