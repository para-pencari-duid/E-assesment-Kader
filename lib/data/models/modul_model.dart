import 'package:e_assesment_kader_app/data/models/keterampilan_model.dart';

class ModulModel {
  final int? id;
  final String? nama;
  final List<KeterampilanModel>? keterampilans;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ModulModel({
    this.id,
    this.nama,
    this.keterampilans,
    this.createdAt,
    this.updatedAt,
  });

  factory ModulModel.fromJson(Map<String, dynamic> json) => ModulModel(
        id: json["id"],
        nama: json["nama"],
        keterampilans: json["keterampilans"] == null
            ? []
            : List<KeterampilanModel>.from(json["keterampilans"]!
                .map((x) => KeterampilanModel.fromJson(x))),
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
        "keterampilans": keterampilans == null
            ? []
            : List<dynamic>.from(keterampilans!.map((x) => x.toJson())),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
