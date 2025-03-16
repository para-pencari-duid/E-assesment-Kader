// To parse this JSON data, do
//
//     final puskesmasResponse = puskesmasResponseFromJson(jsonString);

import 'dart:convert';

import 'package:e_assesment_kader_app/data/models/puskesmas_model.dart';

PuskesmasResponse puskesmasResponseFromJson(String str) =>
    PuskesmasResponse.fromJson(json.decode(str));

String puskesmasResponseToJson(PuskesmasResponse data) =>
    json.encode(data.toJson());

class PuskesmasResponse {
  final int? total;
  final List<PuskesmasModel>? data;

  PuskesmasResponse({
    this.total,
    this.data,
  });

  factory PuskesmasResponse.fromJson(Map<String, dynamic> json) =>
      PuskesmasResponse(
        total: json["total"],
        data: json["data"] == null
            ? []
            : List<PuskesmasModel>.from(
                json["data"]!.map((x) => PuskesmasModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
