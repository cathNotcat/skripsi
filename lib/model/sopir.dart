class Sopir {
  final String kodeSopir;

  Sopir({required this.kodeSopir});

  factory Sopir.fromJson(Map<String, dynamic> json) {
    return Sopir(
      kodeSopir: json['kodesopir'],
    );
  }
}
