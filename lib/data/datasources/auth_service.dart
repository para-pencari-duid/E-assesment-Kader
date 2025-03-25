import 'dart:convert';

import 'package:e_assesment_kader_app/data/models/user_model.dart';
import 'package:e_assesment_kader_app/data/responses/puskesmas_response.dart';
import 'package:e_assesment_kader_app/data/responses/user_login_response.dart';
import 'package:e_assesment_kader_app/data/responses/user_logout_response.dart';
import 'package:e_assesment_kader_app/data/responses/user_register_response.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = "https://kemenkes.tegararsyadani.my.id/api";

  Future<PuskesmasResponse> getPuskesmasList() async {
    final response = await http.get(Uri.parse("$_baseUrl/puskesmas"));

    if (response.statusCode == 200) {
      return PuskesmasResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load puskesmas list');
    }
  }

  Future<UserRegisterResponse> postRegisterUser(UserModel model) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/users/register"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 201) {
      return UserRegisterResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create account');
    }
  }

  Future<UserLoginResponse> postLoginUser(UserModel model) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/users/login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(model.loginToJson()),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return UserLoginResponse.fromJson(responseData);
      } else {
        return UserLoginResponse(
          message: responseData['message'] ?? 'Login failed',
          users: null,
          token: null,
        );
      }
    } catch (e) {
      return UserLoginResponse(
        message: 'An error occurred: ${e.toString()}',
        users: null,
        token: null,
      );
    }
  }

  Future<UserLogoutResponse> postLogoutUser(String token) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/users/logout"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return UserLogoutResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to logout account');
    }
  }
}
