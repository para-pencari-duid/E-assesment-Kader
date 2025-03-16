// To parse this JSON data, do
//
//     final submodulListResponse = submodulListResponseFromJson(jsonString);

import 'dart:convert';

import 'package:e_assesment_kader_app/data/models/modul_model.dart';

SubmodulListResponse submodulListResponseFromJson(String str) =>
    SubmodulListResponse.fromJson(json.decode(str));

String submodulListResponseToJson(SubmodulListResponse data) =>
    json.encode(data.toJson());

class SubmodulListResponse {
  final String? message;
  final ModulModel? modulModel;

  SubmodulListResponse({
    this.message,
    this.modulModel,
  });

  factory SubmodulListResponse.fromJson(Map<String, dynamic> json) =>
      SubmodulListResponse(
        message: json["message"],
        modulModel: json["kompetensi"] == null
            ? null
            : ModulModel.fromJson(json["kompetensi"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "kompetensi": modulModel?.toJson(),
      };
}
