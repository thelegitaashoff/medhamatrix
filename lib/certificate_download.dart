import 'package:flutter/material.dart';

class CertificateDownloadPage extends StatelessWidget {
  final List<CertificateItem> certificates = [
    CertificateItem(
      imageUrl: 'https://img.freepik.com/free-vector/certificate-appreciation-template_23-2148816957.jpg?w=826',
      title: 'IQ Assessment Certificate',
      description: 'Awarded for successful completion of MedhaMatrix IQ evaluation',
      downloadUrl: 'https://example.com/sample_certificate.pdf',
    ),
    CertificateItem(
      imageUrl: 'https://img.freepik.com/free-vector/modern-certificate-template_23-2148817406.jpg?w=826',
      title: 'Completion Certificate',
      description: 'Congratulations on completing the learning program.',
      downloadUrl: 'https://example.com/sample_certificate_2.pdf',
    ),
  ];

  CertificateDownloadPage({super.key});

  void _downloadCertificate(BuildContext context, String url) {
    // Implement actual download logic here using url_launcher, dio, etc.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Initiate download: $url")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Certificates'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      backgroundColor: Color.fromARGB(255, 224, 248, 255),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final isSmallScreen = width < 600;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            itemCount: certificates.length,
            itemBuilder: (context, index) {
              final cert = certificates[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.11),
                      blurRadius: 12,
                      offset: const Offset(2, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.blueGrey.shade100, width: 1.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: isSmallScreen
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                cert.imageUrl,
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: Colors.blueGrey.shade50,
                                  width: double.infinity,
                                  height: 150,
                                  child: const Icon(Icons.image,
                                      size: 40, color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(cert.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 5),
                            Text(cert.description,
                                style: const TextStyle(fontSize: 13)),
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  _downloadCertificate(context, cert.downloadUrl),
                              icon: const Icon(Icons.download, size: 20),
                              label: const Text("Download"),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                cert.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: Colors.blueGrey.shade50,
                                  width: 80,
                                  height: 80,
                                  child: const Icon(Icons.image,
                                      size: 40, color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(cert.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  const SizedBox(height: 5),
                                  Text(cert.description,
                                      style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  _downloadCertificate(context, cert.downloadUrl),
                              icon: const Icon(Icons.download, size: 20),
                              label: const Text("Download"),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CertificateItem {
  final String imageUrl;
  final String title;
  final String description;
  final String downloadUrl;

  CertificateItem({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.downloadUrl,
  });
}
