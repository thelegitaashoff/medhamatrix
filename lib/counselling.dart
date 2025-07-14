// ignore_for_file: deprecated_member_use, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'profile.dart';
import 'settings.dart';
import 'test.dart';
import 'dashboard.dart';

class CounsellingPage extends StatelessWidget {
  const CounsellingPage({super.key});

  Widget _buildCard(BuildContext context, String title, {Widget? icon, VoidCallback? onTap}) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    Color boxColor;
    Color textColor;
    switch (title) {
      case 'Student Counseling':
        boxColor = Color(0xFFC8E6C9); // Light Green
        textColor = Color(0xFF388E3C); // Green
        break;
      case 'Parent Counseling':
        boxColor = Color(0xFFFFF9C4); // Light Yellow
        textColor = Color(0xFFF9A825); // Amber
        break;
      case 'Career Sector Counseling':
        boxColor = Color(0xFFFFCCBC); // Light Orange
        textColor = Color(0xFFD84315); // Deep Orange
        break;
      default:
        boxColor = colorScheme.surface;
        textColor = colorScheme.onSurface;
    }
    Color iconBgColor = boxColor;
    Color iconColor = textColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          border: Border.all(color: colorScheme.outline, width: screenWidth * 0.005),
          boxShadow: [
            BoxShadow(
              color: boxColor.withOpacity(0.28),
              blurRadius: screenWidth * 0.055,
              offset: Offset(0, screenHeight * 0.012),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.12),
              blurRadius: screenWidth * 0.015,
              offset: Offset(-screenWidth * 0.01, -screenHeight * 0.006),
            ),
          ],
        ),
        padding: EdgeInsets.all(screenWidth * 0.04),
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.03),
        child: Row(
          children: [
            if (icon != null)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconBgColor,
                  boxShadow: [
                    BoxShadow(
                      color: iconBgColor.withOpacity(0.45),
                      blurRadius: screenWidth * 0.045,
                      offset: Offset(0, screenHeight * 0.012),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.18),
                      blurRadius: screenWidth * 0.011,
                      offset: Offset(-screenWidth * 0.005, -screenHeight * 0.005),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(screenWidth * 0.015),
                child: IconTheme(
                  data: IconThemeData(size: screenWidth * 0.14, color: iconColor),
                  child: icon,
                ),
              ),
            SizedBox(width: screenWidth * 0.045),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontSize: screenWidth * 0.048,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


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
      appBar: AppBar(
        title: Text('Counselling'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 12),
        children: [
          _buildCard(
            context,
            'Student Counseling',
            icon: Icon(Icons.school, color: colorScheme.primary),
            onTap: () {
              Navigator.pushNamed(context, '/payment', arguments: {'courseName': 'Student Counseling', 'price': '\$100'});
            },
          ),
          _buildCard(
            context,
            'Parent Counseling',
            icon: Icon(Icons.family_restroom, color: colorScheme.primary),
            onTap: () {
              Navigator.pushNamed(context, '/payment', arguments: {'courseName': 'Parent Counseling', 'price': '\$100'});
            },
          ),
          _buildCard(
            context,
            'Career Sector Counseling',
            icon: Icon(Icons.work, color: colorScheme.primary),
            onTap: () {
              Navigator.pushNamed(context, '/payment', arguments: {'courseName': 'Career Sector Counseling', 'price': '\$100'});
            },
          ),
        ],
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

