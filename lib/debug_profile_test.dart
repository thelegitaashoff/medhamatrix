import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'services/user_service.dart';

class DebugProfileTestPage extends StatefulWidget {
  @override
  _DebugProfileTestPageState createState() => _DebugProfileTestPageState();
}

class _DebugProfileTestPageState extends State<DebugProfileTestPage> {
  String _debugOutput = '';
  bool _isLoading = false;

  void _addDebugLine(String line) {
    setState(() {
      _debugOutput += '${DateTime.now().toIso8601String().substring(11, 19)}: $line\n';
    });
    print(line);
  }

  Future<void> _testUserServiceInitialization() async {
    _addDebugLine('=== Testing UserService Initialization ===');
    setState(() {
      _isLoading = true;
    });

    try {
      await UserService.initialize();
      _addDebugLine('UserService initialized');

      final token = UserService.authToken;
      _addDebugLine('Auth token: ${token != null ? 'Found (${token.length} chars)' : 'Not found'}');

      final user = UserService.currentUser;
      _addDebugLine('Current user: ${user != null ? user.fullName : 'Not found'}');

    } catch (e) {
      _addDebugLine('Error: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testAPIConnectivity() async {
    _addDebugLine('=== Testing API Connectivity ===');
    setState(() {
      _isLoading = true;
    });

    try {
      // Test internet connection
      final hasInternet = await ApiService.checkInternetConnection();
      _addDebugLine('Internet: ${hasInternet ? 'Connected' : 'Not connected'}');

      // Test API base connection
      final apiConnected = await ApiService.testApiConnection();
      _addDebugLine('API Base: ${apiConnected ? 'Connected' : 'Not connected'}');

    } catch (e) {
      _addDebugLine('Connectivity Error: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testDirectProfileAPI() async {
    _addDebugLine('=== Testing Direct Profile API Call ===');
    setState(() {
      _isLoading = true;
    });

    try {
      final token = UserService.authToken;
      _addDebugLine('Using token: ${token != null ? 'Yes' : 'No'}');

      final response = await ApiService.getUserProfile(token);
      _addDebugLine('API Response Success: ${response.success}');
      _addDebugLine('API Response Message: ${response.message}');
      _addDebugLine('API Response Data: ${response.data}');

    } catch (e) {
      _addDebugLine('Direct API Error: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testUserServiceProfileFetch() async {
    _addDebugLine('=== Testing UserService Profile Fetch ===');
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await UserService.fetchUserProfileFromAPI();
      _addDebugLine('UserService fetch result: $success');

      final user = UserService.currentUser;
      if (user != null) {
        _addDebugLine('User data after fetch:');
        _addDebugLine('  Full Name: ${user.fullName}');
        _addDebugLine('  Email: ${user.email}');
        _addDebugLine('  Age: ${user.age}');
        _addDebugLine('  Phone: ${user.phone}');
      } else {
        _addDebugLine('No user data available after fetch');
      }

    } catch (e) {
      _addDebugLine('UserService fetch error: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _clearDebugOutput() {
    setState(() {
      _debugOutput = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug Profile API'),
        backgroundColor: Color.fromARGB(250, 57, 201, 245),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: _clearDebugOutput,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Test buttons
            Wrap(
              spacing: 8.0,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _testUserServiceInitialization,
                  child: Text('Test Init'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testAPIConnectivity,
                  child: Text('Test API'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testDirectProfileAPI,
                  child: Text('Direct API'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testUserServiceProfileFetch,
                  child: Text('UserService'),
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            if (_isLoading)
              Center(child: CircularProgressIndicator()),
            
            // Debug output
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black87,
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _debugOutput.isEmpty ? 'No debug output yet. Tap a test button above.' : _debugOutput,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Colors.white,
                    ),
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
