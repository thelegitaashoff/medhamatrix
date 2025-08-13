import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/signup_request.dart';
import '../models/login_request.dart';
import '../models/api_response.dart';

class ApiService {
  static const String baseUrl = 'https://medhamatrix.com/api/auth';
  static const Duration timeoutDuration = Duration(seconds: 30);
  static const int maxRetries = 3;

  // Handle HTTP POST requests
  static Future<ApiResponse<Map<String, dynamic>>> signup(
      SignupRequest signupData) async {
    try {
      // Debug: Log the request
      print('Signup Request: ${signupData.toJson()}');

      // Map fields to match backend expectation
      final mappedSignupData = {
        'full_name': signupData.fullName,
        'email': signupData.email,
        'mobile': signupData.mobile,
        'dob': signupData.dob,
        'role': signupData.role,
        'password': signupData.password,
      };

      final response = await _makeRequest(
        method: 'POST',
        endpoint: '$baseUrl/studentRegistration/',
        body: mappedSignupData,
      );

      // Debug: Log the response
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse(
        success: false,
        message: 'No internet connection. Please check your network and try again.',
        data: null,
      );
    } on FormatException {
      return ApiResponse(
        success: false,
        message: 'Invalid response format from server',
        data: null,
      );
    } on TimeoutException {
      return ApiResponse(
        success: false,
        message: 'Request timeout. Please check your connection and try again.',
        data: null,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Registration failed: ${e.toString()}',
        data: null,
      );
    }
  }

  // Handle login API calls
  static Future<ApiResponse<Map<String, dynamic>>> login(
      LoginRequest loginData) async {
    try {
      print('Login Request: ${loginData.toJson()}');
      final response = await _makeRequest(
        method: 'POST',
        endpoint: '$baseUrl/api/token/',
        body: loginData.toJson(),
      );
      print('Login Response Status: ${response.statusCode}');
      print('Login Response Body: ${response.body}');
      return _handleResponse(response);
    } on SocketException {
      return ApiResponse(
        success: false,
        message: 'No internet connection. Please check your network and try again.',
        data: null,
      );
    } on FormatException {
      return ApiResponse(
        success: false,
        message: 'Invalid response format from server',
        data: null,
      );
    } on TimeoutException {
      return ApiResponse(
        success: false,
        message: 'Request timeout. Please check your connection and try again.',
        data: null,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Login failed: ${e.toString()}',
        data: null,
      );
    }
  }

  // Centralized HTTP request handler
  static Future<http.Response> _makeRequest({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?headers,
    };

    final uri = Uri.parse(endpoint);
    http.Response response;

    // Retry mechanism
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        switch (method.toUpperCase()) {
          case 'POST':
            response = await http.post(
              uri,
              headers: requestHeaders,
              body: json.encode(body),
            ).timeout(timeoutDuration);
            break;
          case 'GET':
            response = await http.get(
              uri,
              headers: requestHeaders,
            ).timeout(timeoutDuration);
            break;
          case 'PUT':
            response = await http.put(
              uri,
              headers: requestHeaders,
              body: json.encode(body),
            ).timeout(timeoutDuration);
            break;
          default:
            throw UnsupportedError('HTTP method $method not supported');
        }
        
        // If we get a successful response, return it
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response;
        }
        
        // If it's a server error (5xx), retry
        if (response.statusCode >= 500 && attempt < maxRetries) {
          print('Server error ${response.statusCode}, retrying... (attempt $attempt)');
          await Future.delayed(Duration(seconds: attempt));
          continue;
        }
        
        return response;
        
      } on SocketException catch (e) {
        if (attempt == maxRetries) rethrow;
        print('Network error, retrying... (attempt $attempt): $e');
        await Future.delayed(Duration(seconds: attempt));
      } on TimeoutException catch (e) {
        if (attempt == maxRetries) rethrow;
        print('Timeout error, retrying... (attempt $attempt): $e');
        await Future.delayed(Duration(seconds: attempt));
      }
    }
    
    throw Exception('Max retries exceeded');
  }

  // Handle API response
  static ApiResponse<Map<String, dynamic>> _handleResponse(http.Response response) {
    try {
      final responseData = json.decode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(
          success: true,
          message: responseData['message'] ?? 'Request successful',
          data: responseData,
        );
      } else if (response.statusCode == 400) {
        String errorMessage = 'Request failed';
        
        if (responseData['message'] != null) {
          errorMessage = responseData['message'];
        } else if (responseData['errors'] != null) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          final errorList = <String>[];
          errors.forEach((key, value) {
            if (value is List) {
              errorList.addAll(value.map((e) => '$key: $e'));
            } else {
              errorList.add('$key: $value');
            }
          });
          errorMessage = errorList.join('\n');
        }
        
        return ApiResponse(
          success: false,
          message: errorMessage,
          data: responseData,
        );
      } else {
        return ApiResponse(
          success: false,
          message: responseData['message'] ?? 'Request failed (Status: ${response.statusCode})',
          data: responseData,
        );
      }
    } on FormatException {
      return ApiResponse(
        success: false,
        message: 'Invalid JSON response from server',
        data: null,
      );
    }
  }

  // Check internet connectivity
  static Future<bool> checkInternetConnection() async {
    try {
      // Try multiple reliable hosts
      final hosts = ['google.com', '8.8.8.8', 'cloudflare.com'];
      
      for (String host in hosts) {
        try {
          final result = await InternetAddress.lookup(host).timeout(Duration(seconds: 5));
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('Internet connection verified via $host');
            return true;
          }
        } catch (e) {
          print('Failed to connect to $host: $e');
          continue;
        }
      }
      return false;
    } on SocketException catch (e) {
      print('SocketException during internet check: $e');
      return false;
    } catch (e) {
      print('Error checking internet connection: $e');
      return false;
    }
  }

  // Get user profile
  static Future<ApiResponse<Map<String, dynamic>>> getUserProfile(String? token) async {
    try {
      print('Fetching user profile...');
      
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      
      // Add authorization header if token is provided
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/userProfile/'),
        headers: headers,
      ).timeout(timeoutDuration);
      
      print('Profile Response Status: ${response.statusCode}');
      print('Profile Response Body: ${response.body}');
      
      return _handleResponse(response);
    } on SocketException {
      return ApiResponse(
        success: false,
        message: 'No internet connection. Please check your network and try again.',
        data: null,
      );
    } on FormatException {
      return ApiResponse(
        success: false,
        message: 'Invalid response format from server',
        data: null,
      );
    } on TimeoutException {
      return ApiResponse(
        success: false,
        message: 'Request timeout. Please check your connection and try again.',
        data: null,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Failed to fetch profile: ${e.toString()}',
        data: null,
      );
    }
  }

  // Update user profile
  static Future<ApiResponse<Map<String, dynamic>>> updateUserProfile(
      Map<String, dynamic> profileData, String? token) async {
    try {
      print('Updating user profile: $profileData');
      
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      
      // Add authorization header if token is provided
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
      
      final response = await _makeRequest(
        method: 'PUT',
        endpoint: '$baseUrl/userProfile/',
        body: profileData,
        headers: headers,
      );
      
      print('Update Profile Response Status: ${response.statusCode}');
      print('Update Profile Response Body: ${response.body}');
      
      return _handleResponse(response);
    } on SocketException {
      return ApiResponse(
        success: false,
        message: 'No internet connection. Please check your network and try again.',
        data: null,
      );
    } on FormatException {
      return ApiResponse(
        success: false,
        message: 'Invalid response format from server',
        data: null,
      );
    } on TimeoutException {
      return ApiResponse(
        success: false,
        message: 'Request timeout. Please check your connection and try again.',
        data: null,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Failed to update profile: ${e.toString()}',
        data: null,
      );
    }
  }

  // Test API connectivity
  static Future<bool> testApiConnection() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(Duration(seconds: 10));
      
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print('API connection test failed: $e');
      return false;
    }
  }
}
