class DBSPPModel {
  final String noBukti;
  final String noUrut;
  final String noSO;
  final String noPesan;
  final String kodeCustSupp;

  DBSPPModel({
    required this.noBukti,
    required this.noUrut,
    required this.noSO,
    required this.noPesan,
    required this.kodeCustSupp,
  });

  factory DBSPPModel.fromJson(Map<String, dynamic> json) {
    try {
      return DBSPPModel(
        noBukti: json['NoBukti']?.toString() ?? '',
        noUrut: json['NoUrut']?.toString() ?? '',
        noSO: json['NoSO']?.toString() ?? '',
        noPesan: json['NoPesan']?.toString() ?? '',
        kodeCustSupp: json['KodeCustSupp']?.toString() ?? '',
      );
    } catch (e, stack) {
      print('Error parsing DBSPPModel: $e\n$stack');
      rethrow;
    }
  }
}

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

  @override
  String toString() {
    return 'DBSPPDetModel(kodeBarang: $kodeBarang, namaBarang: $namaBarang, quantity: $quantity, satuan: $satuan, keterangan: $keterangan)';
  }

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
