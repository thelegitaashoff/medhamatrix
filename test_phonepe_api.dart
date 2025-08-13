import 'lib/services/phonepe_service.dart';

void main() async {
  print('Testing PhonePe API Configuration...');
  print('Merchant ID: ${PhonePeService.merchantId}');
  print('Salt Key: ${PhonePeService.saltKey.substring(0, 8)}...');
  print('Base URL: ${PhonePeService.currentBaseUrl}');
  print('Test Mode: ${PhonePeService.isTestMode}');
  print('');

  try {
    final response = await PhonePeService.initiatePayment(
      merchantTransactionId: PhonePeService.generateTransactionId(),
      amount: 1.0,
      userId: 'TEST_USER_123',
      callbackUrl: 'https://webhook.site/test-callback',
      mobileNumber: '9999999999',
      email: 'test@example.com',
    );

    print('API Response:');
    print('Success: ${response['success']}');
    if (response['success']) {
      print('Payment initiated successfully!');
      print('Redirect URL: ${response['redirectUrl']}');
    } else {
      print('Error: ${response['error']}');
      print('Code: ${response['code']}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
