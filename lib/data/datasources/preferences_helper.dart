import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final SharedPreferences _preferences;

  PreferencesHelper(this._preferences);

  static const String _keyToken = "MY_TOKEN";
  static const String _keyUsername = "MY_USER";

  // simpan token
  Future<void> saveToken(String token) async {
    try {
      await _preferences.setString(_keyToken, token);
    } catch (e) {
      throw Exception("Shared preferences cannot save the value.");
    }
  }

  Future<String?> getSavedToken() async {
    try {
      return _preferences.getString(_keyToken);
    } catch (e) {
      print("Error fetching saved token: $e");
      return null;
    }
  }

  Future<void> removeSavedToken() async {
    try {
      await _preferences.remove(_keyToken);
    } catch (e) {
      print("Error removing service: $e");
    }
  }

  // simpan user
  Future<void> saveUsername(String username) async {
    try {
      await _preferences.setString(_keyUsername, username);
    } catch (e) {
      throw Exception("Shared preferences cannot save the value.");
    }
  }

  Future<String?> getSavedUsername() async {
    try {
      return _preferences.getString(_keyUsername);
    } catch (e) {
      print("Error fetching saved username: $e");
      return null;
    }
  }

  Future<void> removeSavedUsername() async {
    try {
      await _preferences.remove(_keyUsername);
    } catch (e) {
      print("Error removing service: $e");
    }
  }
}
