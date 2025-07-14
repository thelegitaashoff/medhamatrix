import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final int _selectedIndex = 4;
    void _onItemTapped(int index) {
      switch (index) {
        case 0:
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          break;
        case 1:
          Navigator.pushNamed(context, '/test');
          break;
        case 2:
          Navigator.pushNamed(context, '/counselling');
          break;
        case 3:
          Navigator.pushNamed(context, '/profile');
          break;
        case 4:
          Navigator.pushNamed(context, '/settings');
          break;
      }
    }
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Text('Settings Page', style: Theme.of(context).textTheme.headlineMedium),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(screenWidth * 0.06)),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.18),
              blurRadius: 16,
              offset: Offset(0, -6),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Test',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups),
              label: 'Counselling',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: colorScheme.onPrimary,
          unselectedItemColor: colorScheme.onPrimary.withOpacity(0.6),
          backgroundColor: Colors.transparent,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
      ),
    );
  }
}
