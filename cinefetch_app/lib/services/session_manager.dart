import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _loginTimeKey = 'login_time';
  static const String _tempUserDataKey = 'temp_user_data';
  static const String _emailVerifiedKey = 'email_verified';
  static const String _profileCreatedKey = 'profile_created';
  static const String _registrationUserIdKey = 'registration_user_id';
  static const int _sessionDurationHours = 48;

  static Future<void> createSession(String userId, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_loginTimeKey, DateTime.now().toIso8601String());
    await prefs.remove(_emailVerifiedKey);
    await prefs.remove(_profileCreatedKey);
    await prefs.remove(_tempUserDataKey);
    await prefs.remove(_registrationUserIdKey);
  }

  static Future<Map<String, String>?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_userIdKey);
    final username = prefs.getString(_usernameKey);
    final loginTimeStr = prefs.getString(_loginTimeKey);

    if (userId == null || username == null || loginTimeStr == null) {
      return null;
    }

    final loginTime = DateTime.parse(loginTimeStr);
    final currentTime = DateTime.now();
    final difference = currentTime.difference(loginTime).inHours;

    if (difference > _sessionDurationHours) {
      await clearSession();
      return null;
    }

    return {
      'userId': userId,
      'username': username,
    };
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_loginTimeKey);
  }

  static Future<void> setTempUserData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tempUserDataKey, json.encode(data));
  }

  static Future<Map<String, dynamic>?> getTempUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_tempUserDataKey);
    return data != null ? json.decode(data) : null;
  }

  static Future<void> clearTempUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tempUserDataKey);
  }

  static Future<void> setEmailVerified(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_emailVerifiedKey, value);
  }

  static Future<bool> isEmailVerified() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_emailVerifiedKey) ?? false;
  }

  static Future<void> setProfileCreated(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_profileCreatedKey, value);
  }

  static Future<bool> isProfileCreated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_profileCreatedKey) ?? false;
  }

  static Future<void> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_registrationUserIdKey, userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_registrationUserIdKey);
  }

  static Future<bool> isInRegistrationFlow() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_registrationUserIdKey) != null && 
           prefs.getString(_tempUserDataKey) != null;
  }
}