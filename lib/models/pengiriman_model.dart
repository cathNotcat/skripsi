class PengirimanDetailModel {
  final String noUrut;
  final String noPengiriman;
  final String tanggalKirim;
  final String kodeSopir;
  final String noDO;
  final String nama;
  final String kodeCustSupp;
  final String alamat;
  final String koordinat;
  final String status;
  final String jumlahBarang;

  PengirimanDetailModel({
    required this.noUrut,
    required this.noPengiriman,
    required this.kodeSopir,
    required this.tanggalKirim,
    required this.noDO,
    required this.nama,
    required this.kodeCustSupp,
    required this.alamat,
    required this.koordinat,
    required this.status,
    required this.jumlahBarang,
  });

  factory PengirimanDetailModel.fromJson(Map<String, dynamic> json) {
    return PengirimanDetailModel(
      noUrut: json['NoUrut'],
      noPengiriman: json['NoPengiriman'],
      kodeSopir: json['KodeSopir'],
      tanggalKirim: json['TanggalKirim'],
      noDO: json['NoDO'],
      nama: json['Nama'],
      kodeCustSupp: json['KodeCustSupp'],
      alamat: json['Alamat'],
      koordinat: json['Koordinat'],
      status: json['Status'],
      jumlahBarang: json['JumlahBarang'],
    );
  }
}

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
      noPengiriman: json['NoPengiriman'] ?? '-',
      noDO: json['NoDO'] ?? '-',
      kodeCustSupp: json['KodeCustSupp'] ?? '-',
      namaCust: json['Nama'] ?? '-',
      tanggalKirim: json['TanggalKirim'] ?? '-',
      status: json['Status'] ?? '-',
      noUrut: json['NoUrut'] ?? '-',
      selesaiAt: json['SelesaiAt'] ?? '-',
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

// class PengirimanModel {
//   final String noDO;
//   final String? koordinat;
//   final String status;

//   PengirimanModel({
//     required this.noDO,
//     this.koordinat,
//     required this.status,
//   });

//   factory PengirimanModel.fromJson(Map<String, dynamic> json) {
//     return PengirimanModel(
//       noDO: json['NoDO'],
//       koordinat: json['Koordinat'],
//       status: json['Status'],
//     );
//   }
// }
