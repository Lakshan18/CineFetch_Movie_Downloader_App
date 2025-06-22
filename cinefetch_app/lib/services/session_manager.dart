import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SessionManager {
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _loginTimeKey = 'login_time';
  static const int _sessionDurationHours = 48;

  static Future<void> createSession(String userId, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_loginTimeKey, DateTime.now().toIso8601String());
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
}