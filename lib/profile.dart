// ignore_for_file: unused_import, no_leading_underscores_for_local_identifiers, deprecated_member_use

import 'package:flutter/material.dart';
import 'counselling.dart';
import 'settings.dart';
import 'test.dart';
import 'dashboard.dart';
import 'payment_history.dart';
import 'notifications.dart';
import 'certificate_download.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;

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
              case '/payment':
                return PaymentHistoryPage();
              case '/profile':
                return ProfilePage();
              case '/settings':
                return SettingsPage();
              case '/notifications':
                return NotificationPage();
              case '/certificate_download':
                return CertificateDownloadPage();
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    Widget _buildCard({required Widget child, Color? color}) {
      return Card(
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
        ),
        elevation: 4,
        color: color ?? colorScheme.surfaceVariant,
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: child,
        ),
      );
    }



    Widget _buildInfoRow(IconData icon, String text) {
      return Row(
        children: [
          Icon(icon, color: colorScheme.primary),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: screenWidth * 0.045)),
          ),
        ],
      );
    }

    Widget _buildUserInfo() {
      return _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User Information', style: TextStyle(fontSize: screenWidth * 0.055, fontWeight: FontWeight.bold, color: colorScheme.primary)),
            SizedBox(height: screenHeight * 0.02),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.18,
                    backgroundColor: colorScheme.primaryContainer,
                    backgroundImage: NetworkImage('https://www.gravatar.com/avatar/placeholder?s=150&d=mp'), // Updated placeholder profile picture
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: screenWidth * 0.055,
                      backgroundColor: colorScheme.primary,
                      child: Icon(Icons.edit, size: screenWidth * 0.055, color: colorScheme.onPrimary),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.025),
            Center(
              child: Column(
                children: [
                  Text('John Doe', style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.w700)),
                  SizedBox(height: screenHeight * 0.005),
                  Text('@johndoe123', style: TextStyle(fontSize: screenWidth * 0.045, color: colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Divider(color: colorScheme.outline),
            SizedBox(height: screenHeight * 0.02),
            _buildInfoRow(Icons.email, 'john.doe@example.com'),
            SizedBox(height: screenHeight * 0.01),
            _buildInfoRow(Icons.phone, '+1 234 567 8900'),
          ],
        ),
      );
    }

    Widget _buildSummaryItem(String title, String value) {
      return SizedBox(
        width: screenWidth * 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: screenWidth * 0.045)),
            SizedBox(height: screenHeight * 0.005),
            Text(value, style: TextStyle(fontSize: screenWidth * 0.04, color: colorScheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    Widget _buildTestProgressSummary() {
      return _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Test & Progress Summary', style: TextStyle(fontSize: screenWidth * 0.055, fontWeight: FontWeight.bold, color: colorScheme.primary)),
            SizedBox(height: screenHeight * 0.02),
            Wrap(
              spacing: screenWidth * 0.1,
              runSpacing: screenHeight * 0.015,
              children: [
                _buildSummaryItem('IQ Test Score', 'Latest: 120\nAverage: 115'),
                _buildSummaryItem('Last Test Taken', '2024-06-01'),
                _buildSummaryItem('Total Tests Completed', '5'),
              ],
            ),
            SizedBox(height: screenHeight * 0.025),
            Container(
              height: screenHeight * 0.12,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
              ),
              child: Center(
                child: Text('Progress Chart Placeholder', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildActivityLog() {
      final List<Map<String, String>> pastTests = [
        {'name': 'IQ Test', 'date': '2024-06-01', 'result': 'Score: 120'},
        {'name': 'IQ Test', 'date': '2024-04-10', 'result': 'Score: 110'},
      ];

      return _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Activity Log / History', style: TextStyle(fontSize: screenWidth * 0.055, fontWeight: FontWeight.bold, color: colorScheme.primary)),
            SizedBox(height: screenHeight * 0.02),
            SizedBox(
              height: screenHeight * 0.3,
              child: ListView.separated(
                itemCount: pastTests.length,
                separatorBuilder: (context, index) => Divider(color: colorScheme.outline),
                itemBuilder: (context, index) {
                  final test = pastTests[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(test['name'] ?? '', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${test['date']} - ${test['result']}', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                    leading: Icon(Icons.history, color: colorScheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    tileColor: colorScheme.primaryContainer.withOpacity(0.1),
                    visualDensity: VisualDensity.compact,
                    dense: true,
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: colorScheme.onPrimary)),
        backgroundColor: colorScheme.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(),
            _buildTestProgressSummary(),
            _buildActivityLog(),
            SizedBox(height: screenHeight * 0.05),
            ElevatedButton.icon(
              onPressed: () {
                // Placeholder for edit profile action
              },
              icon: Icon(Icons.edit),
              label: Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                minimumSize: Size(double.infinity, screenWidth * 0.12),
              ),
            ),
            SizedBox(height: screenWidth * 0.03),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CertificateDownloadPage()),
                );
              },
              icon: Icon(Icons.download),
              label: Text('Download Certificate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                minimumSize: Size(double.infinity, screenWidth * 0.12),
              ),
            ),
            SizedBox(height: screenWidth * 0.03),
            ElevatedButton.icon(
              onPressed: () {
                // Placeholder for logout action
              },
              icon: Icon(Icons.logout),
              label: Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
                minimumSize: Size(double.infinity, screenWidth * 0.12),
              ),
            ),
          ],
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
