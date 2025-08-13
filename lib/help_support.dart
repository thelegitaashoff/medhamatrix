import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

  // Example FAQs
  final List<Map<String, String>> _faqs = const [
    {
      'question': 'How do I reset my password?',
      'answer': 'Go to the Change Password page under Profile and follow the instructions to reset your password.'
    },
    {
      'question': 'How can I update my profile information?',
      'answer': 'Navigate to the Profile page and use the Edit option to update your information.'
    },
    {
      'question': 'How do I contact customer support?',
      'answer': 'You can use the Contact Support section below to reach us via phone or email.'
    },
  ];

  // Launch URL helper (for phone & email)
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final double cardMaxWidth = 480;
    final double horizontalMargin = deviceWidth < 400 ? 12 : 24;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 248, 255),
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Container(
            constraints: BoxConstraints(maxWidth: cardMaxWidth),
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Support Info Box
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 14,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Text(
                    "We're here to help! Browse through the FAQs below, or contact us directly if you need more support.",
                    style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 20),

                // FAQ Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 14,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Frequently Asked Questions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._faqs.map((faq) => ExpansionTile(
                        title: Text(faq['question']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text(faq['answer']!, style: const TextStyle(color: Colors.black87)),
                          )
                        ],
                      ))
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Contact Support Box
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 14,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Contact Support',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => _launchURL('tel:+919373034569'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Color.fromARGB(250, 57, 201, 245),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.phone, color: Colors.black),
                        label: const Text('Call Us', style: TextStyle(color: Colors.black)),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => _launchURL('mailto:medhamatrix1@gmail.com'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(250, 57, 201, 245),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.email, color: Colors.black),
                        label: const Text('Email Support', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
