class CustomerModel {
  final String kodeCust;
  final String nama;
  final String alamat;
  final String koordinat;

  CustomerModel({
    required this.kodeCust,
    required this.nama,
    required this.alamat,
    required this.koordinat,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      kodeCust: json['KODECUSTSUPP'],
      nama: json['NAMA'],
      alamat: json['ALAMAT'],
      koordinat: json['KOORDINAT'],
    );
  }
}
