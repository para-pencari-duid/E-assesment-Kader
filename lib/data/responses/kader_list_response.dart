// To parse this JSON data, do
//
//     final kaderListResponse = kaderListResponseFromJson(jsonString);

import 'dart:convert';

import '../models/user_model.dart';

KaderListResponse kaderListResponseFromJson(String str) =>
    KaderListResponse.fromJson(json.decode(str));

String kaderListResponseToJson(KaderListResponse data) =>
    json.encode(data.toJson());

class KaderListResponse {
  final String? message;
  final int? totalKader;
  final int? currentPage;
  final int? perPage;
  final int? totalPages;
  final List<UserModel>? data;

  KaderListResponse({
    this.message,
    this.totalKader,
    this.currentPage,
    this.perPage,
    this.totalPages,
    this.data,
  });

  factory KaderListResponse.fromJson(Map<String, dynamic> json) =>
      KaderListResponse(
        message: json["message"],
        totalKader: json["total_kader"],
        currentPage: json["current_page"],
        perPage: json["per_page"],
        totalPages: json["total_pages"],
        data: json["data"] == null
            ? []
            : List<UserModel>.from(
                json["data"]!.map((x) => UserModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "total_kader": totalKader,
        "current_page": currentPage,
        "per_page": perPage,
        "total_pages": totalPages,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
