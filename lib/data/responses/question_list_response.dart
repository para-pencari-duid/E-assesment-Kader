// To parse this JSON data, do
//
//     final questionListResponse = questionListResponseFromJson(jsonString);

import 'dart:convert';

import 'package:e_assesment_kader_app/data/models/pertanyaan_model.dart';

QuestionListResponse questionListResponseFromJson(String str) =>
    QuestionListResponse.fromJson(json.decode(str));

String questionListResponseToJson(QuestionListResponse data) =>
    json.encode(data.toJson());

class QuestionListResponse {
  final String? message;
  final Keterampilan? keterampilan;

  QuestionListResponse({
    this.message,
    this.keterampilan,
  });

  factory QuestionListResponse.fromJson(Map<String, dynamic> json) =>
      QuestionListResponse(
        message: json["message"],
        keterampilan: json["keterampilan"] == null
            ? null
            : Keterampilan.fromJson(json["keterampilan"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "keterampilan": keterampilan?.toJson(),
      };
}

class Keterampilan {
  final int? id;
  final int? kompetensiId;
  final String? nama;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<PertanyaanModel>? pertanyaans;

  Keterampilan({
    this.id,
    this.kompetensiId,
    this.nama,
    this.createdAt,
    this.updatedAt,
    this.pertanyaans,
  });

  factory Keterampilan.fromJson(Map<String, dynamic> json) => Keterampilan(
        id: json["id"],
        kompetensiId: json["kompetensi_id"],
        nama: json["nama"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        pertanyaans: json["pertanyaans"] == null
            ? []
            : List<PertanyaanModel>.from(
                json["pertanyaans"]!.map((x) => PertanyaanModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kompetensi_id": kompetensiId,
        "nama": nama,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "pertanyaans": pertanyaans == null
            ? []
            : List<dynamic>.from(pertanyaans!.map((x) => x.toJson())),
      };
}
