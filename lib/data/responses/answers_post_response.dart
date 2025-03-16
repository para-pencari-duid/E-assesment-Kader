// To parse this JSON data, do
//
//     final answersPostResponse = answersPostResponseFromJson(jsonString);

import 'dart:convert';

import 'package:e_assesment_kader_app/data/models/user_model.dart';

AnswersPostResponse answersPostResponseFromJson(String str) =>
    AnswersPostResponse.fromJson(json.decode(str));

String answersPostResponseToJson(AnswersPostResponse data) =>
    json.encode(data.toJson());

class AnswersPostResponse {
  final String? message;
  final String? kaderId;
  final UserModel? penilai;

  AnswersPostResponse({
    this.message,
    this.kaderId,
    this.penilai,
  });

  factory AnswersPostResponse.fromJson(Map<String, dynamic> json) =>
      AnswersPostResponse(
        message: json["message"],
        kaderId: json["kader_id"],
        penilai: json["penilai"] == null
            ? null
            : UserModel.fromJson(json["penilai"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "kader_id": kaderId,
        "penilai": penilai?.toJson(),
      };
}
