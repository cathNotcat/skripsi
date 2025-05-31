class LoginModel {
  final String kode;
  final String nama;

  LoginModel({required this.kode, required this.nama});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      kode: json['kode'],
      nama: json['nama'],
    );
  }
}
