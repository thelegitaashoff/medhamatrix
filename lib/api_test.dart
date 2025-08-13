import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/login_request.dart';
import 'models/signup_request.dart';

class ApiTestPage extends StatefulWidget {
  @override
  _ApiTestPageState createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {
  String _testResults = '';
  bool _isLoading = false;

  Future<void> _testApiConnectivity() async {
    setState(() {
      _isLoading = true;
      _testResults = 'Testing API connectivity...\n';
    });

    try {
      // Test internet connection
      final hasInternet = await ApiService.checkInternetConnection();
      setState(() {
        _testResults += 'Internet Connection: ${hasInternet ? '✓ Connected' : '✗ Failed'}\n';
      });

      // Test API connection
      final apiConnected = await ApiService.testApiConnection();
      setState(() {
        _testResults += 'API Connection: ${apiConnected ? '✓ Connected' : '✗ Failed'}\n';
      });

      setState(() {
        _testResults += '\n--- API Endpoints ---\n';
        _testResults += 'Base URL: https://medhamatrix.com/api/auth\n';
        _testResults += 'Signup: ${ApiService.baseUrl}/studentRegistration/\n';
        _testResults += 'Login: ${ApiService.baseUrl}/api/token/\n';
      });

    } catch (e) {
      setState(() {
        _testResults += 'Error: ${e.toString()}\n';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testSignupEndpoint() async {
    setState(() {
      _isLoading = true;
      _testResults += '\n--- Testing Signup Endpoint ---\n';
    });

    try {
      final testSignupRequest = SignupRequest(
        fullName: 'Test User',
        dob: '1990-01-01',
        mobile: '1234567890',
        email: 'test@example.com',
        password: 'testpass123',
      );

      // Note: This is just testing the request structure, not actually registering
      setState(() {
        _testResults += 'Signup request structure: ✓ Valid\n';
        _testResults += 'Request payload: ${testSignupRequest.toJson()}\n';
      });

    } catch (e) {
      setState(() {
        _testResults += 'Signup test error: ${e.toString()}\n';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testLoginEndpoint() async {
    setState(() {
      _isLoading = true;
      _testResults += '\n--- Testing Login Endpoint ---\n';
    });

    try {
      final testLoginRequest = LoginRequest(
        email: 'test@example.com',
        password: 'testpass123',
      );

      setState(() {
        _testResults += 'Login request structure: ✓ Valid\n';
        _testResults += 'Request payload: ${testLoginRequest.toJson()}\n';
      });

    } catch (e) {
      setState(() {
        _testResults += 'Login test error: ${e.toString()}\n';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Integration Test'),
        backgroundColor: Color.fromARGB(250, 57, 201, 245),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'API Integration Status',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            
            // Test buttons
            ElevatedButton(
              onPressed: _isLoading ? null : _testApiConnectivity,
              child: Text('Test API Connectivity'),
            ),
            SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _testSignupEndpoint,
              child: Text('Test Signup Structure'),
            ),
            SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _testLoginEndpoint,
              child: Text('Test Login Structure'),
            ),
            SizedBox(height: 20),
            
            // Results section
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Text(
                          _testResults.isEmpty ? 'No tests run yet.' : _testResults,
                          style: TextStyle(fontFamily: 'monospace'),
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
