import 'package:flutter/material.dart';
import 'about.dart';
import 'help_support.dart';
import 'medha_ui.dart';
import 'notifications.dart';
import 'privacy_security.dart';
import 'profile.dart';

class SettingsPage extends StatelessWidget {
  final String userName;

  const SettingsPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return MedhaScaffold(
      appBar: const MedhaTopBar(title: 'Settings', subtitle: 'Manage account and preferences'),
      child: MedhaPageView(
        children: [
          MedhaHeroCard(
            leading: const MedhaIconTile(
              icon: Icons.person_outline_rounded,
              size: 78,
              backgroundColor: Colors.white,
            ),
            title: userName,
            subtitle: 'Account settings overview',
          ),
          const SizedBox(height: 18),
          const MedhaSectionTitle(
            title: 'Preferences',
            subtitle: 'Tune alerts, privacy, and account access',
          ),
          MedhaCard(
            child: Column(
              children: [
                MedhaMenuRow(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NotificationSettingsPage()),
                  ),
                ),
                const Divider(color: MedhaColors.border),
                MedhaMenuRow(
                  icon: Icons.shield_outlined,
                  title: 'Privacy & Security',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PrivacySecurityPage()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const MedhaSectionTitle(
            title: 'Support',
            subtitle: 'Reach help pages and account actions',
          ),
          MedhaCard(
            child: Column(
              children: [
                MedhaMenuRow(
                  icon: Icons.person_2_outlined,
                  title: 'Profile',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const EditableProfilePage()),
                  ),
                ),
                const Divider(color: MedhaColors.border),
                MedhaMenuRow(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HelpSupportPage()),
                  ),
                ),
                const Divider(color: MedhaColors.border),
                MedhaMenuRow(
                  icon: Icons.info_outline_rounded,
                  title: 'About MedhaMatrix',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AboutUsMedhaMatrixPage()),
                  ),
                ),
                const Divider(color: MedhaColors.border),
                MedhaMenuRow(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  iconColor: MedhaColors.danger,
                  iconBackground: const Color(0xFFFBE8E8),
                  textColor: MedhaColors.danger,
                  onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
