import 'package:flutter/material.dart';
import 'package:medhamatrix/medha_ui.dart';

class AboutUsMedhaMatrixPage extends StatefulWidget {
  const AboutUsMedhaMatrixPage({super.key});

  @override
  State<AboutUsMedhaMatrixPage> createState() => _AboutUsMedhaMatrixPageState();
}

class _AboutUsMedhaMatrixPageState extends State<AboutUsMedhaMatrixPage> {
  final List<Map<String, dynamic>> aboutItems = [
    {
      'title': 'Our Mission',
      'content': 'To empower students, parents, and teachers intellectually and emotionally, building a positive and inspiring educational environment for all.',
      'icon': Icons.visibility_outlined,
    },
    {
      'title': 'Introduction to MedhaMatrix',
      'content': 'MedhaMatrix supports mental, educational, social, and personal development through guidance, counseling, and structured growth programs.',
      'icon': Icons.lightbulb_outline_rounded,
    },
    {
      'title': 'Why us?',
      'content': 'Students face pressure, uncertainty, and stress. We respond with practical assessments, focused support, and personalized direction.',
      'icon': Icons.psychology_outlined,
    },
    {
      'title': 'Programs & Benefits',
      'content': 'MMCT assessments, detailed reports, expert counseling, parent support, and teacher development programs designed around real student needs.',
      'icon': Icons.verified_outlined,
    },
    {
      'title': 'Who We Help',
      'content': 'Students, parents, and teachers looking for stronger self-awareness, better decisions, and consistent support.',
      'icon': Icons.groups_2_outlined,
    },
    {
      'title': 'Contact',
      'content': 'Email: support@medhamatrix.com\nWebsite: www.medhamatrix.com',
      'icon': Icons.mail_outline_rounded,
    },
  ];

  final Set<int> _expanded = {0};

  @override
  Widget build(BuildContext context) {
    return MedhaScaffold(
      appBar: const MedhaTopBar(title: 'About Us', subtitle: 'Who we are and what we do'),
      child: MedhaPageView(
        children: [
          const MedhaHeroCard(
            title: 'MedhaMatrix Story',
            subtitle: 'Learn about our mission, programs, and support ecosystem.',
          ),
          const SizedBox(height: 18),
          ...aboutItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final expanded = _expanded.contains(index);
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: MedhaCard(
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    setState(() {
                      expanded ? _expanded.remove(index) : _expanded.add(index);
                    });
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          MedhaIconTile(icon: item['icon'] as IconData, size: 62, backgroundColor: MedhaColors.hero),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              item['title'] as String,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: MedhaColors.text),
                            ),
                          ),
                          Icon(
                            expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                            color: MedhaColors.muted,
                            size: 30,
                          ),
                        ],
                      ),
                      if (expanded) ...[
                        const SizedBox(height: 14),
                        Text(
                          item['content'] as String,
                          style: const TextStyle(fontSize: 15, height: 1.5, color: MedhaColors.text),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
