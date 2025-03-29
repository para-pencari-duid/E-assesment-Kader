import 'package:e_assesment_kader_app/data/datasources/auth_service.dart';
import 'package:e_assesment_kader_app/data/responses/user_login_response.dart';
import 'package:e_assesment_kader_app/data/responses/user_logout_response.dart';
import 'package:flutter/foundation.dart';

import '../data/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final AuthService _authService;

  UserProvider(this._authService);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _message;
  String? get message => _message;

  UserModel? _user;
  UserModel? get user => _user;

  Future<bool> registerUser(UserModel request) async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    try {
      final result = await _authService.postRegisterUser(request);

      if (result.message != "User registered successfully") {
        _isLoading = false;
        _message = result.message!;
        notifyListeners();
        return false;
      } else {
        _isLoading = false;
        _message = result.message!;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _message = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<UserLoginResponse> loginUser(UserModel request) async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    try {
      final result = await _authService.postLoginUser(request);

      if (result.token == null || result.users == null) {
        _isLoading = false;
        _message = result.message ?? 'Login failed';
        notifyListeners();
        return result; // Pastikan tetap return result dengan pesan error
      }

      _isLoading = false;
      _message = result.message;
      _user = result.users;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      _message = 'An unexpected error occurred';
      notifyListeners();
      return UserLoginResponse(message: _message, users: null, token: null);
    }
  }

  Future<UserLogoutResponse> logoutUser(String token) async {
    _isLoading = true;
    _message = null;
    notifyListeners();

    try {
      final result = await _authService.postLogoutUser(token);

      if (result.message != "Logout successful") {
        _isLoading = false;
        _message = result.message!;
        notifyListeners();
        return result;
        // return false;
      } else {
        _isLoading = false;
        _message = result.message!;
        notifyListeners();
        return result;
        // return true;
      }
    } catch (e) {
      _message = e.toString();
      _isLoading = false;
      notifyListeners();
      throw Exception(e.toString());
      // return false;
    }
  }
}
