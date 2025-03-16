// To parse this JSON data, do
//
//     final UserModel = UserModelFromJson(jsonString);

import 'dart:convert';

import 'package:e_assesment_kader_app/data/models/puskesmas_model.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final int? id;
  final dynamic puskesmasId;
  final String? tipe;
  final PuskesmasModel? puskesmas;
  final String? name;
  final String? nik;
  final String? kelamin;
  final String? posyandu;
  final dynamic umur;
  final String? email;
  final dynamic emailVerifiedAt;
  final String? password;
  final String? passwordConfirmation;
  final String? lamaJadiKader;
  final String? pekerjaanSelainKader;
  final String? pendidikanTerakhir;
  final String? dapatInsentifDariDesa;
  final String? insentifPerTahun;
  final int? totalPenilai;
  final int? penilaiInternal;
  final int? penilaiEksternal;
  final bool? assessmentCompleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.id,
    this.puskesmasId,
    this.tipe,
    this.puskesmas,
    this.name,
    this.nik,
    this.kelamin,
    this.posyandu,
    this.umur,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.password,
    this.passwordConfirmation,
    this.lamaJadiKader,
    this.pekerjaanSelainKader,
    this.pendidikanTerakhir,
    this.dapatInsentifDariDesa,
    this.insentifPerTahun,
    this.totalPenilai,
    this.penilaiInternal,
    this.penilaiEksternal,
    this.assessmentCompleted,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        puskesmasId: json["puskesmas_id"],
        tipe: json["tipe"],
        puskesmas: json["puskesmas"] == null
            ? null
            : PuskesmasModel.fromJson(json["puskesmas"]),
        name: json["name"],
        nik: json["nik"],
        kelamin: json["kelamin"],
        posyandu: json["posyandu"],
        umur: json["umur"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        password: json["password"],
        passwordConfirmation: json["password_confirmation"],
        lamaJadiKader: json["lama_jadi_kader"],
        pekerjaanSelainKader: json["pekerjaan_selain_kader"],
        pendidikanTerakhir: json["pendidikan_terakhir"],
        dapatInsentifDariDesa: json["dapat_insentif_dari_desa"],
        insentifPerTahun: json["insentif_per_tahun"],
        totalPenilai: json["total_penilai"],
        penilaiInternal: json["penilai_internal"],
        penilaiEksternal: json["penilai_eksternal"],
        assessmentCompleted: json["assessment_completed"],
      );

  Map<String, dynamic> toJson() => {
        "puskesmas_id": puskesmasId,
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
      };

  Map<String, dynamic> loginToJson() => {
        "email": email,
        "password": password,
      };

  // Map<String, dynamic> registerKaderToJson() => {
  //       "puskesmas_id": puskesmasId,
  //       "nama": name,
  //       "nik": nik,
  //       "kelamin": kelamin,
  //       "posyandu": posyandu,
  //       "lama_jadi_kader": lamaJadiKader,
  //       "umur": umur,
  //       "pekerjaan_selain_kader": pekerjaanSelainKader,
  //       "pendidikan_terakhir": pendidikanTerakhir,
  //       "dapat_insentif_dari_desa": dapatInsentifDariDesa,
  //       "insentif_per_tahun": insentifPerTahun
  //     };

  Map<String, dynamic> registerKaderToJson() {
    final data = {
      "puskesmas_id": puskesmasId,
      "nama": name,
      "nik": nik,
      "kelamin": kelamin,
      "posyandu": posyandu,
      "lama_jadi_kader": lamaJadiKader,
      "umur": umur,
      "pekerjaan_selain_kader": pekerjaanSelainKader,
      "pendidikan_terakhir": pendidikanTerakhir,
      "dapat_insentif_dari_desa": dapatInsentifDariDesa,
    };

    // Hanya tambahkan "insentif_per_tahun" jika dapatInsentifDariDesa bukan "tidak"
    if (dapatInsentifDariDesa != "Tidak") {
      data["insentif_per_tahun"] = insentifPerTahun;
    }

    return data;
  }
}
