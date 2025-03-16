class PertanyaanModel {
  final int? id;
  final int? keterampilanId;
  final String? pertanyaan;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PertanyaanModel({
    this.id,
    this.keterampilanId,
    this.pertanyaan,
    this.createdAt,
    this.updatedAt,
  });

  factory PertanyaanModel.fromJson(Map<String, dynamic> json) =>
      PertanyaanModel(
        id: json["id"],
        keterampilanId: json["keterampilan_id"],
        pertanyaan: json["pertanyaan"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "keterampilan_id": keterampilanId,
        "pertanyaan": pertanyaan,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
