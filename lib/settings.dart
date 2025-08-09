import 'package:flutter/material.dart';
import 'change_password.dart';
import 'language.dart';
import 'notifications.dart';
import 'theme.dart';
import 'privacy_security.dart';
import 'help_support.dart';
import 'about.dart';
import 'profile.dart';  // Added import for profile page

class SettingsPage extends StatelessWidget {
  final String userName;

  const SettingsPage({super.key, required this.userName});

  Widget settingBox(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.10),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.blueGrey.shade100, width: 1),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      backgroundColor: Color.fromARGB(255, 224, 248, 255),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile section
            settingBox(
              Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(
                        "https://api.multiavatar.com/medhamatrics_user.png"), // Replace with user's image asset/path
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 4),
                      // Removed user email display as requested
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => EditableProfilePage(startEditing: true)),
                      );
                    },
                    child: Icon(Icons.edit, color: Colors.blueGrey, size: 22),
                  ),
                ],
              ),
            ),

            // Account settings
            settingBox(
              Column(
                children: [
                  _settingTile(Icons.lock, "Change Password"),
                  _divider(),
                  _settingTile(Icons.language, "Language"),
                  _divider(),
                  _settingTile(Icons.notifications, "Notifications"),
                ],
              ),
            ),

            // App settings
            settingBox(
              Column(
                children: [
                  _settingTile(Icons.color_lens, "Theme"),
                  _divider(),
                  _settingTile(Icons.privacy_tip, "Privacy & Security"),
                  // Removed Storage as requested
                ],
              ),
            ),

            // Help & about
            settingBox(
              Column(
                children: [
                  _settingTile(Icons.help_outline, "Help & Support"),
                  _divider(),
                  _settingTile(Icons.info_outline, "About MedhaMatrix"),
                  _divider(),
                  _settingTile(Icons.exit_to_app, "Logout", iconColor: Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingTile(IconData icon, String title, {Color? iconColor}) {
    return Builder(
      builder: (BuildContext context) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent.withOpacity(0.14),
            child: Icon(icon, color: iconColor ?? Colors.blue, size: 22),
            radius: 18,
          ),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
          onTap: () {
            // Navigate to respective pages
            switch (title) {
              case 'Change Password':
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                );
                break;
              case 'Language':
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LanguagePage()),
                );
                break;
              case 'Notifications':
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NotificationsPage()),
                );
                break;
              case 'Theme':
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ThemePage()),
                );
                break;
              case 'Privacy & Security':
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PrivacySecurityPage()),
                );
                break;
              case 'Help & Support':
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HelpSupportPage()),
                );
                break;
              case 'About MedhaMatrix':
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AboutUsMedhaMatrixPage()),
                );
                break;
              case 'Logout':
                // Placeholder logout action
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
                          // Add logout logic here
                        },
                        child: Text('Logout'),
                      ),
                    ],
                  ),
                );
                break;
              default:
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Clicked on $title')),
                );
            }
          },
          contentPadding: const EdgeInsets.all(0),
        );
      },
    );
  }

  Widget _divider() {
    return Divider(
      thickness: 1,
      color: Colors.blueGrey.shade50,
      height: 4,
    );
  }
}
