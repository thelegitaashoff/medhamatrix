import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'counselling.dart';
import 'profile.dart';
import 'settings.dart';
import 'test.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  final List<Widget> _contentPages = [
    SizedBox.shrink(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final width = constraints.maxWidth;

          double h(double val) => height * val / 817; // base height from original design
          double w(double val) => width * val / 400; // base width from original design

          return Stack(
            children: [
              Container(
                height: height,
                width: width,
                color: Colors.white,
                child: Column(
                  children: [
                    // Header Section
                    _buildHeaderSection(h, w),

                    // Navigation Indicators Row
                    _buildNavigationIndicators(h, w),

                    // Main Content Cards Row
                    Expanded(
                      child: Column(
                        children: [
                          _buildMainContentCards(h, w, context),
                          SizedBox(height: h(2)),
                          _buildBottomContentCards(h, w, context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildBottomNavigationBar(h, w),
            ],
          );
  }
      ),
    );
  }

  Widget _buildHeaderSection(double Function(double) h, double Function(double) w) {
    return Container(
      height: h(239),
      width: w(400),
      color: Color(0xFFFFD9D9),
      child: Stack(
        children: [
          Positioned(
            top: h(89),
            left: w(43),
            child: Text(
              'welcome',
              style: TextStyle(
                fontSize: h(40),
                height: 1.225,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationIndicators(double Function(double) h, double Function(double) w) {
    final indicatorCount = 4;
    final indicatorSize = w(64);

    // List of image paths for each indicator
    final List<String> imagePaths = [
      'assets/icons/IQ_test.png',
      'assets/icons/student_counseling.png',
      'assets/icons/parent_counseling.png',
      'assets/icons/our_team.png',
    ];

    // Text labels for each indicator as two lines
    final List<List<String>> labels = [
      ['IQ', 'TEST'],
      ['Student', 'Counseling'],
      ['Parent', 'Counseling'],
      ['Our', 'Team'],
    ];

    return Container(
      margin: EdgeInsets.only(top: h(11), left: w(21), right: w(21)),
      height: h(95),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(indicatorCount, (index) {
          return Flexible(
            child: GestureDetector(
              onTap: () {
                switch (index) {
                  case 0:
                    Navigator.of(context).pushNamed('/test');
                    break;
                  case 1:
                    Navigator.of(context).pushNamed('/counselling');
                    break;
                  case 2:
                    Navigator.of(context).pushNamed('/parent_counselling');
                    break;
                  case 3:
                    Navigator.of(context).pushNamed('/about');
                    break;
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: indicatorSize,
                    height: indicatorSize,
                    child: _buildNavigationIndicator(indicatorSize, imagePaths[index], false),
                  ),
                  SizedBox(height: h(4)),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          labels[index][0],
                          style: TextStyle(
                            fontSize: w(10),
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        Text(
                          labels[index][1],
                          style: TextStyle(
                            fontSize: w(10),
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNavigationIndicator(double size, String imagePath, bool isSelected) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(66, 70, 69, 69),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
        border: null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: size,
          height: size,
        ),
      ),
    );
  }

  Widget _buildMainContentCards(double Function(double) h, double Function(double) w, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: h(20), left: w(16)),
      height: h(229),
      width: w(371),
      child: Row(
        children: [
          // Large Gradient Card
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/test');
            },
            child: Container(
              height: h(229),
              width: w(164),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(h(18)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(237, 6, 247, 179),
                    Color.fromARGB(250, 57, 201, 245),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                  child: Text(
                    'IQ Test',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: h(22),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                    textAlign: TextAlign.center,
                  ),
              ),
            ),
          ),
          SizedBox(width: w(20)),
          // Right Column Cards
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/counselling');
                },
                child: Container(
                  height: h(101),
                  width: w(187),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(h(18)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                      child: Text(
                        'Counseling',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: h(22),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ),
                ),
              ),
              SizedBox(height: h(24)),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/payment_history');
                },
                child: Container(
                  height: h(101),
                  width: w(187),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(h(18)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                      child: Text(
                        'Payment History',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: h(22),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomContentCards(double Function(double) h, double Function(double) w, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: h(20), left: w(21)),
      height: h(101),
      width: w(366),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/offers');
            },
            child: Container(
              height: h(101),
              width: w(164),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(h(18)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                  child: Text(
                    'Offers',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: h(22),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                    textAlign: TextAlign.center,
                  ),
              ),
            ),
          ),
          SizedBox(width: w(15)),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/about');
            },
            child: Container(
              height: h(101),
              width: w(187),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(h(18)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                  child: Text(
                    'About Us',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: h(22),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                    textAlign: TextAlign.center,
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(double Function(double) h, double Function(double) w) {
    final List<String> imagePaths = [
      'assets/icons/home.png',
      'assets/icons/student_counseling.png',
      'assets/icons/our_team.png',
    ];

    final List<String> labels = [
      'Home',
      'Counseling',
      'Our Team',
    ];

    return Positioned(
      bottom: h(5),
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: true,
        child: Container(
          margin: EdgeInsets.only(left: w(10), right: w(10), bottom: h(0)),
          constraints: BoxConstraints(
            maxHeight: h(80),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(h(25)),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF6EFF7D),
                
              ],
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                return Container(
                  margin: EdgeInsets.only(bottom: h(10)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: h(48),
                        height: h(48),
                        child: _buildBottomNavigationItem(h(48), imagePaths[index]),
                      ),
                      SizedBox(height: h(5)),
                      Text(
                        labels[index],
                        style: TextStyle(
                          fontSize: w(12),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationItem(double size, String imagePath) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: size,
          height: size,
        ),
      ),
    );
  }
}
