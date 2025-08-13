import 'package:flutter/material.dart';

class PrivacySecurityPage extends StatelessWidget {
  const PrivacySecurityPage({Key? key}) : super(key: key);

  final String _privacySummary = '''
At MedhaMatrix, your privacy is our priority. We collect minimal personal data necessary to provide our services securely and transparently.

Your information is encrypted and never shared with third parties without your consent.

For detailed information, please review our full Privacy Policy.
''';

  final String _securityInfo = '''
We implement industry-standard security measures including:

• Data encryption in transit and at rest  
• Regular security audits  
• Secure authentication protocols  

You are encouraged to use strong passwords and enable two-factor authentication when available.
''';

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final double cardMaxWidth = 480;
    final double horizontalMargin = deviceWidth < 420 ? 12 : 24;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 248, 255),
      appBar: AppBar(
        title: const Text('Privacy & Security'),
        backgroundColor: Color.fromARGB(255, 224, 248, 255),
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
                // Privacy Policy Card
                _buildBoxCard(
                  context,
                  title: 'Privacy Policy',
                  content: _privacySummary,
                ),
                const SizedBox(height: 20),
                // Security Info Card
                _buildBoxCard(
                  context,
                  title: 'Security Information',
                  content: _securityInfo,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Example action: navigate to detailed Privacy Policy page or show dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Navigate to full Privacy Policy')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 153, 216, 235),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'View Full Privacy Policy',
                    style: TextStyle(fontSize: 16, letterSpacing: 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBoxCard(BuildContext context,
      {required String title, required String content}) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
