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
    return DBSPPModel(
      noBukti: json['NoBukti'],
      noUrut: json['NoUrut'],
      noSO: json['NoSO'],
      noPesan: json['NoPesan'],
      kodeCustSupp: json['KodeCustSupp'],
    );
  }
}
