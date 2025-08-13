import 'package:flutter/material.dart';
import 'package:medhamatrix/services/api_service.dart';
import 'package:medhamatrix/models/login_request.dart';
import 'package:medhamatrix/models/signup_request.dart';

class ApiDebugPage extends StatefulWidget {
  @override
  _ApiDebugPageState createState() => _ApiDebugPageState();
}

class _ApiDebugPageState extends State<ApiDebugPage> {
  String _debugOutput = '';

  void _logOutput(String message) {
    setState(() {
      _debugOutput += '${DateTime.now().toLocal()}: $message\n';
    });
    print(message);
  }

  Future<void> _testInternetConnection() async {
    _logOutput('Testing internet connection...');
    try {
      bool hasConnection = await ApiService.checkInternetConnection();
      _logOutput('Internet connection: ${hasConnection ? 'CONNECTED' : 'DISCONNECTED'}');
    } catch (e) {
      _logOutput('Internet test failed: $e');
    }
  }

  Future<void> _testApiConnection() async {
    _logOutput('Testing API connectivity...');
    try {
      bool apiReachable = await ApiService.testApiConnection();
      _logOutput('API reachable: ${apiReachable ? 'YES' : 'NO'}');
    } catch (e) {
      _logOutput('API test failed: $e');
    }
  }

  Future<void> _testLogin() async {
    _logOutput('Testing login API...');
    try {
      final loginRequest = LoginRequest(
        email: 'test@example.com',
        password: 'testpassword',
      );

      final response = await ApiService.login(loginRequest);
      _logOutput('Login test result:');
      _logOutput('Success: ${response.success}');
      _logOutput('Message: ${response.message}');
      _logOutput('Data: ${response.data}');
    } catch (e) {
      _logOutput('Login test failed: $e');
    }
  }

  Future<void> _testSignup() async {
    _logOutput('Testing signup API...');
    try {
      final signupRequest = SignupRequest(
        fullName: 'Test User',
        email: 'test@example.com',
        mobile: '1234567890',
        dob: '1990-01-01',
        password: 'testpassword',
        role: 'student',
      );

      final response = await ApiService.signup(signupRequest);
      _logOutput('Signup test result:');
      _logOutput('Success: ${response.success}');
      _logOutput('Message: ${response.message}');
      _logOutput('Data: ${response.data}');
    } catch (e) {
      _logOutput('Signup test failed: $e');
    }
  }

  void _clearLog() {
    setState(() {
      _debugOutput = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Debug Test'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: _clearLog,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'API Debug Tools',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: _testInternetConnection,
                  child: Text('Test Internet'),
                ),
                ElevatedButton(
                  onPressed: _testApiConnection,
                  child: Text('Test API Connection'),
                ),
                ElevatedButton(
                  onPressed: _testLogin,
                  child: Text('Test Login'),
                ),
                ElevatedButton(
                  onPressed: _testSignup,
                  child: Text('Test Signup'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Debug Output:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _debugOutput.isEmpty ? 'No output yet...' : _debugOutput,
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12),
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
