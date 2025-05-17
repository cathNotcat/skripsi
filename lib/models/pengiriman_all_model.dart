class PengirimanAllModel {
  final String noPengiriman;
  final String noDO;
  final String kodeCustSupp;
  final String namaCust;
  final String tanggalKirim;
  final String status;
  final String noUrut;
  final String selesaiAt;

  PengirimanAllModel(
      {required this.noPengiriman,
      required this.noDO,
      required this.kodeCustSupp,
      required this.namaCust,
      required this.tanggalKirim,
      required this.status,
      required this.noUrut,
      required this.selesaiAt});

  @override
  String toString() {
    return 'PengirimanAllModel(namaCust: $namaCust, noPengiriman: $noPengiriman, tanggalKirim: $tanggalKirim, status: $status)';
  }

  factory PengirimanAllModel.fromJson(Map<String, dynamic> json) {
    return PengirimanAllModel(
      noPengiriman: json['NoPengiriman'] ?? '',
      noDO: json['NoDO'] ?? '',
      kodeCustSupp: json['KodeCustSupp'] ?? '',
      namaCust: json['Nama'] ?? '',
      tanggalKirim: json['TanggalKirim'] ?? '',
      status: json['Status'] ?? '',
      noUrut: json['NoUrut'] ?? '',
      selesaiAt: json['SelesaiAt'] ?? '',
    );
  }
}

class GroupedPengirimanModel {
  final String tanggal;
  final List<PengirimanAllModel> pengirimanList;

  GroupedPengirimanModel({
    required this.tanggal,
    required this.pengirimanList,
  });

  @override
  String toString() {
    return 'GroupedPengirimanModel(tanggal: $tanggal, pengirimanList: $pengirimanList)';
  }

  factory GroupedPengirimanModel.fromJson(Map<String, dynamic> json) {
    return GroupedPengirimanModel(
      tanggal: json['TanggalKirim'] ?? '',
      pengirimanList: (json['Pengiriman'] as List?)
              ?.map((e) => PengirimanAllModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
