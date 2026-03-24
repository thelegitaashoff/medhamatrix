import 'package:flutter/material.dart';
import 'package:medhamatrix/medha_ui.dart';

class PrivacySecurityPage extends StatelessWidget {
  const PrivacySecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MedhaScaffold(
      appBar: const MedhaTopBar(title: 'Privacy & Security', subtitle: 'How your data is protected'),
      child: const MedhaPageView(
        children: [
          MedhaHeroCard(
            title: 'Privacy Brief',
            subtitle: 'Understand how your information is secured and managed.',
          ),
          SizedBox(height: 18),
          MedhaCard(
            child: _InfoBlock(
              title: 'Privacy Policy',
              content:
                  'At MedhaMatrix, your privacy is our priority. We collect minimal personal data necessary to provide our services securely and transparently.\n\nYour information is encrypted and never shared with third parties without your consent.\n\nFor detailed information, please review our full Privacy Policy.',
            ),
          ),
          SizedBox(height: 18),
          MedhaCard(
            child: _InfoBlock(
              title: 'Security Information',
              content:
                  'We implement industry-standard security measures including:\n\n• Data encryption in transit and at rest\n• Regular security audits\n• Secure authentication protocols\n\nYou are encouraged to use strong passwords and enable two-factor authentication when available.',
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String title;
  final String content;

  const _InfoBlock({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: MedhaColors.text)),
        const SizedBox(height: 12),
        Text(content, style: const TextStyle(fontSize: 15, height: 1.6, color: MedhaColors.text)),
      ],
    );
  }
}
