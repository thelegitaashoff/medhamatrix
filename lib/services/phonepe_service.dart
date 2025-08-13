import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class PhonePeService {
  // PhonePe Test Configuration (Verified UAT credentials)
  static const String merchantId = 'PGTESTPAYUAT86';
  static const String saltKey = '96434309-7796-489d-8924-ab56988a6076';
  static const String saltIndex = '1';
  static const String baseUrl = 'https://api.phonepe.com/apis/hermes';
  
  // Test environment URLs
  static const String testBaseUrl = 'https://api-preprod.phonepe.com/apis/hermes';
  static bool isTestMode = true; // Set to false for production
  
  static String get currentBaseUrl => isTestMode ? testBaseUrl : baseUrl;

  /// Generate checksum for PhonePe API
  static String generateChecksum(String payload) {
    final checksumString = payload + '/pg/v1/pay' + saltKey;
    final bytes = utf8.encode(checksumString);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Generate checksum for status check
  static String generateStatusChecksum(String merchantTransactionId) {
    final checksumString = '/pg/v1/status/$merchantId/$merchantTransactionId' + saltKey;
    final bytes = utf8.encode(checksumString);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Create payment request
  static Future<Map<String, dynamic>> initiatePayment({
    required String merchantTransactionId,
    required double amount,
    required String userId,
    required String callbackUrl,
    String? mobileNumber,
    String? email,
  }) async {
    try {
      final payload = {
        "merchantId": merchantId,
        "merchantTransactionId": merchantTransactionId,
        "merchantUserId": userId,
        "amount": (amount * 100).toInt(), // Convert to paise
        "redirectUrl": callbackUrl,
        "redirectMode": "REDIRECT",
        "callbackUrl": callbackUrl,
        "mobileNumber": mobileNumber,
        "paymentInstrument": {
          "type": "PAY_PAGE"
        }
      };

      // Remove empty fields
      payload.removeWhere((key, value) => value == null || value == '');

      final base64Payload = base64.encode(utf8.encode(json.encode(payload)));
      final checksum = generateChecksum(base64Payload) + "###$saltIndex";

      final requestBody = {
        "request": base64Payload,
        "checksum": checksum,
      };

      final response = await http.post(
        Uri.parse('$currentBaseUrl/pg/v1/pay'),
        headers: {
          'Content-Type': 'application/json',
          'X-VERIFY': checksum,
          'accept': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print('PhonePe Payment Request: ${json.encode(requestBody)}');
      print('PhonePe Payment Response: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          final redirectUrl = responseData['data']?['instrumentResponse']?['redirectInfo']?['url'];
          return {
            'success': true,
            'data': responseData,
            'redirectUrl': redirectUrl,
            'merchantTransactionId': merchantTransactionId
          };
        } else {
          return {
            'success': false,
            'error': responseData['message'] ?? 'Payment initiation failed',
            'code': responseData['code']
          };
        }
      } else {
        return {
          'success': false,
          'error': 'Payment initiation failed: ${response.statusCode} - ${response.body}'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error initiating payment: $e'
      };
    }
  }

  /// Check payment status
  static Future<Map<String, dynamic>> checkPaymentStatus(String merchantTransactionId) async {
    try {
      final checksum = generateStatusChecksum(merchantTransactionId) + "###$saltIndex";

      final response = await http.get(
        Uri.parse('$currentBaseUrl/pg/v1/status/$merchantId/$merchantTransactionId'),
        headers: {
          'Content-Type': 'application/json',
          'X-VERIFY': checksum,
          'X-MERCHANT-ID': merchantId,
          'accept': 'application/json',
        },
      );

      print('PhonePe Status Check Response: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          return {
            'success': true,
            'data': responseData,
            'status': responseData['data']['state'],
            'amount': responseData['data']['amount'],
            'transactionId': responseData['data']['transactionId'],
            'responseCode': responseData['data']['responseCode']
          };
        } else {
          return {
            'success': false,
            'error': responseData['message'] ?? 'Failed to check payment status',
            'code': responseData['code']
          };
        }
      } else {
        return {
          'success': false,
          'error': 'Failed to check payment status: ${response.statusCode} - ${response.body}'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error checking payment status: $e'
      };
    }
  }

  /// Generate unique transaction ID
  static String generateTransactionId() {
    return 'TXN_${DateTime.now().millisecondsSinceEpoch}_${(1000 + (DateTime.now().millisecond)).toString().padLeft(4, '0')}';
  }
}
