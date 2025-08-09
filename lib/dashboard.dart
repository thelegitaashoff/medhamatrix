import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'counselling.dart';
import 'profile.dart';
import 'settings.dart';
import 'test.dart';
import 'payment.dart';
import 'certificate_download.dart';
import 'password_recovery_screen.dart';
import 'dart:async';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  String userName = "Therese Webb";

  late final PageController _pageController;
  int _currentPage = 0;
  final int _numPages = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });

    _timer = Timer.periodic(Duration(seconds: 10), (Timer timer) {
      int nextPage = _currentPage + 1;
      if (nextPage >= _numPages) {
        nextPage = 0;
      }
      _pageController.animateToPage(
        nextPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 0 || index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => EditableProfilePage()),
      );
    } else if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SettingsPage(userName: userName)),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  final List<Widget> _contentPages = [
    SizedBox.shrink(),
  ];

  Color _getIconColor() {
    // Example logic: change icon color based on first letter of userName
    if (userName.isNotEmpty) {
      switch (userName[0].toLowerCase()) {
        case 'a':
        case 'b':
        case 'c':
          return Colors.red;
        case 'd':
        case 'e':
        case 'f':
          return Colors.green;
        case 'g':
        case 'h':
        case 'i':
          return Colors.blue;
        default:
          return Colors.black87;
      }
    }
    return Colors.black87;
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _getIconColor();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 224, 248, 255),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 224, 248, 255),
        child: SafeArea(
          child: Column(
            children: [
              // Optional: Add branding or logo at the top
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icons/app_logo.jpg',
                          fit: BoxFit.cover,
                          width: 48,
                          height: 48,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Medhamatrics",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    _drawerItem(Icons.home, "Home", iconColor, () {
                      Navigator.of(context).pop();
                      // Navigate to home or dashboard page
                    }),
                    _drawerItem(Icons.payment, "Payment", iconColor, () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => PaymentPage()),
                      );
                    }),
                    // Removed Report menu item as requested
                    _drawerItem(Icons.folder, "Download Certificates", iconColor, () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CertificateDownloadPage()),
                      );
                      // Add navigation for Download Certificates page if exists
                    }),
                    _drawerItem(Icons.settings, "Settings", iconColor, () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SettingsPage(userName: userName)),
                      );
                    }),
                    //_drawerItem(Icons.login, "Login", iconColor, () {
                    //  Navigator.of(context).pop();
                    //  Navigator.of(context).push(
                    //    MaterialPageRoute(builder: (context) => LoginPage()),
                    //  );
                    //}),
                    //_drawerItem(Icons.app_registration, "Sign Up", iconColor, () {
                    //  Navigator.of(context).pop();
                    //  Navigator.of(context).push(
                    //    MaterialPageRoute(builder: (context) => SignUpScreen()),
                    //  );
                    //}),
                    //_drawerItem(Icons.password, "Password Recovery", iconColor, () {
                    //  Navigator.of(context).pop();
                    //  Navigator.of(context).push(
                    //    MaterialPageRoute(builder: (context) => PasswordRecoveryScreen()),
                    //  );
                    //}),
                    _drawerItem(Icons.logout, "Log Out", iconColor, () {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Logout'),
                          content: Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                // Implement logout logic: navigate to login screen and clear navigation stack
                                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                              },
                              child: Text('Logout'),
                            ),
                          ],
                        ),
                      );
                      // Add logout functionality
                    }),
                  ],
                ),
              ),
              const Divider(),
              // User profile at the bottom
              ListTile(
                leading: CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                      "https://api.multiavatar.com/theresewebb.png"),
                ),
                title: Text(userName),
                subtitle: Text("UK Researcher"),
                onTap: () {},
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final width = constraints.maxWidth;

          double h(double val) => height * val / 817; // base height from original design
          double w(double val) => width * val / 400; // base width from original design

          return SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: height,
                  width: width,
                  color: const Color.fromARGB(255, 224, 248, 255),
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
                // BottomNavigationBar from example positioned at bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),  // set your desired radius
                        topRight: Radius.circular(24),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(canvasColor: Colors.white),
                        child: BottomNavigationBar(
                          elevation: 200,
                          backgroundColor: const Color.fromARGB(249, 255, 255, 255),
                          items: const <BottomNavigationBarItem>[
                            BottomNavigationBarItem(
                              label: "Home",
                              icon: Icon(Icons.home),
                            ),
                            BottomNavigationBarItem(
                              label: "Profile",
                              icon: Icon(Icons.account_circle),
                            ),
                            BottomNavigationBarItem(
                              label: "Settings",
                              icon: Icon(Icons.settings),
                            ),
                          ],
                          unselectedItemColor: Color.fromARGB(250, 57, 201, 245),
                          currentIndex: _selectedIndex,
                          selectedItemColor: Color.fromARGB(237, 6, 247, 179),
                          onTap: _onItemTapped,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, Color iconColor, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.07),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: TextStyle(fontSize: 16)),
        onTap: onTap,
      ),
    );
  }

  Widget _buildHeaderSection(double Function(double) h, double Function(double) w) {
    return Container(
      height: h(270),
      width: w(400),
      color: Color.fromARGB(255, 224, 248, 255),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _numPages,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                final pageIndex = index % _numPages;
                final colors = [Colors.blueAccent, Colors.green, Colors.orange];
                final texts = ['Slide 1', 'Slide 2', 'Slide 3'];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: w(20)),
                  decoration: BoxDecoration(
                    color: colors[pageIndex],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      texts[pageIndex],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: h(24),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: h(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_numPages, (index) {
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: w(6)),
                  height: h(12),
                  width: h(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.blueAccent : Colors.grey[300],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationIndicators(double Function(double) h, double Function(double) w) {
    final indicatorCount = 4;
final indicatorSize = w(40);

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
                    Navigator.of(context).pushNamed('/team');
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
      margin: EdgeInsets.only(top: h(20), left: w(21), right: w(21)),
      height: h(229),
      width: w(371),
      child: Row(
        children: [
          // Large Gradient Card
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/test');
              },
              child: Container(
                height: h(229),
decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(h(18)),
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.black54,
      offset: Offset(0, 4),
      blurRadius: 10,
    ),
  ],
),
child: Stack(
  children: [
Positioned(
  top: 38,
  left: 0,
  right: 0,
  child: Text(
    'Test',
    style: TextStyle(
      color: Colors.black87,
      fontSize: h(26),
      fontWeight: FontWeight.w600,
      fontFamily: 'Montserrat',
    ),
    textAlign: TextAlign.center,
  ),
),
Positioned(
  bottom: 8,
  right: 8,
  child: Image.asset(
    'assets/icons/test_gif.gif',
    fit: BoxFit.contain,
    height: 120,
  ),
),
  ],
),
              ),
            ),
          ),
          SizedBox(width: w(20)),
          // Right Column Cards
          Expanded(
            flex: 1,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/counselling');
                  },
                  child: Container(
                    height: h(101),
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
                          'Gallery',
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
          ),
        ],
      ),
    );
  }

  Widget _buildBottomContentCards(double Function(double) h, double Function(double) w, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: h(20), left: w(21), right: w(21)),
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
              width: w(170), // Change width to match About Us box width
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
          SizedBox(width: w(20)),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/about');
            },
            child: Container(
              height: h(101),
              width: w(166), // Change width to match Counseling and bottom content box width
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
    return SizedBox.shrink();
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
