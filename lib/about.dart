// ignore_for_file: no_leading_underscores_for_local_identifiers, deprecated_member_use

import 'package:flutter/material.dart';
import 'counselling.dart';
import 'profile.dart';
import 'settings.dart';
import 'test.dart';
import 'dashboard.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final int _selectedIndex = 3;
    void _onItemTapped(int index) {
      String route;
      switch (index) {
        case 0:
          route = '/';
          break;
        case 1:
          route = '/notifications';
          break;
        case 2:
          route = '/payment';
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
            pageBuilder: (context, animation, secondaryAnimation) {
              switch (route) {
                case '/counselling':
                  return CounsellingPage();
                case '/profile':
                  return ProfilePage();
                case '/settings':
                  return SettingsPage();
                case '/test':
                  return TestPage();
                default:
                  return Dashboard();
              }
            },
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
        child: Text('About Us Page', style: Theme.of(context).textTheme.headlineMedium),
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
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.payment),
              label: 'Payment History',
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
