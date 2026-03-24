import 'package:flutter/material.dart';
import 'package:medhamatrix/medha_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    const faqs = [
      {
        'question': 'How do I reset my password?',
        'answer': 'Use the forgot password option on the login screen and follow the recovery steps.',
      },
      {
        'question': 'How can I update my profile?',
        'answer': 'Open Profile from the dashboard or settings page and choose Edit Profile.',
      },
      {
        'question': 'How do I contact support?',
        'answer': 'Use the call or email options below and our team will help you.',
      },
    ];

    return MedhaScaffold(
      appBar: const MedhaTopBar(title: 'Help & Support', subtitle: 'We are here when you need us'),
      child: MedhaPageView(
        children: [
          const MedhaHeroCard(
            title: 'Support Center',
            subtitle: 'Browse common questions or reach our team directly.',
          ),
          const SizedBox(height: 18),
          MedhaCard(
            child: Column(
              children: faqs
                  .map(
                    (faq) => ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: const EdgeInsets.only(bottom: 12),
                      title: Text(faq['question']!, style: const TextStyle(fontWeight: FontWeight.w700)),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(faq['answer']!, style: const TextStyle(color: MedhaColors.muted, height: 1.5)),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 18),
          MedhaCard(
            child: Column(
              children: [
                MedhaPrimaryButton(
                  label: 'Call Us',
                  icon: Icons.call_outlined,
                  onPressed: () => _launchURL('tel:+919373034569'),
                ),
                const SizedBox(height: 12),
                MedhaOutlineButton(
                  label: 'Email Support',
                  icon: Icons.mail_outline_rounded,
                  onPressed: () => _launchURL('mailto:medhamatrix1@gmail.com'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
