class PengirimanModel {
  final String noDO;
  final String kodeCustSupp;
  final String alamat;
  final String status;

  PengirimanModel(
      {required this.status,
      required this.noDO,
      required this.kodeCustSupp,
      required this.alamat});

  factory PengirimanModel.fromJson(Map<String, dynamic> json) {
    return PengirimanModel(
      noDO: json['NoDO'],
      kodeCustSupp: json['KodeCustSupp'],
      alamat: json['Alamat'],
      status: json['Status'],
    );
  }
}
