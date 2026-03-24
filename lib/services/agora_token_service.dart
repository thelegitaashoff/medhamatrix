import 'dart:convert';

import 'package:http/http.dart' as http;

import 'user_service.dart';

class AgoraTokenResult {
  final String? token;
  final int uid;

  const AgoraTokenResult({
    required this.token,
    required this.uid,
  });
}

class AgoraTokenService {
  static const String appId = '255d514dc36f4d5cb1df4c5a4350c516';

  // Replace this with your actual backend endpoint if it differs.
  static const String tokenEndpoint =
      String.fromEnvironment(
        'AGORA_TOKEN_API',
        defaultValue: 'https://medhamatrix.com/auth/api/auth/agora/token/',
      );

  static Future<AgoraTokenResult> fetchToken({
    required String channelName,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = UserService.authToken;
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http
        .post(
          Uri.parse(tokenEndpoint),
          headers: headers,
          body: jsonEncode({
            'channelName': channelName,
            'channel_name': channelName,
          }),
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Token API failed with status ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map) {
      throw Exception('Invalid token API response');
    }

    final data = decoded['data'] is Map<String, dynamic>
        ? decoded['data'] as Map<String, dynamic>
        : Map<String, dynamic>.from(decoded);

    final resolvedToken = _readFirstString(data, [
      'token',
      'rtcToken',
      'rtc_token',
      'agora_token',
    ]);
    final uid = _readFirstInt(data, [
          'uid',
          'userId',
          'user_id',
        ]) ??
        0;

    return AgoraTokenResult(
      token: resolvedToken,
      uid: uid,
    );
  }

  static String? _readFirstString(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }

  static int? _readFirstInt(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final value = map[key];
      if (value is int) {
        return value;
      }
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) {
          return parsed;
        }
      }
    }
    return null;
  }
}
