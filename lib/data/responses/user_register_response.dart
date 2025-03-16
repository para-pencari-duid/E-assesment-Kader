// To parse this JSON data, do
//
//     final userRegisterResponse = userRegisterResponseFromJson(jsonString);

import 'dart:convert';

UserRegisterResponse userRegisterResponseFromJson(String str) =>
    UserRegisterResponse.fromJson(json.decode(str));

String userRegisterResponseToJson(UserRegisterResponse data) =>
    json.encode(data.toJson());

class UserRegisterResponse {
  final String? message;
  final Users? users;

  UserRegisterResponse({
    this.message,
    this.users,
  });

  factory UserRegisterResponse.fromJson(Map<String, dynamic> json) =>
      UserRegisterResponse(
        message: json["message"],
        users: json["users"] == null ? null : Users.fromJson(json["users"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "users": users?.toJson(),
      };
}

class Users {
  final String? puskesmasId;
  final String? name;
  final String? email;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;

  Users({
    this.puskesmasId,
    this.name,
    this.email,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        puskesmasId: json["puskesmas_id"],
        name: json["name"],
        email: json["email"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "puskesmas_id": puskesmasId,
        "name": name,
        "email": email,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
      };
}
