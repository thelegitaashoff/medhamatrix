// ignore_for_file: unused_local_variable, deprecated_member_use, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'counselling.dart';
import 'profile.dart';
import 'test.dart';
import 'dashboard.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Widget _buildCard(BuildContext context, String title, {Widget? icon}) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    Color boxColor = colorScheme.surface;
    Color textColor = colorScheme.onSurface;
    Color subtitleColor = colorScheme.onSurfaceVariant;
    Color iconBgColor = boxColor;
    Color iconColor = textColor;

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontSize: 18)),
              ),
              if (icon != null)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconBgColor,
                    boxShadow: [
                      BoxShadow(
                        color: iconBgColor.withOpacity(0.45),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.18),
                        blurRadius: 4,
                        offset: Offset(-2, -2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(6),
                  child: IconTheme(
                    data: IconThemeData(size: 54, color: iconColor),
                    child: icon,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    final int _selectedIndex = 4;
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
        title: Text('Settings'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.03),
          child: Column(
            children: [
              _buildCard(context, 'Privacy', icon: Icon(Icons.lock, color: colorScheme.primary)),
              SizedBox(height: screenWidth * 0.03),
              _buildCard(context, 'Theme', icon: Icon(Icons.palette, color: colorScheme.primary)),
              SizedBox(height: screenWidth * 0.03),
              _buildCard(context, 'Language', icon: Icon(Icons.language, color: colorScheme.primary)),
              SizedBox(height: screenWidth * 0.03),
              _buildCard(context, 'About', icon: Icon(Icons.info_outline, color: colorScheme.primary)),
            ],
          ),
        ),
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
