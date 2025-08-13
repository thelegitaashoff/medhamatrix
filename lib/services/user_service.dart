import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class UserService {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';
  static UserModel? _currentUser;
  static String? _authToken;
  
  // Get current user
  static UserModel? get currentUser => _currentUser;
  
  // Set current user and save to storage
  static Future<void> setCurrentUser(UserModel user) async {
    _currentUser = user;
    await _saveUserToStorage(user);
  }
  
  // Update current user
  static Future<void> updateCurrentUser({
    String? fullName,
    int? age,
    String? birthday,
    String? school,
    String? email,
    String? phone,
  }) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        fullName: fullName,
        age: age,
        birthday: birthday,
        school: school,
        email: email,
        phone: phone,
      );
      await _saveUserToStorage(_currentUser!);
    }
  }
  
  // Load user from storage
  static Future<void> loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        final userData = jsonDecode(userJson);
        _currentUser = UserModel.fromJson(userData);
      } else {
        // Set default user if no data exists
        _currentUser = UserModel(
          fullName: 'Emily Clark',
          age: 24,
          birthday: '08/12/2000',
          school: 'Maplewood High School',
          email: 'emily.clark@email.com',
          phone: '+1 234 567 8910',
        );
        await _saveUserToStorage(_currentUser!);
      }
    } catch (e) {
      print('Error loading user data: $e');
      // Fallback to default user
      _currentUser = UserModel(
        fullName: 'Emily Clark',
        age: 24,
        birthday: '08/12/2000',
        school: 'Maplewood High School',
        email: 'emily.clark@email.com',
        phone: '+1 234 567 8910',
      );
    }
  }
  
  // Save user to storage
  static Future<void> _saveUserToStorage(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toJson());
      await prefs.setString(_userKey, userJson);
    } catch (e) {
      print('Error saving user data: $e');
    }
  }
  
  // Clear user data (for logout)
  static Future<void> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      _currentUser = null;
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }
  
  // Token management
  static String? get authToken => _authToken;
  
  // Set auth token
  static Future<void> setAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
  
  // Load auth token
  static Future<void> loadAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _authToken = prefs.getString(_tokenKey);
    } catch (e) {
      print('Error loading auth token: $e');
    }
  }
  
  // Clear auth token
  static Future<void> clearAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      _authToken = null;
    } catch (e) {
      print('Error clearing auth token: $e');
    }
  }
  
  // Fetch user profile from API
  static Future<bool> fetchUserProfileFromAPI() async {
    try {
      final response = await ApiService.getUserProfile(_authToken);
      if (response.success && response.data != null) {
        // Parse the response data and create UserModel
        final profileData = response.data!;
        _currentUser = UserModel(
          fullName: profileData['full_name'] ?? profileData['name'] ?? 'User',
          age: _parseAge(profileData['age'] ?? profileData['dob']),
          birthday: profileData['dob'] ?? profileData['birthday'] ?? '',
          school: profileData['school'] ?? profileData['institution'] ?? '',
          email: profileData['email'] ?? '',
          phone: profileData['mobile'] ?? profileData['phone'] ?? '',
        );
        await _saveUserToStorage(_currentUser!);
        return true;
      } else {
        print('Failed to fetch profile: ${response.message}');
        return false;
      }
    } catch (e) {
      print('Error fetching profile from API: $e');
      return false;
    }
  }
  
  // Update user profile via API
  static Future<bool> updateUserProfileToAPI({
    String? fullName,
    int? age,
    String? birthday,
    String? school,
    String? email,
    String? phone,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (fullName != null) updateData['full_name'] = fullName;
      if (age != null) updateData['age'] = age;
      if (birthday != null) updateData['dob'] = birthday;
      if (school != null) updateData['school'] = school;
      if (email != null) updateData['email'] = email;
      if (phone != null) updateData['mobile'] = phone;
      
      final response = await ApiService.updateUserProfile(updateData, _authToken);
      if (response.success) {
        // Update local data
        await updateCurrentUser(
          fullName: fullName,
          age: age,
          birthday: birthday,
          school: school,
          email: email,
          phone: phone,
        );
        return true;
      } else {
        print('Failed to update profile: ${response.message}');
        return false;
      }
    } catch (e) {
      print('Error updating profile via API: $e');
      return false;
    }
  }
  
  // Helper method to parse age from DOB or age field
  static int _parseAge(dynamic ageData) {
    if (ageData is int) return ageData;
    if (ageData is String) {
      // Try to parse age directly
      final age = int.tryParse(ageData);
      if (age != null) return age;
      
      // Try to calculate age from date of birth
      try {
        final dob = DateTime.parse(ageData);
        final now = DateTime.now();
        int calculatedAge = now.year - dob.year;
        if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
          calculatedAge--;
        }
        return calculatedAge;
      } catch (e) {
        return 0;
      }
    }
    return 0;
  }
  
  // Initialize user service (call this when app starts)
  static Future<void> initialize() async {
    await loadAuthToken();
    await loadUserFromStorage();
    
    // Try to fetch fresh data from API if token exists
    if (_authToken != null && _authToken!.isNotEmpty) {
      await fetchUserProfileFromAPI();
    }
  }
  
  // Get username (same as full name)
  static String get username => _currentUser?.username ?? 'User';
  
  // Get full name
  static String get fullName => _currentUser?.fullName ?? 'User';
}
