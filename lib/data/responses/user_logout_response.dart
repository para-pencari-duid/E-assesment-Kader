// To parse this JSON data, do
//
//     final userLogoutResponse = userLogoutResponseFromJson(jsonString);

import 'dart:convert';

UserLogoutResponse userLogoutResponseFromJson(String str) =>
    UserLogoutResponse.fromJson(json.decode(str));

String userLogoutResponseToJson(UserLogoutResponse data) =>
    json.encode(data.toJson());

class UserLogoutResponse {
  final String? message;

  UserLogoutResponse({
    this.message,
  });

  factory UserLogoutResponse.fromJson(Map<String, dynamic> json) =>
      UserLogoutResponse(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
