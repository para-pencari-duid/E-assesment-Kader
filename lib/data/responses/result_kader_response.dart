// To parse this JSON data, do
//
//     final resultKaderResponse = resultKaderResponseFromJson(jsonString);

import 'dart:convert';

import 'package:e_assesment_kader_app/data/models/puskesmas_model.dart';

ResultKaderResponse resultKaderResponseFromJson(String str) =>
    ResultKaderResponse.fromJson(json.decode(str));

String resultKaderResponseToJson(ResultKaderResponse data) =>
    json.encode(data.toJson());

class ResultKaderResponse {
  final String? kaderId;
  final String? namaKader;
  final String? kelamin;
  final String? message;
  final String? klasifikasi;
  final PuskesmasModel? puskesmas;
  final List<Penilai>? detailPenilai;
  final List<HasilPenilaian>? hasilPenilaian;

  ResultKaderResponse({
    this.kaderId,
    this.namaKader,
    this.kelamin,
    this.message,
    this.puskesmas,
    this.detailPenilai,
    this.hasilPenilaian,
    this.klasifikasi,
  });

  factory ResultKaderResponse.fromJson(Map<String, dynamic> json) =>
      ResultKaderResponse(
        kaderId: json["kader_id"],
        namaKader: json["nama_kader"],
        kelamin: json["kelamin"],
        klasifikasi: json["klasifikasi"],
        message: json["message"],
        puskesmas: json["puskesmas"] == null
            ? null
            : PuskesmasModel.fromJson(json["puskesmas"]),
        detailPenilai: json["detail_penilai"] == null
            ? []
            : List<Penilai>.from(
                json["detail_penilai"]!.map((x) => Penilai.fromJson(x))),
        hasilPenilaian: json["hasil_penilaian"] == null
            ? []
            : List<HasilPenilaian>.from(json["hasil_penilaian"]!
                .map((x) => HasilPenilaian.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "kader_id": kaderId,
        "nama_kader": namaKader,
        "kelamin": kelamin,
        "klasifikasi": klasifikasi,
        "puskesmas": puskesmas?.toJson(),
        "hasil_penilaian": hasilPenilaian == null
            ? []
            : List<dynamic>.from(hasilPenilaian!.map((x) => x.toJson())),
      };
}

class HasilPenilaian {
  final String? kompetensi;
  final List<Keterampilan>? keterampilan;
  final bool? kompetensiSudahTerisi;

  HasilPenilaian({
    this.kompetensi,
    this.keterampilan,
    this.kompetensiSudahTerisi,
  });

  factory HasilPenilaian.fromJson(Map<String, dynamic> json) => HasilPenilaian(
        kompetensi: json["kompetensi"],
        keterampilan: json["keterampilan"] == null
            ? []
            : List<Keterampilan>.from(
                json["keterampilan"]!.map((x) => Keterampilan.fromJson(x))),
        kompetensiSudahTerisi: json["kompetensi_sudah_terisi"],
      );

  Map<String, dynamic> toJson() => {
        "kompetensi": kompetensi,
        "keterampilan": keterampilan == null
            ? []
            : List<dynamic>.from(keterampilan!.map((x) => x.toJson())),
        "kompetensi_sudah_terisi": kompetensiSudahTerisi,
      };
}

class Keterampilan {
  final String? namaKeterampilan;
  final int? totalNilai;
  final double? persentase;
  final String? status;
  final KeterampilanSudahTerisi? keterampilanSudahTerisi;
  final List<DetailPenilaian>? detailPenilaian;

  Keterampilan({
    this.namaKeterampilan,
    this.totalNilai,
    this.persentase,
    this.status,
    this.keterampilanSudahTerisi,
    this.detailPenilaian,
  });

  factory Keterampilan.fromJson(Map<String, dynamic> json) => Keterampilan(
        namaKeterampilan: json["nama_keterampilan"],
        totalNilai: json["total_nilai"],
        persentase: (json["persentase"] as num?)?.toDouble(),
        status: json["status"],
        keterampilanSudahTerisi: json["keterampilan_sudah_terisi"] == null
            ? null
            : KeterampilanSudahTerisi.fromJson(
                json["keterampilan_sudah_terisi"]),
        detailPenilaian: json["detail_penilaian"] == null
            ? []
            : List<DetailPenilaian>.from(json["detail_penilaian"]!
                .map((x) => DetailPenilaian.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "nama_keterampilan": namaKeterampilan,
        "total_nilai": totalNilai,
        "persentase": persentase,
        "status": status,
        "keterampilan_sudah_terisi": keterampilanSudahTerisi?.toJson(),
        "detail_penilaian": detailPenilaian == null
            ? []
            : List<dynamic>.from(detailPenilaian!.map((x) => x.toJson())),
      };
}

class DetailPenilaian {
  final Penilai? penilai;
  final int? nilai;

  DetailPenilaian({
    this.penilai,
    this.nilai,
  });

  factory DetailPenilaian.fromJson(Map<String, dynamic> json) =>
      DetailPenilaian(
        penilai:
            json["penilai"] == null ? null : Penilai.fromJson(json["penilai"]),
        nilai: json["nilai"],
      );

  Map<String, dynamic> toJson() => {
        "penilai": penilai?.toJson(),
        "nilai": nilai,
      };
}

class Penilai {
  final int? id;
  final String? name;
  final String? tipe;
  final String? puskesmas;

  Penilai({
    this.id,
    this.name,
    this.tipe,
    this.puskesmas,
  });

  factory Penilai.fromJson(Map<String, dynamic> json) => Penilai(
        id: json["id"],
        name: json["name"],
        tipe: json["tipe"],
        puskesmas: json["puskesmas"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tipe": tipe,
        "puskesmas": puskesmas,
      };
}

class KeterampilanSudahTerisi {
  final bool? penilai1;
  final bool? penilai2;

  KeterampilanSudahTerisi({
    this.penilai1,
    this.penilai2,
  });

  factory KeterampilanSudahTerisi.fromJson(Map<String, dynamic> json) =>
      KeterampilanSudahTerisi(
        penilai1: json["penilai_1"],
        penilai2: json["penilai_2"],
      );

  Map<String, dynamic> toJson() => {
        "penilai_1": penilai1,
        "penilai_2": penilai2,
      };
}
