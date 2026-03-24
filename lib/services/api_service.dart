import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/signup_request.dart';
import '../models/login_request.dart';
import '../models/api_response.dart';

class ApiService {
  static const String baseUrl = 'https://medhamatrix.com/auth/api/auth';
  static const String signupEndpoint = '$baseUrl/studentRegistration/';
  static const String loginEndpoint = 'https://medhamatrix.com/auth/api/auth/api/token/';
  static const String userProfileEndpoint = '$baseUrl/userProfile/';
  static const String schoolCollegeNameEndpoint = '$baseUrl/schoolClgName';
  static const String iqQuestionsEndpoint = 'https://medhamatrix.com/tests/api/iqtest/questions/';
  static const List<String> loginEndpoints = [
    loginEndpoint,
    'https://medhamatrix.com/api/token/',
    '$baseUrl/token/',
    '$baseUrl/login/',
    'https://medhamatrix.com/api/login/',
  ];
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
        endpoint: signupEndpoint,
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
      http.Response? lastResponse;

      for (final endpoint in loginEndpoints) {
        final response = await _makeRequest(
          method: 'POST',
          endpoint: endpoint,
          body: loginData.toJson(),
        );

        print('Login Endpoint Tried: $endpoint');
        print('Login Response Status: ${response.statusCode}');
        print('Login Response Body: ${response.body}');

        lastResponse = response;

        if (response.statusCode >= 200 && response.statusCode < 300) {
          return _handleResponse(response);
        }

        if (response.statusCode != 404 && response.statusCode != 405) {
          return _handleResponse(response);
        }
      }

      if (lastResponse != null) {
        return _handleResponse(lastResponse);
      }

      return ApiResponse(
        success: false,
        message: 'Login failed: no login endpoint responded successfully.',
        data: null,
      );
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
              body: body == null ? null : json.encode(body),
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
              body: body == null ? null : json.encode(body),
            ).timeout(timeoutDuration);
            break;
          case 'PATCH':
            response = await http.patch(
              uri,
              headers: requestHeaders,
              body: body == null ? null : json.encode(body),
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
      final resolvedMessage = _extractResponseMessage(responseData);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(
          success: true,
          message: resolvedMessage ?? 'Request successful',
          data: responseData,
        );
      } else if (response.statusCode == 400) {
        String errorMessage = 'Request failed';
        
        if (resolvedMessage != null && resolvedMessage.isNotEmpty) {
          errorMessage = resolvedMessage;
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
          message: resolvedMessage ?? 'Request failed (Status: ${response.statusCode})',
          data: responseData,
        );
      }
    } on FormatException {
      final contentType = response.headers['content-type'] ?? '';
      final hasHtmlBody = response.body.toLowerCase().contains('<html');
      final genericMessage = response.statusCode == 405
          ? 'Request failed with 405 Not Allowed. Please verify the API endpoint and HTTP method.'
          : 'Invalid response format from server';

      return ApiResponse(
        success: false,
        message: contentType.contains('text/html') || hasHtmlBody
            ? genericMessage
            : 'Invalid JSON response from server',
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
      
      final response = await _makeRequest(
        method: 'POST',
        endpoint: userProfileEndpoint,
        headers: headers,
      );
      
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
        method: 'PATCH',
        endpoint: userProfileEndpoint,
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

  static String? _extractResponseMessage(dynamic responseData) {
    if (responseData is! Map) return null;

    final message = responseData['message'] ??
        responseData['msg'] ??
        responseData['detail'] ??
        responseData['error'];

    return message is String && message.trim().isNotEmpty ? message.trim() : null;
  }

  static Map<String, String> _buildAuthorizedJsonHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Map<String, String> _buildAuthorizedHeaders(String token) {
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static String _maskToken(String token) {
    if (token.length <= 10) return '${token.substring(0, token.length > 4 ? 4 : token.length)}...';
    return '${token.substring(0, 6)}...${token.substring(token.length - 4)}';
  }

  static Future<ApiResponse<Map<String, dynamic>>> getSchoolCollegeNames(
    String? token,
  ) async {
    try {
      final headers = <String, String>{
        'Accept': 'application/json',
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await _makeRequest(
        method: 'GET',
        endpoint: schoolCollegeNameEndpoint,
        headers: headers,
      );

      print('School List Response Status: ${response.statusCode}');
      print('School List Response Body: ${response.body}');

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
        message: 'Failed to fetch school list: ${e.toString()}',
        data: null,
      );
    }
  }

  // Get IQ test questions
  static Future<ApiResponse<Map<String, dynamic>>> getIqQuestions(String? token) async {
    if (token == null || token.isEmpty) {
      return ApiResponse(
        success: false,
        message: 'Authorization bearer token is required.',
        data: null,
      );
    }

    try {
      print('Fetching IQ test questions...');
      print('IQ token present: true');
      print('IQ token preview: ${_maskToken(token)}');

      final response = await _makeRequest(
        method: 'GET',
        endpoint: iqQuestionsEndpoint,
        headers: _buildAuthorizedHeaders(token),
      );

      print('IQ Questions Response Status: ${response.statusCode}');
      print('IQ Questions Response Body: ${response.body}');

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
        message: 'Failed to fetch IQ questions: ${e.toString()}',
        data: null,
      );
    }
  }

  // Submit IQ test answers
  static Future<ApiResponse<Map<String, dynamic>>> submitIqAnswers(
    String? token,
    String studentName,
    int age,
    List<Map<String, dynamic>> answers,
  ) async {
    if (token == null || token.isEmpty) {
      return ApiResponse(
        success: false,
        message: 'Authorization bearer token is required.',
        data: null,
      );
    }

    try {
      print('Submitting IQ test answers...');
      print('IQ submit token present: true');
      print('IQ submit token preview: ${_maskToken(token)}');

      final response = await _makeRequest(
        method: 'POST',
        endpoint: iqQuestionsEndpoint,
        headers: _buildAuthorizedJsonHeaders(token),
        body: {
          'student_name': studentName,
          'age': age,
          'answers': answers,
        },
      );

      print('IQ Submit Response Status: ${response.statusCode}');
      print('IQ Submit Response Body: ${response.body}');

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
        message: 'Failed to submit IQ answers: ${e.toString()}',
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
