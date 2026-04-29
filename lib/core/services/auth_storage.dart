import 'package:shared_preferences/shared_preferences.dart';
import '../enums/user_role.dart';

class AuthStorage {
  AuthStorage._();

  static const _keyLoggedIn = 'auth_logged_in';
  static const _keyRole = 'auth_role';

  /// Persists the session so the user stays logged in after closing the app.
  static Future<void> saveSession(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyRole, role.name);
  }

  /// Returns the saved [UserRole] if a session exists, otherwise null.
  static Future<UserRole?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(_keyLoggedIn) ?? false;
    if (!loggedIn) return null;
    final roleName = prefs.getString(_keyRole);
    if (roleName == null) return null;
    return UserRole.values.byName(roleName);
  }

  /// Clears the saved session on logout.
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn);
    await prefs.remove(_keyRole);
  }
}
