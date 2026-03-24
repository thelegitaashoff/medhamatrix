import 'dart:async';

import 'package:flutter/material.dart';
import 'certificate_download.dart';
import 'counselling.dart';
import 'help_support.dart';
import 'medha_ui.dart';
import 'payment.dart';
import 'profile.dart';
import 'settings.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  int _highlightIndex = 0;
  Timer? _sliderTimer;

  final List<Map<String, String>> _highlights = const [
    {
      'title': 'Talk to expert counselors',
      'subtitle': 'Book focused sessions to plan academics and careers.',
    },
    {
      'title': 'Track your assessments',
      'subtitle': 'Start with IQ tests and explore emotional wellness tools.',
    },
    {
      'title': 'Build student confidence',
      'subtitle': 'Discover programs for students, parents, and teachers.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _sliderTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;
      final nextPage = (_highlightIndex + 1) % _highlights.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _handleBottomNav(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EditableProfilePage()));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsPage(userName: 'Ashish awhale')));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MedhaScaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('MedhaMatrix', style: TextStyle(color: MedhaColors.text, fontWeight: FontWeight.w800, fontSize: 22)),
        iconTheme: const IconThemeData(color: MedhaColors.text),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EditableProfilePage())),
            icon: const CircleAvatar(
              backgroundColor: MedhaColors.hero,
              child: Icon(Icons.person_outline_rounded, color: MedhaColors.text),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      bottomNavigationBar: MedhaBottomNav(currentIndex: _selectedIndex, onTap: _handleBottomNav),
      child: MedhaPageView(
        children: [
          MedhaHeroCard(
            title: 'Welcome back',
            subtitle: _highlights[_highlightIndex]['title']!,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(18)),
              child: const Text('3 Highlights', style: TextStyle(fontWeight: FontWeight.w700, color: MedhaColors.text)),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 150,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _highlightIndex = index),
              itemCount: _highlights.length,
              itemBuilder: (context, index) {
                final item = _highlights[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: MedhaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title']!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: MedhaColors.text)),
                        const SizedBox(height: 10),
                        Text(item['subtitle']!, style: const TextStyle(fontSize: 16, height: 1.4, color: MedhaColors.muted)),
                        const Spacer(),
                        const Text('Tap to continue', style: TextStyle(fontSize: 15, color: MedhaColors.primary, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _highlights.length,
              (index) => GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _highlightIndex == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _highlightIndex == index ? MedhaColors.primary : MedhaColors.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const MedhaSectionTitle(title: 'Quick Access', subtitle: 'Jump to your most-used workflows'),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width > 760 ? 4 : 2;
              final aspectRatio = width > 760 ? 2.0 : 1.8;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: aspectRatio,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _quickAccess(Icons.psychology_outlined, 'IQ Test', () => Navigator.pushNamed(context, '/test')),
                  _quickAccess(Icons.school_outlined, 'Student Counseling', () => Navigator.pushNamed(context, '/counselling')),
                  _quickAccess(Icons.family_restroom_outlined, 'Parent Counseling', () => Navigator.pushNamed(context, '/counselling')),
                  _quickAccess(Icons.groups_2_outlined, 'Our Team', () => Navigator.pushNamed(context, '/our_team')),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          const MedhaSectionTitle(title: 'Explore Services', subtitle: 'Everything you need in one place'),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width > 980
                  ? 3
                  : width > 700
                      ? 3
                      : 2;
              final aspectRatio = width > 980
                  ? 1.35
                  : width > 700
                      ? 1.1
                      : 1.0;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: aspectRatio,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                children: [
                  _serviceCard(context, Icons.lightbulb_outline_rounded, 'IQ Test', 'Start your assessment with guided steps.', const Color(0xFFADF1E7), () => Navigator.pushNamed(context, '/test')),
                  _serviceCard(context, Icons.video_call_outlined, 'Counseling', 'Connect with mentors for student and parent support.', const Color(0xFFD9E9FF), () => Navigator.pushNamed(context, '/counselling')),
                  _serviceCard(context, Icons.image_outlined, 'Gallery', 'Access activity history and recent uploads.', const Color(0xFFDDF0ED), () => Navigator.pushNamed(context, '/payment_history')),
                  _serviceCard(context, Icons.local_offer_outlined, 'Offers', 'Check plans and discounts currently available.', const Color(0xFFF0F4EF), () => Navigator.pushNamed(context, '/offers')),
                  _serviceCard(context, Icons.info_outline_rounded, 'About Us', 'Meet the team and learn how MedhaMatrix helps.', const Color(0xFFADF1E7), () => Navigator.pushNamed(context, '/about')),
                  _serviceCard(context, Icons.workspace_premium_outlined, 'Certificates', 'Download and share your latest certificates.', const Color(0xFFD9E9FF), () => Navigator.pushNamed(context, '/certificate_download')),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _quickAccess(IconData icon, String title, VoidCallback onTap) {
    return MedhaCard(
      padding: const EdgeInsets.all(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Row(
          children: [
            MedhaIconTile(icon: icon, size: 52),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
            const Icon(Icons.chevron_right_rounded, color: MedhaColors.muted),
          ],
        ),
      ),
    );
  }

  Widget _serviceCard(BuildContext context, IconData icon, String title, String subtitle, Color tone, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: tone,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 18, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MedhaIconTile(icon: icon, size: 54, backgroundColor: Colors.white.withOpacity(0.75), iconColor: MedhaColors.text),
            const Spacer(),
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: MedhaColors.text)),
            const SizedBox(height: 8),
            Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, height: 1.35, color: MedhaColors.muted)),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: MedhaColors.page,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              const MedhaHeroCard(
                leading: CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white,
                  child: Text('M', style: TextStyle(fontWeight: FontWeight.w800, color: MedhaColors.primary)),
                ),
                title: 'MedhaMatrix',
                subtitle: 'Student success hub',
                trailing: Icon(Icons.close_rounded, color: MedhaColors.text),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView(
                  children: [
                    _drawerItem(context, Icons.home_rounded, 'Home', 'Back to dashboard', () => Navigator.pop(context)),
                    _drawerItem(context, Icons.payment_rounded, 'Payment', 'Review transactions', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentPage()))),
                    _drawerItem(context, Icons.workspace_premium_outlined, 'Certificates', 'Download your certificates', () => Navigator.push(context, MaterialPageRoute(builder: (_) => CertificateDownloadPage()))),
                    _drawerItem(context, Icons.video_call_outlined, 'My Sessions', 'View scheduled counseling calls', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CounselingSelectionPage()))),
                    _drawerItem(context, Icons.play_circle_outline_rounded, 'Video Preview', 'Test your camera and audio', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportPage()))),
                    _drawerItem(context, Icons.call_outlined, 'Live Test Call', 'Join the live test room', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CounselingSelectionPage()))),
                    _drawerItem(context, Icons.settings_outlined, 'Settings', 'App preferences and controls', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage(userName: 'Ashish awhale')))),
                    _drawerItem(context, Icons.logout_rounded, 'Log Out', 'Sign out from this device', () => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false), iconColor: MedhaColors.danger),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap, {Color iconColor = MedhaColors.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: MedhaCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: MedhaMenuRow(
          icon: icon,
          title: title,
          subtitle: subtitle,
          onTap: onTap,
          iconColor: iconColor,
        ),
      ),
    );
  }
}
