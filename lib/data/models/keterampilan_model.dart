class KeterampilanModel {
  final int? id;
  final String? nama;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? modulId;

  KeterampilanModel({
    this.id,
    this.nama,
    this.createdAt,
    this.updatedAt,
    this.modulId,
  });

  factory KeterampilanModel.fromJson(Map<String, dynamic> json) =>
      KeterampilanModel(
        id: json["id"],
        nama: json["nama"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        modulId: json["kompetensi_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "kompetensi_id": modulId,
      };
}
