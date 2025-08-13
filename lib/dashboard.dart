import 'package:flutter/material.dart';
import 'counselling.dart';
import 'booking_section_page.dart';
 import 'profile.dart';
import 'settings.dart';
import 'test.dart';
import 'dart:async';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}



class _DashboardState extends State<Dashboard> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;
  int _selectedIndex = 0;
  Timer? _sliderTimer;

  @override
  void initState() {
    super.initState();
    _sliderTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      int nextPage = _currentPage + 1;
      if (nextPage >= 3) { // number of slides
        nextPage = 0;
      }
      _pageController.animateToPage(
        nextPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage = nextPage;
      });
    });
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // --------- DRAWER (HAMBURGER MENU) ------------
  Widget _buildHamburgerDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xffe5faff),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 20, bottom: 10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset('assets/icons/app_logo.png', width: 28, height: 28),
                ),
                SizedBox(width: 12),
                Text(
                  'MedhaMatrix',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.black54),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 8),
              children: [
                _buildDrawerItem(context, Icons.home, 'Home', onTap: () {
                  Navigator.pop(context);
                }),
                _buildDrawerItem(context, Icons.payment, 'Payment', onTap: () {
                  Navigator.pushNamed(context, '/payment');
                }),
                _buildDrawerItem(context, Icons.person, 'Download certificates', onTap: () {
                  Navigator.pushNamed(context, '/certificate_download');
                }),
                _buildDrawerItem(context, Icons.settings, 'Settings', onTap: () {
                  Navigator.pushNamed(context, '/settings');
                }),
                _buildDrawerItem(context, Icons.logout, 'Log Out', onTap: () {
                  Navigator.pushNamed(context, '/login');
                }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 24, top: 10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xffe4d6fa),
                  radius: 18,
                  child: Icon(Icons.person, color: Colors.grey[800]),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Therese Webb',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'UK Researcher',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
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
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String label, {VoidCallback? onTap}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(label, style: TextStyle(fontSize: 16, color: Colors.black87)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: Colors.white,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        bool isTablet = width > 700;
        bool isWide = width > 1100;

        // Responsive scaling
        double h(double val) => height * val / 817;
        double w(double val) => width * val / 400;

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 224, 248, 255),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Dashboard',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            iconTheme: IconThemeData(color: Colors.black87),
          ),
          drawer: _buildHamburgerDrawer(context),
          body: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isWide ? 1000 : double.infinity),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: isWide
                          ? width * 0.10
                          : isTablet
                              ? width * 0.05
                              : 0.0),
                  child: Column(
                    children: [
                      SizedBox(height: h(isTablet ? 50 : 20)),
                      // HEADER (slider and dots)
                      _buildHeaderSection(h, w, isTablet),
                      // QUICK NAV BAR
                      SizedBox(height: 20),
                      _buildNavigationIndicators(h, w, isTablet),
                      // MAIN CONTENT CARDS (Responsive wrap/grid)
                      SizedBox(height: h(22)),
                      _buildMainContentCards(h, w, context, width, isTablet, isWide),
                      // BOTTOM CONTENT (Responsive wrap/grid)
                      SizedBox(height: h(12)),
                      _buildBottomContentCards(h, w, context, width, isTablet),
                      SizedBox(height: h(20)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // RESPONSIVE BOTTOM NAV BAR
          bottomNavigationBar: _buildBottomNavigationBar(h, w, isTablet),
        );
      },
    );
  }

  // --------- HEADER (SLIDER + DOTS) -------------
  Widget _buildHeaderSection(double Function(double) h, double Function(double) w, bool isTablet) {
    final List<String> sliderImages = [
      'assets/images/slider1.png',
      'assets/images/slider2.jpg',
      'assets/Illustration.png',
    ];
    double pad = isTablet ? h(24) : h(15);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: isTablet ? h(180) : h(140),
          child: PageView.builder(
            controller: _pageController,
            itemCount: sliderImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: w(10)),
                padding: EdgeInsets.all(pad),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(h(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    sliderImages[index],
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: h(10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(sliderImages.length, (index) {
            return Container(
              width: _currentPage == index ? w(14) : w(8),
              height: _currentPage == index ? w(14) : w(8),
              margin: EdgeInsets.symmetric(horizontal: w(4)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.blue : Colors.grey[400],
              ),
            );
          }),
        ),
      ],
    );
  }

  // --------- QUICK NAVIGATION ----------
  Widget _buildNavigationIndicators(double Function(double) h, double Function(double) w, bool isTablet) {
    final indicatorCount = 4;
    final indicatorSize = isTablet ? w(54) : w(42);

    final List<String> imagePaths = [
      'assets/icons/IQ_test.png',
      'assets/icons/student_counseling.png',
      'assets/icons/parent_counseling.png',
      'assets/icons/our_team.png',
    ];
    final List<List<String>> labels = [
      ['IQ', 'TEST'],
      ['Student', 'Counseling'],
      ['Parent', 'Counseling'],
      ['Our', 'Team'],
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 0 : w(12), vertical: 0),
      child: Row(
        mainAxisAlignment:
            isTablet ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(indicatorCount, (index) {
            return GestureDetector(
              onTap: () {
                switch (index) {
                  case 0:
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TestSelectionPage(),
                      ),
                    );
                    break;
                  case 1:
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CounselingSelectionPage(
                          openStudentCounselingDialogOnLoad: true,
                        ),
                      ),
                    );
                    break;
                  case 2:
                        Navigator.of(context).pushNamed('/counselling');
                    break;
                  case 3:
                    Navigator.of(context).pushNamed('/our_team');
                    break;
                }
              },
              child: Container(
                margin:
                    EdgeInsets.symmetric(horizontal: isTablet ? 20 : 0, vertical: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: indicatorSize,
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Image.asset(
                          imagePaths[index],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      labels[index][0],
                      style: TextStyle(
                        fontSize: isTablet ? 13 : 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      labels[index][1],
                      style: TextStyle(
                        fontSize: isTablet ? 13 : 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
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

  // --------- MAIN CARDS (responsive grid/wrap) ---------
  Widget _buildMainContentCards(double Function(double) h, double Function(double) w, BuildContext context, double width, bool isTablet, bool isWide) {
    double spacing = isTablet ? 24 : 16;
    double cardWidth = (width - spacing * 3) / 2;
    double smallCardHeight = isTablet ? 110 : 90;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed('/test'),
          child: Container(
            width: cardWidth,
            height: isTablet ? 220 : 180,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Test',
                  style: TextStyle(
                    fontSize: isTablet ? 24 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: isTablet ? 20 : 12),
                Image.asset(
                  'assets/icons/test_gif.gif',
                  height: isTablet ? 100 : 80,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: spacing),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed('/counselling'),
              child: Container(
                width: cardWidth,
                height: smallCardHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Counseling',
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: spacing),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed('/payment_history'),
              child: Container(
                width: cardWidth,
                height: smallCardHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Gallery',
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomContentCards(double Function(double) h, double Function(double) w, BuildContext context, double width, bool isTablet) {
    double spacing = isTablet ? 24 : 16;
    double cardWidth = (width - spacing * 3) / 2;
    double cardHeight = isTablet ? 110 : 90;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed('/offers'),
          child: Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Offers',
                style: TextStyle(
                  fontSize: isTablet ? 20 : 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: spacing),
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed('/about'),
          child: Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'About Us',
                style: TextStyle(
                  fontSize: isTablet ? 20 : 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --------- RESPONSIVE BOTTOM NAV BAR -----------
  Widget _buildBottomNavigationBar(double Function(double) h, double Function(double) w, bool isTablet) {
    final List<IconData> icons = [
      Icons.home,
      Icons.person,
      Icons.settings,
    ];

    final List<String> labels = [
      'Home',
      'Profile',
      'Setting',
    ];

    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      backgroundColor: Color.fromARGB(255, 224, 248, 255),
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      type: BottomNavigationBarType.fixed,
      onTap: (index) async {
        if (index == 2) {
          setState(() {
            _selectedIndex = index;
          });
          await Navigator.of(context).pushNamed('/settings');
          setState(() {
            _selectedIndex = 0; // Reset to home on return
          });
        } else {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.of(context).pushNamed('/home');
              break;
            case 1:
              Navigator.of(context).pushNamed('/profile');
              break;
          }
        }
      },
      items: List.generate(labels.length, (index) {
        return BottomNavigationBarItem(
          icon: Icon(icons[index]),
          label: labels[index],
        );
      }),
    );
  }
}