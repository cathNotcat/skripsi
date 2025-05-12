class DBSPPDetModel {
  final String kodeBarang;
  final String namaBarang;
  final String quantity;
  final String satuan;
  final String keterangan;

  DBSPPDetModel({
    required this.kodeBarang,
    required this.namaBarang,
    required this.quantity,
    required this.satuan,
    required this.keterangan,
  });

  factory DBSPPDetModel.fromJson(Map<String, dynamic> json) {
    return DBSPPDetModel(
      kodeBarang: json['KodeBrg'],
      namaBarang: json['NamaBrg'],
      quantity: json['Quantity'],
      satuan: json['Satuan'],
      keterangan: json['Keterangan'],
    );
  }
}
