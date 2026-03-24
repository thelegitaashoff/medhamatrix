import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/counseling_session.dart';

class CounselingSessionService {
  static const String _sessionKey = 'booked_counseling_sessions';

  static Future<List<CounselingSession>> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sessionKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return const [];
      }

      return decoded
          .whereType<Map>()
          .map((item) => CounselingSession.fromJson(Map<String, dynamic>.from(item)))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (_) {
      return const [];
    }
  }

  static Future<void> saveSession(CounselingSession session) async {
    final existing = await loadSessions();
    final updated = [session, ...existing.where((item) => item.id != session.id)];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _sessionKey,
      jsonEncode(updated.map((item) => item.toJson()).toList()),
    );
  }
}
