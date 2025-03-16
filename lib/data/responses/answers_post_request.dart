// To parse this JSON data, do
//
//     final answersPostRequest = answersPostRequestFromJson(jsonString);

import 'dart:convert';

AnswersPostRequest answersPostRequestFromJson(String str) =>
    AnswersPostRequest.fromJson(json.decode(str));

String answersPostRequestToJson(AnswersPostRequest data) =>
    json.encode(data.toJson());

class AnswersPostRequest {
  final List<Penilaian>? penilaian;

  AnswersPostRequest({
    this.penilaian,
  });

  factory AnswersPostRequest.fromJson(Map<String, dynamic> json) =>
      AnswersPostRequest(
        penilaian: json["penilaian"] == null
            ? []
            : List<Penilaian>.from(
                json["penilaian"]!.map((x) => Penilaian.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "penilaian": penilaian == null
            ? []
            : List<dynamic>.from(penilaian!.map((x) => x.toJson())),
      };
}

class Penilaian {
  final int? pertanyaanId;
  late final int? nilai;

  Penilaian({
    this.pertanyaanId,
    this.nilai,
  });

  factory Penilaian.fromJson(Map<String, dynamic> json) => Penilaian(
        pertanyaanId: json["pertanyaan_id"],
        nilai: json["nilai"],
      );

  Map<String, dynamic> toJson() => {
        "pertanyaan_id": pertanyaanId,
        "nilai": nilai,
      };
}
