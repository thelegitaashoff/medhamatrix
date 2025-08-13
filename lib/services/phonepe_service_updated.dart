import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class PhonePeService {
  // PhonePe Configuration - Test Environment
  static const String merchantId = 'M110NES2UDXSUAT';
  static const String saltKey = '5afb2d8c-5572-47cf-a5a0-93bb79647ffa';
  static const String saltIndex = '1';
  static const bool isTestMode = true;
  static const String baseUrl = 'https://api-preprod.phonepe.com/apis/hermes';
  static const String callbackUrl = 'https://yourapp.com/payment/callback';

  // PhonePe Configuration - Production Environment
  static const String prodMerchantId = 'YOUR_MERCHANT_ID_HERE';
  static const String prodSaltKey = 'YOUR_SALT_KEY_HERE';
  static const String prodSaltIndex = '1';
  static const String prodBaseUrl = 'https://api.phonepe.com/apis/hermes';
  static const String prodCallbackUrl = 'https://yourapp.com/payment/callback';

  // Get appropriate base URL based on environment
  static String get currentBaseUrl => isTestMode ? baseUrl : prodBaseUrl;

  // Generate checksum for PhonePe API
  static String generateChecksum(String payload) {
    final bytes = utf8.encode(payload + saltKey);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Create payment request
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
        "amount": (amount * 100).toInt(),
        "redirectUrl": callbackUrl,
        "redirectMode": "POST",
        "callbackUrl": callbackUrl,
        "mobileNumber": mobileNumber ?? "",
        "email": email ?? "",
        "paymentInstrument": {
          "type": "PAY_PAGE"
        }
      };

      final base64Payload = base64.encode(utf8.encode(json.encode(payload)));
      final checksum = generateChecksum(base64Payload) + "###$saltIndex";

      final requestBody = {
        "request": base64Payload,
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

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return {
          'success': true,
          'data': responseData,
          'redirectUrl': responseData['data']['instrumentResponse']['redirectInfo']['url']
        };
      } else {
        return {
          'success': false,
          'error': 'Payment initiation failed: ${response.body}'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error initiating payment: $e'
      };
    }
  }

  // Check payment status
  static Future<Map<String, dynamic>> checkPaymentStatus(String merchantTransactionId) async {
    try {
      final checksumString = "/pg/v1/status/$merchantId/$merchantTransactionId$saltKey";
      final checksum = sha256.convert(utf8.encode(checksumString)).toString() + "###$saltIndex";

      final response = await http.get(
        Uri.parse('$currentBaseUrl/pg/v1/status/$merchantId/$merchantTransactionId'),
        headers: {
          'Content-Type': 'application/json',
          'X-VERIFY': checksum,
          'X-MERCHANT-ID': merchantId,
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return {
          'success': true,
          'data': responseData,
          'status': responseData['data']['state']
        };
    } else {
      return {
        'success': false,
        'error': 'Failed to check payment status'
      };
    }
  } catch (e) {
    return {
      'success': false,
      'error': 'Error checking payment status: $e'
    };
  }
}

// Generate unique transaction ID
static String generateTransactionId() {
  return 'TXN_${DateTime.now().millisecondsSinceEpoch}_${(1000 + (DateTime.now().millisecond)).toString().padLeft(4, '0')}';
}
}
