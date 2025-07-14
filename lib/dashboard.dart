import 'package:flutter/material.dart';
import 'test.dart';
import 'counselling.dart';
import 'profile.dart';
import 'settings.dart';
import 'dart:math' as math;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  Widget _getPageForRoute(String route) {
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
        return const Dashboard();
    }
  }
  late AnimationController _controller;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
          pageBuilder: (context, animation, secondaryAnimation) => _getPageForRoute(route),
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

  // Removed duplicate _getPageForRoute and misplaced closing brace

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildIconButton(BuildContext context, IconData icon, String label, {bool animate = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    Widget iconWidget = Icon(icon, size: screenWidth * 0.09, color: colorScheme.primary);

    if (animate) {
      iconWidget = AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final double angle = _controller.value * 2 * math.pi;
          final double radius = screenWidth * 0.02;
          final double dx = radius * math.cos(angle);
          final double dy = radius * math.sin(angle);
          return Transform.translate(
            offset: Offset(dx, dy),
            child: child,
          );
        },
        child: iconWidget,
      );
    }

    return SizedBox(
      width: screenWidth * 0.28,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: screenWidth * 0.08,
            backgroundColor: colorScheme.surface,
            child: iconWidget,
          ),
          SizedBox(height: screenHeight * 0.012),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: screenWidth * 0.045, color: colorScheme.onSurface, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String subtitle, {Widget? icon}) {
    final colorScheme = Theme.of(context).colorScheme;
    Color boxColor;
    Color textColor;
    Color subtitleColor;
    switch (title) {
      case 'Tests':
        boxColor = Color(0xFFE1F5FE);
        textColor = Color(0xFF01579B);
        subtitleColor = Color(0xFF0288D1);
        break;
      case 'Offers':
        boxColor = Color(0xFFFFF9C4);
        textColor = Color(0xFFF9A825);
        subtitleColor = Color(0xFFFFC107);
        break;
      case 'Payment history / profile':
        boxColor = Color(0xFFC8E6C9);
        textColor = Color(0xFF388E3C);
        subtitleColor = Color(0xFF43A047);
        break;
      case 'Counselling':
        boxColor = Color(0xFFFFCCBC);
        textColor = Color(0xFFD84315);
        subtitleColor = Color(0xFFFF7043);
        break;
      case 'About Us':
        boxColor = Color(0xFFD1C4E9);
        textColor = Color(0xFF512DA8);
        subtitleColor = Color(0xFF7E57C2);
        break;
      default:
        boxColor = colorScheme.surface;
        textColor = colorScheme.onSurface;
        subtitleColor = colorScheme.onSurfaceVariant;
    }
    Color iconBgColor = boxColor;
    Color iconColor = textColor;
    switch (title) {
      case 'Tests':
        iconBgColor = Color(0xFFE1F5FE);
        iconColor = Color(0xFF01579B);
        break;
      case 'Offers':
        iconBgColor = Color(0xFFFFF9C4);
        iconColor = Color(0xFFF9A825);
        break;
      case 'Payment history / profile':
        iconBgColor = Color(0xFFC8E6C9);
        iconColor = Color(0xFF388E3C);
        break;
      case 'Counselling':
        iconBgColor = Color(0xFFFFCCBC);
        iconColor = Color(0xFFD84315);
        break;
      case 'About Us':
        iconBgColor = Color(0xFFD1C4E9);
        iconColor = Color(0xFF512DA8);
        break;
      default:
        iconBgColor = colorScheme.surface;
        iconColor = colorScheme.primary;
    }
    bool isCounselling = title == 'Counselling';
    void navigate() {
      if (title == 'Tests') {
        Navigator.pushNamed(context, '/test');
      } else if (title == 'Counselling') {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => CounsellingPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: Duration(milliseconds: 350),
          ),
        );
      } else if (title == 'Payment history / profile') {
        Navigator.pushNamed(context, '/profile');
      } else if (title == 'About Us') {
        Navigator.pushNamed(context, '/profile');
      } else if (title == 'Offers') {
        Navigator.pushNamed(context, '/offers');
      }
    }
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    return GestureDetector(
      onTap: navigate,
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
                          fontSize: screenWidth * 0.048)),
                ),
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
              ],
            ),
            if (subtitle.isNotEmpty) ...[
              SizedBox(height: isCounselling ? screenHeight * 0.008 : screenHeight * 0.014),
              isCounselling
                        ? Center(
                            child: SizedBox(
                              height: screenHeight * 0.05,
                              child: Text(
                                subtitle,
                                style: TextStyle(
                                  color: subtitleColor,
                                  fontSize: screenWidth * 0.032,
                                  fontWeight: FontWeight.w500,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                  : Flexible(
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: screenWidth * 0.038,
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: null,
                        overflow: TextOverflow.visible,
                      ),
                    ),
            ]
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
    final screenHeight = mediaQuery.size.height;
    final List<Widget> sliderItems = [
      Container(
        color: colorScheme.primaryContainer,
        child: Center(
          child: Text(
            'Welcome!',
            style: TextStyle(
              fontSize: screenWidth * 0.07,
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Container(
        color: colorScheme.primaryContainer,
        child: Center(
          child: Text(
            'Discover Features',
            style: TextStyle(
              fontSize: screenWidth * 0.07,
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Container(
        color: colorScheme.primaryContainer,
        child: Center(
          child: Text(
            'Get Started!',
            style: TextStyle(
              fontSize: screenWidth * 0.07,
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ];
    return Scaffold(
      backgroundColor: colorScheme.surface,
      // Top nav bar removed
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double sliderHeight = constraints.maxHeight * 0.25;
          final double gridSpacing = constraints.maxWidth * 0.025;
          final double cardHeight = ((constraints.maxHeight - gridSpacing * 2) / 2) * 0.5;
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: sliderHeight,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: sliderItems.length,
                        onPageChanged: (index) => setState(() => _currentPage = index),
                        itemBuilder: (context, index) => sliderItems[index],
                      ),
                      Positioned(
                        bottom: sliderHeight * 0.075,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(sliderItems.length, (index) {
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(horizontal: gridSpacing * 0.15),
                              width: _currentPage == index ? sliderHeight * 0.1125 : sliderHeight * 0.05,
                              height: sliderHeight * 0.05,
                              decoration: BoxDecoration(
                                color: _currentPage == index ? colorScheme.primary : colorScheme.outline,
                                borderRadius: BorderRadius.circular(sliderHeight * 0.025),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: sliderHeight * 0.075),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  padding: EdgeInsets.symmetric(vertical: sliderHeight * 0.0625, horizontal: screenWidth * 0.01),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: screenWidth * 0.005, bottom: sliderHeight * 0.0375),
                          child: Text(
                            'Test & Counselling',
                            style: TextStyle(
                              color: Color(0xFF01579B),
                              fontWeight: FontWeight.w700,
                              fontSize: screenWidth * 0.042,
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('🧠 IQ Test Prep'),
                                      content: Text(
                                        '৹ Answer all 50 questions\n\n'
                                        '৹ Each question is has one correct option\n\n'
                                        '৹ You have 15 minutes to complete the test\n\n'
                                        '৹ Do not use external tools\n\n'
                                        '৹ Tap Start to begin the IQ test\n\n',
                                        style: TextStyle(fontSize: screenWidth * 0.04),
                                      ),
                                      actions: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context).colorScheme.primary,
                                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                                              elevation: 3,
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: screenWidth * 0.045,
                                              ),
                                            ),
                                            icon: Icon(Icons.play_arrow, size: screenWidth * 0.06),
                                            label: Text('Start'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.pushNamed(context, '/payment', arguments: {'courseName': 'IQ Test', 'price': '0'});
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: _buildIconButton(context, Icons.psychology, 'IQ Test'),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/payment', arguments: {'courseName': 'Student Counseling', 'price': '0'});
                                },
                                child: _buildIconButton(context, Icons.school, 'Student Counselling'),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/payment', arguments: {'courseName': 'Parent Counseling', 'price': '0'});
                                },
                                child: _buildIconButton(context, Icons.family_restroom, 'Parent Counselling'),
                              ),
                              _buildIconButton(context, Icons.group, 'Our Team'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: gridSpacing),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/test');
                                  },
                                  child: SizedBox(
                                    height: cardHeight * 1.5 + gridSpacing,
                                    child: _buildCard(context, 'Tests', 'IQ , Personality', icon: Icon(Icons.person, color: colorScheme.primary)),
                                  ),
                                ),
                                SizedBox(height: gridSpacing),
                                SizedBox(
                                  height: cardHeight * 0.7 + gridSpacing,
                                  child: _buildCard(context, 'Offers', '', icon: Icon(Icons.card_giftcard, color: colorScheme.primary)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: gridSpacing),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: cardHeight * 0.7 + gridSpacing,
                                  child: _buildCard(context, 'Counselling','' , icon: Icon(Icons.groups, color: colorScheme.primary)),
                                ),
                                SizedBox(height: gridSpacing),
                                SizedBox(
                                  height: cardHeight * 0.7 + gridSpacing,
                                  child: _buildCard(context, 'Payment history / profile', '', icon: Icon(Icons.account_balance_wallet, color: colorScheme.primary)),
                                ),
                                SizedBox(height: gridSpacing),
                                SizedBox(
                                  height: cardHeight * 0.7 + gridSpacing,
                                  child: _buildCard(context, 'About Us', '', icon: Icon(Icons.info_outline, color: colorScheme.primary)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
