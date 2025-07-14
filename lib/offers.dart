import 'package:flutter/material.dart';
import 'test.dart';
import 'counselling.dart';
import 'profile.dart';
import 'settings.dart';
import 'dashboard.dart';

class OffersPage extends StatelessWidget {
  static Widget getPageForRoute(String route) {
    switch (route) {
      case '/':
        return const Dashboard();
      case '/test':
        return const TestPage();
      case '/counselling':
        return const CounsellingPage();
      case '/profile':
        return const ProfilePage();
      case '/settings':
        return const SettingsPage();
      default:
        return const OffersPage();
    }
  }
  const OffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final int _selectedIndex = 2;
    void _onItemTapped(int index) {
      String route;
      switch (index) {
        case 0:
          route = '/';
          break;
        case 1:
          route = '/test';
          break;
        case 2:
          route = '/counselling';
          break;
        case 3:
          route = '/profile';
          break;
        case 4:
          route = '/settings';
          break;
        default:
          route = '/';
      }
      if (ModalRoute.of(context)?.settings.name != route) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => OffersPage.getPageForRoute(route),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: Duration(milliseconds: 350),
          ),
        );
      }
    }
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Text('Offers Page', style: Theme.of(context).textTheme.headlineMedium),
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
