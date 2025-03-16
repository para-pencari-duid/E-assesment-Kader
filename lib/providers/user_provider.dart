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
      print("REGISTER body: $request");
      final result = await _authService.postRegisterUser(request);

      if (result.message != "User registered successfully") {
        _isLoading = false;
        _message = result.message!;
        print("REGISTER FAILED: $_message");
        notifyListeners();
        return false;
      } else {
        _isLoading = false;
        _message = result.message!;
        print("REGISTER SUCCESS: $_message");
        notifyListeners();
        return true;
      }
    } catch (e) {
      _message = e.toString();
      print("REGISTER EXCEPTION: $_message");
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

      if (result.message != "Login successful") {
        _isLoading = false;
        _message = result.message!;
        notifyListeners();
        return result;
        // return false;
      } else {
        _isLoading = false;
        _message = result.message!;
        _user = result.users;
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
      print("EXCEPTION: ${e.toString()}");
      throw Exception(e.toString());
      // return false;
    }
  }
}
