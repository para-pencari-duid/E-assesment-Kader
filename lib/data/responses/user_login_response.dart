// To parse this JSON data, do
//
//     final userLoginResponse = userLoginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:e_assesment_kader_app/data/models/user_model.dart';

UserLoginResponse userLoginResponseFromJson(String str) =>
    UserLoginResponse.fromJson(json.decode(str));

String userLoginResponseToJson(UserLoginResponse data) =>
    json.encode(data.toJson());

class UserLoginResponse {
  final String? message;
  final String? token;
  final UserModel? users;

  UserLoginResponse({
    this.message,
    this.token,
    this.users,
  });

  factory UserLoginResponse.fromJson(Map<String, dynamic> json) =>
      UserLoginResponse(
        message: json["message"],
        token: json["token"],
        users: json["users"] == null ? null : UserModel.fromJson(json["users"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "token": token,
        "users": users?.toJson(),
      };
}
