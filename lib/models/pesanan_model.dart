class PesananModel {
  final String noDO;
  final String kodeSopir;
  final String kodeCustSupp;
  final String tanggalKirim;
  final String nama;
  final int status;

  PesananModel({
    required this.noDO,
    required this.kodeSopir,
    required this.kodeCustSupp,
    required this.tanggalKirim,
    required this.nama,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'NoDO': noDO,
      'KodeSopir': kodeSopir,
      'KodeCustSupp': kodeCustSupp,
      'TanggalKirim': tanggalKirim,
      'Nama': nama,
      'Status': status,
    };
  }

  factory PesananModel.fromJson(Map<String, dynamic> json) {
    return PesananModel(
      noDO: json['NoDO'] ?? '',
      kodeSopir: json['KodeSopir'] ?? '',
      kodeCustSupp: json['KodeCustSupp'] ?? '',
      tanggalKirim: json['TanggalKirim'] ?? '',
      nama: json['Nama'] ?? '',
      status: json['Status'] ?? '',
    );
  }
}
