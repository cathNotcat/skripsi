class PengirimanModel {
  final String noDO;
  final String? koordinat;
  final String status;

  PengirimanModel({
    required this.noDO,
    this.koordinat,
    required this.status,
  });

  factory PengirimanModel.fromJson(Map<String, dynamic> json) {
    return PengirimanModel(
      noDO: json['NoDO'],
      koordinat: json['Koordinat'],
      status: json['Status'],
    );
  }
}
