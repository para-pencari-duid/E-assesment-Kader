// To parse this JSON data, do
//
//     final puskesmasModel = puskesmasModelFromJson(jsonString);

import 'dart:convert';

List<PuskesmasModel> puskesmasModelFromJson(String str) =>
    List<PuskesmasModel>.from(
        json.decode(str).map((x) => PuskesmasModel.fromJson(x)));

String puskesmasModelToJson(List<PuskesmasModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PuskesmasModel {
  final int? id;
  final String? nama;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PuskesmasModel({
    this.id,
    this.nama,
    this.createdAt,
    this.updatedAt,
  });

  factory PuskesmasModel.fromJson(Map<String, dynamic> json) => PuskesmasModel(
        id: json["id"],
        nama: json["name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
