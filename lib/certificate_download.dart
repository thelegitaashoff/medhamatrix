import 'package:flutter/material.dart';

class CertificateDownloadPage extends StatelessWidget {
  const CertificateDownloadPage({super.key});

  void _downloadCertificate(BuildContext context) {
    // Simulate download action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Certificate download started...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download Certificate'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Download your certificate here.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _downloadCertificate(context),
                child: Text('Download Certificate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
