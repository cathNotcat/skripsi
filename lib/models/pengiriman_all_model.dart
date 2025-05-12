class PengirimanAllModel {
  final String noPengiriman;
  final String noDO;
  final String kodeSopir;
  final String kodeCustSupp;
  final String tanggalKirim;
  final String status;
  final String noUrut;
  final String selesaiAt;

  PengirimanAllModel(
      {required this.noPengiriman,
      required this.noDO,
      required this.kodeSopir,
      required this.kodeCustSupp,
      required this.tanggalKirim,
      required this.status,
      required this.noUrut,
      required this.selesaiAt});

  factory PengirimanAllModel.fromJson(Map<String, dynamic> json) {
    return PengirimanAllModel(
      noPengiriman: json['NoPengiriman'],
      noDO: json['NoDO'],
      kodeSopir: json['KodeSopir'],
      kodeCustSupp: json['KodeCustSuppDO'],
      tanggalKirim: json['TanggalKirim'],
      status: json['Status'],
      noUrut: json['NoUrut'],
      selesaiAt: json['SelesaiAt'],
    );
  }
}
