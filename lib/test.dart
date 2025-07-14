// ignore_for_file: deprecated_member_use, no_leading_underscores_for_local_identifiers, use_super_parameters

import 'package:flutter/material.dart';
import 'counselling.dart';
import 'profile.dart';
import 'settings.dart';
import 'dashboard.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  Widget _buildCard(
    BuildContext context,
    String title,
    String subtitle, {
    Widget? icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    Color boxColor;
    Color textColor;
    Color subtitleColor;
    switch (title) {
      case 'IQ Test':
        boxColor = Color(0xFFE1F5FE); // Light Blue
        textColor = Color.fromARGB(255, 248, 27, 27);
        subtitleColor = Color.fromARGB(255, 209, 2, 2);
        break;
      case 'Personality Test':
        boxColor = Color(0xFFFFF9C4); // Light Yellow
        textColor = Color(0xFF01579B);
        subtitleColor = Color(0xFF01579B);
        break;
      default:
        boxColor = colorScheme.surface;
        textColor = colorScheme.onSurface;
        subtitleColor = colorScheme.onSurfaceVariant;
    }
    Color iconBgColor = boxColor;
    Color iconColor = textColor;
    switch (title) {
      case 'IQ Test':
        iconBgColor = Color(0xFFE1F5FE);
        iconColor = Color(0xFF01579B);
        break;
      case 'Personality Test':
        iconBgColor = Color(0xFFFFF9C4);
        iconColor = Color(0xFFF9A825);
        break;
      default:
        iconBgColor = colorScheme.surface;
        iconColor = colorScheme.primary;
    }
    return Container(
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        border: Border.all(
          color: colorScheme.outline,
          width: screenWidth * 0.005,
        ),
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
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontSize: 18,
                  ),
                ),
              ),
              if (icon != null)
                _HoverIconContainer(
                  iconBgColor: iconBgColor,
                  iconColor: iconColor,
                  child: icon,
                ),
            ],
          ),
          if (subtitle.isNotEmpty) ...[
            SizedBox(height: 10),
            Flexible(
              child: Text(
                subtitle,
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                maxLines: null,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    final int _selectedIndex = 1;
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
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: Duration(milliseconds: 350),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('Tests'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.03),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('🧠 IQ Test Prep'),
                      content: Text(
                        '৹ Answer all 50 questions\n\n'
                        '৹ Each question is has one correct option\n\n'
                        '৹ You have 15 minutes to complete the test\n\n'
                        '৹ Do not use external tools\n\n'
                        '৹ Tap Start to begin the IQ test\n\n'
                        '➡️',
                        style: TextStyle(fontSize: screenWidth * 0.045),
                      ),
                      actions: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 18,
                              ),
                              elevation: 3,
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.045,
                              ),
                            ),
                            icon: Icon(
                              Icons.play_arrow,
                              size: screenWidth * 0.06,
                            ),
                            label: Text('Start'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.pushNamed(
                                context,
                                '/payment',
                                arguments: {
                                  'courseName': 'IQ Test',
                                  'price': '0',
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: _buildCard(
                  context,
                  'IQ Test',
                  'Test your IQ level',
                  icon: Icon(Icons.psychology, color: colorScheme.primary),
                ),
              ),
              SizedBox(height: screenWidth * 0.03),
              _buildCard(
                context,
                'Personality Test',
                'Discover your personality traits',
                icon: Icon(Icons.person, color: colorScheme.primary),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(screenWidth * 0.06),
          ),
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
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
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

class _HoverIconContainer extends StatefulWidget {
  final Color iconBgColor;
  final Color iconColor;
  final Widget child;

  const _HoverIconContainer({
    Key? key,
    required this.iconBgColor,
    required this.iconColor,
    required this.child,
  }) : super(key: key);

  @override
  State<_HoverIconContainer> createState() => _HoverIconContainerState();
}

class _HoverIconContainerState extends State<_HoverIconContainer> {
  bool _isHovered = false;

  void _onEnter(PointerEvent event) {
    setState(() {
      _isHovered = true;
    });
  }

  void _onExit(PointerEvent event) {
    setState(() {
      _isHovered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isHovered ? widget.iconColor : widget.iconBgColor;
    final iconColor = _isHovered ? widget.iconBgColor : widget.iconColor;

    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconTheme(
          data: IconThemeData(color: iconColor),
          child: widget.child,
        ),
      ),
    );
  }
}
