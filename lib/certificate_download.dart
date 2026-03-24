import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:medhamatrix/medha_ui.dart';

import 'services/certificate_service.dart';
import 'services/user_service.dart';

class CertificateDownloadPage extends StatefulWidget {
  const CertificateDownloadPage({super.key});

  @override
  State<CertificateDownloadPage> createState() => _CertificateDownloadPageState();
}

class _CertificateDownloadPageState extends State<CertificateDownloadPage> {
  final GlobalKey _certificateKey = GlobalKey();
  IqCertificateData? _certificate;
  bool _isLoading = true;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _loadCertificate();
  }

  Future<void> _loadCertificate() async {
    await UserService.loadUserFromStorage();
    final certificate = await CertificateService.loadLatestIqCertificate();
    if (!mounted) return;

    setState(() {
      _certificate = certificate;
      _isLoading = false;
    });
  }

  void _showPendingMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Complete and submit your MMCT to generate your certificate.'),
      ),
    );
  }

  Future<void> _downloadCertificate() async {
    if (_certificate == null || _isDownloading) return;

    setState(() => _isDownloading = true);

    try {
      final boundary = _certificateKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('Certificate preview is not ready yet.');
      }

      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('Failed to convert certificate to image.');
      }

      final bytes = byteData.buffer.asUint8List();
      final outputDir = await _resolveDownloadDirectory();
      if (!await outputDir.exists()) {
        await outputDir.create(recursive: true);
      }

      final safeName = _certificate!.studentName
          .replaceAll(RegExp(r'[<>:"/\\|?*]'), '')
          .trim()
          .replaceAll(RegExp(r'\s+'), '_');
      final file = File(
        '${outputDir.path}${Platform.pathSeparator}medhamatrix_certificate_${safeName.isEmpty ? 'student' : safeName}.png',
      );
      await file.writeAsBytes(bytes, flush: true);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Certificate downloaded to ${file.path}'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  Future<Directory> _resolveDownloadDirectory() async {
    if (Platform.isWindows) {
      final userProfile = Platform.environment['USERPROFILE'];
      if (userProfile != null && userProfile.isNotEmpty) {
        return Directory('$userProfile\\Downloads');
      }
    }

    if (Platform.environment.containsKey('HOME')) {
      final home = Platform.environment['HOME']!;
      final downloads = Directory('$home${Platform.pathSeparator}Downloads');
      if (await downloads.exists()) {
        return downloads;
      }
    }

    return Directory.systemTemp;
  }

  @override
  Widget build(BuildContext context) {
    final studentName = _certificate?.studentName ?? UserService.fullName;
    final formattedDate = _certificate == null
        ? ''
        : DateFormat('dd MMM yyyy').format(_certificate!.completedAt);

    return MedhaScaffold(
      appBar: const MedhaTopBar(title: 'Certificates', subtitle: 'Download your achievements'),
      child: MedhaPageView(
        children: [
          const MedhaHeroCard(
            title: 'Certificate Center',
            subtitle: 'Your MMCT certificate appears here after successful submission.',
          ),
          const SizedBox(height: 18),
          MedhaCard(
            child: _isLoading
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(color: MedhaColors.primary),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MMCT Certificate',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: MedhaColors.text,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _certificate == null
                            ? 'Submit your MMCT to unlock a personalized certificate with your name and result.'
                            : 'Certificate generated for $studentName with MMCI ${_certificate!.score}.',
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.45,
                          color: MedhaColors.muted,
                        ),
                      ),
                      const SizedBox(height: 18),
                      RepaintBoundary(
                        key: _certificateKey,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: AspectRatio(
                            aspectRatio: 1.414,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  'assets/certificates/completion_certificate.png',
                                  fit: BoxFit.cover,
                                ),
                                if (_certificate != null)
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final width = constraints.maxWidth;
                                      final height = constraints.maxHeight;
                                      return Stack(
                                        children: [
                                          Positioned(
                                            left: width * 0.19,
                                            right: width * 0.19,
                                            top: height * 0.438,
                                            child: SizedBox(
                                              height: height * 0.072,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  studentName,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: width * 0.052,
                                                    fontWeight: FontWeight.w800,
                                                    color: const Color(0xFF0B4C78),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: width * 0.655,
                                            right: width * 0.15,
                                            top: height * 0.665,
                                            child: SizedBox(
                                              height: height * 0.05,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  _certificate!.score,
                                                  style: TextStyle(
                                                    fontSize: width * 0.032,
                                                    fontWeight: FontWeight.w900,
                                                    color: const Color(0xFF0B4C78),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: width * 0.218,
                                            bottom: height * 0.095,
                                            child: Text(
                                              formattedDate,
                                              style: TextStyle(
                                                fontSize: width * 0.02,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFF335C7D),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      MedhaPrimaryButton(
                        label: _certificate == null
                            ? 'Take MMCT First'
                            : (_isDownloading ? 'Downloading...' : 'Download Certificate'),
                        icon: _certificate == null
                            ? Icons.psychology_outlined
                            : Icons.download_rounded,
                        onPressed: _certificate == null ? _showPendingMessage : _downloadCertificate,
                      ),
                    ],
                  ),
          ),
          if (_certificate != null) ...[
            const SizedBox(height: 16),
            MedhaCard(
              child: Row(
                children: [
                  const MedhaIconTile(
                    icon: Icons.verified_rounded,
                    size: 54,
                    backgroundColor: MedhaColors.hero,
                    iconColor: MedhaColors.primaryDark,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Latest MMCI',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: MedhaColors.text,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$studentName completed the MMCT on $formattedDate with MMCI ${_certificate!.score}.',
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: MedhaColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
