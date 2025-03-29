import 'package:e_assesment_kader_app/data/datasources/preferences_helper.dart';
import 'package:flutter/foundation.dart';

class PreferencesProvider extends ChangeNotifier {
  final PreferencesHelper _helper;

  PreferencesProvider(this._helper);

  Future<void> init() async {
    await loadUserToken();
    await loadUsername();
  }

  String? _userToken;
  String? get userToken => _userToken;

  String? _username;
  String? get username => _username;

  // save Token
  Future<void> saveUserToken(String token) async {
    try {
      await _helper.saveToken(token);
      if (_userToken != token) {
        _userToken = token;
        notifyListeners();
      }
    } catch (e) {
      notifyListeners();
    }
  }

  Future<void> loadUserToken() async {
    try {
      final token = await _helper.getSavedToken();
      if (_userToken != token) {
        _userToken = token;
        notifyListeners();
      }
    } catch (e) {
      print("Exception: $e");
      notifyListeners();
    }
  }

  Future<void> removeUserToken() async {
    try {
      await _helper.removeSavedToken();
      _userToken = null;
      notifyListeners();
    } catch (e) {
      print("Failed to remove service: $e");
      notifyListeners();
    }
  }

  // save Username
  Future<void> saveUsername(String username) async {
    try {
      await _helper.saveUsername(username);
      _username = username;

      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  Future<void> loadUsername() async {
    try {
      _username = await _helper.getSavedUsername();
      notifyListeners();
    } catch (e) {
      print("Exception: $e");
      notifyListeners();
    }
  }

  Future<void> removeUsername() async {
    try {
      await _helper.removeSavedUsername();
      _username = null;
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
