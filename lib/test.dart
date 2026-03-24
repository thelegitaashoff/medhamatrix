import 'package:flutter/material.dart';
import 'iq_test_page.dart';
import 'medha_ui.dart';

class TestSelectionPage extends StatefulWidget {
  const TestSelectionPage({super.key});

  @override
  State<TestSelectionPage> createState() => _TestSelectionPageState();
}

class _TestSelectionPageState extends State<TestSelectionPage> {
  @override
  Widget build(BuildContext context) {
    final tests = [
      {
        'title': 'IQ Test',
        'subtitle': 'Assess your logical intelligence',
        'icon': Icons.lightbulb_outline_rounded,
      },
      {
        'title': 'Depression Scale',
        'subtitle': 'Evaluate your emotional well-being',
        'icon': Icons.sentiment_dissatisfied_outlined,
      },
      {
        'title': 'EQ',
        'subtitle': 'Measure your emotional intelligence',
        'icon': Icons.favorite_outline_rounded,
      },
      {
        'title': 'REBT',
        'subtitle': 'Rational emotive behavior therapy overview',
        'icon': Icons.psychology_alt_outlined,
      },
    ];

    return MedhaScaffold(
      appBar: const MedhaTopBar(title: 'Tests', subtitle: 'Choose your assessment'),
      child: MedhaPageView(
        children: [
          const MedhaHeroCard(
            title: 'Assessment Hub',
            subtitle: 'Start with IQ Test or explore upcoming emotional wellness assessments.',
          ),
          const SizedBox(height: 18),
          ...tests.map((test) {
            final isIqTest = test['title'] == 'IQ Test';
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: MedhaCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MedhaIconTile(icon: test['icon'] as IconData, size: 58, backgroundColor: MedhaColors.hero),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(test['title'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: MedhaColors.text)),
                          const SizedBox(height: 6),
                          Text(test['subtitle'] as String, style: const TextStyle(fontSize: 14, height: 1.3, color: MedhaColors.text)),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => _showInfo(context, test['title'] as String, test['subtitle'] as String),
                            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 32), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                            child: const Text('More Info', style: TextStyle(color: MedhaColors.primary, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 108,
                      child: MedhaPrimaryButton(
                        label: 'Start Test',
                        onPressed: () => isIqTest
                            ? Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const IqTestPage()),
                              )
                            : _showComingSoon(context, test['title'] as String),
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

  void _showInfo(BuildContext context, String title, String subtitle) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(title),
        content: Text('$subtitle\n\nThis assessment helps guide the next step in your MedhaMatrix journey.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: MedhaColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Coming Soon'),
        content: Text('$title will be available soon. For now, only IQ Test is active.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: MedhaColors.primary)),
          ),
        ],
      ),
    );
  }
}
