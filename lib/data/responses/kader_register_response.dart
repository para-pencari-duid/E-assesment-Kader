// To parse this JSON data, do
//
//     final registerKaderResponse = registerKaderResponseFromJson(jsonString);

import 'dart:convert';

import 'package:e_assesment_kader_app/data/models/user_model.dart';

RegisterKaderResponse registerKaderResponseFromJson(String str) =>
    RegisterKaderResponse.fromJson(json.decode(str));

String registerKaderResponseToJson(RegisterKaderResponse data) =>
    json.encode(data.toJson());

class RegisterKaderResponse {
  final String? message;
  final UserModel? kader;
  final String? error;

  RegisterKaderResponse({
    this.message,
    this.kader,
    this.error,
  });

  factory RegisterKaderResponse.fromJson(Map<String, dynamic> json) =>
      RegisterKaderResponse(
        message: json["message"],
        kader: json["kader"] == null ? null : UserModel.fromJson(json["kader"]),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "kader": kader?.toJson(),
        "error": error,
      };
}
