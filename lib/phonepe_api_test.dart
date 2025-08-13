import 'dart:convert';
import 'package:flutter/material.dart';
import 'services/phonepe_service.dart';

class PhonePeApiTest extends StatefulWidget {
  const PhonePeApiTest({super.key});

  @override
  State<PhonePeApiTest> createState() => _PhonePeApiTestState();
}

class _PhonePeApiTestState extends State<PhonePeApiTest> {
  String _testResult = '';
  bool _isLoading = false;

  Future<void> _testApiConfiguration() async {
    setState(() {
      _isLoading = true;
      _testResult = 'Testing PhonePe API configuration...';
    });

    try {
      // Test with a small amount
      final response = await PhonePeService.initiatePayment(
        merchantTransactionId: PhonePeService.generateTransactionId(),
        amount: 1.0, // 1 rupee for testing
        userId: 'TEST_USER_123',
        callbackUrl: 'https://webhook.site/unique-callback-url',
        mobileNumber: '9999999999',
        email: 'test@example.com',
      );

      setState(() {
        _testResult = '''
API Test Result:
Success: ${response['success']}
${response['success'] ? 'API Configuration is working!' : 'Error: ${response['error']}'}

Response Details:
${JsonEncoder.withIndent('  ').convert(response)}
        ''';
      });
    } catch (e) {
      setState(() {
        _testResult = 'Error testing API: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PhonePe API Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Configuration:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Merchant ID: ${PhonePeService.merchantId}'),
                    Text('Salt Key: ${PhonePeService.saltKey.substring(0, 8)}...'),
                    Text('Salt Index: ${PhonePeService.saltIndex}'),
                    Text('Base URL: ${PhonePeService.currentBaseUrl}'),
                    Text('Test Mode: ${PhonePeService.isTestMode}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _testApiConfiguration,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('Testing...'),
                      ],
                    )
                  : const Text('Test API Configuration'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Test Results:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            _testResult.isEmpty ? 'Click "Test API Configuration" to check your setup' : _testResult,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
