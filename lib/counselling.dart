import 'package:flutter/material.dart';
import 'agora_call_page.dart';
import 'booking_section_page.dart';
import 'counseling_sessions_page.dart';
import 'medha_ui.dart';

class CounselingSelectionPage extends StatelessWidget {
  final bool openStudentCounselingDialogOnLoad;
  final bool openParentCounselingDialogOnLoad;

  const CounselingSelectionPage({
    super.key,
    this.openStudentCounselingDialogOnLoad = false,
    this.openParentCounselingDialogOnLoad = false,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': 'Student Counseling',
        'subtitle': 'Support for academic and personal growth',
        'icon': Icons.school_outlined,
      },
      {
        'title': 'Career Counseling',
        'subtitle': 'Explore career options and planning',
        'icon': Icons.work_outline_rounded,
      },
      {
        'title': 'Parent Counseling',
        'subtitle': 'Support for parenting challenges and advice',
        'icon': Icons.family_restroom_outlined,
      },
    ];

    return MedhaScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: MedhaColors.text, size: 30),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        titleSpacing: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Counseling', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700, color: MedhaColors.text)),
            Text('Book expert guidance sessions', style: TextStyle(fontSize: 13, color: MedhaColors.muted)),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 14),
            child: Icon(Icons.video_call_rounded, color: MedhaColors.text, size: 28),
          ),
        ],
      ),
      child: MedhaPageView(
        children: [
          const MedhaHeroCard(
            title: 'Counseling Hub',
            subtitle: 'Choose student, career, or parent counseling and book a session instantly.',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              SizedBox(
                width: 138,
                child: MedhaPrimaryButton(
                  label: 'My Sessions',
                  icon: Icons.video_camera_front_outlined,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CounselingSessionsPage()),
                  ),
                ),
              ),
              SizedBox(
                width: 154,
                child: MedhaOutlineButton(
                  label: 'Video Preview',
                  icon: Icons.videocam_outlined,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AgoraCallPage(previewOnly: true),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 154,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AgoraCallPage(),
                    ),
                  ),
                  icon: const Icon(Icons.call_outlined),
                  label: const Text('Live Test Call'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD8F4EE),
                    foregroundColor: MedhaColors.text,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MedhaCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MedhaIconTile(icon: item['icon'] as IconData, size: 60, backgroundColor: MedhaColors.hero),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: MedhaColors.text)),
                          const SizedBox(height: 6),
                          Text(item['subtitle'] as String, style: const TextStyle(fontSize: 14, height: 1.3, color: MedhaColors.text)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 96,
                      child: MedhaPrimaryButton(
                        label: 'Book',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingSectionPage(initialCounselor: item['title'] as String),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
