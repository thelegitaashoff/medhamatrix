import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CertificateService {
  static const String _latestCertificateKey = 'latest_certificate';

  static Future<void> saveLatestIqCertificate({
    required String studentName,
    required String score,
    required DateTime completedAt,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = <String, dynamic>{
      'studentName': studentName,
      'score': score,
      'completedAt': completedAt.toIso8601String(),
    };
    await prefs.setString(_latestCertificateKey, jsonEncode(payload));
  }

  static Future<IqCertificateData?> loadLatestIqCertificate() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_latestCertificateKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final studentName = decoded['studentName']?.toString().trim() ?? '';
      final score = decoded['score']?.toString().trim() ?? '';
      final completedAtRaw = decoded['completedAt']?.toString();
      final completedAt = completedAtRaw == null
          ? null
          : DateTime.tryParse(completedAtRaw);

      if (studentName.isEmpty || score.isEmpty || completedAt == null) {
        return null;
      }

      return IqCertificateData(
        studentName: studentName,
        score: score,
        completedAt: completedAt,
      );
    } catch (_) {
      return null;
    }
  }
}

class IqCertificateData {
  final String studentName;
  final String score;
  final DateTime completedAt;

  const IqCertificateData({
    required this.studentName,
    required this.score,
    required this.completedAt,
  });
}
