import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final int pesanan;
  final int belumDikirim;
  final int sedangDikirim;
  final int selesai;

  const Header({
    super.key,
    required this.pesanan,
    required this.belumDikirim,
    required this.sedangDikirim,
    required this.selesai,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Text('Hari Ini ($formattedDate)',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _statusCard('Pesanan', pesanan, Colors.grey[300]!),
            _statusCard('Belum Dikirim', belumDikirim, Colors.red[100]!),
            _statusCard('Sedang Dikirim', sedangDikirim, Colors.orange[100]!),
            _statusCard('Selesai', selesai, Colors.green[100]!),
          ],
        )
      ],
    );
  }

  Widget _statusCard(String title, int value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(16),
        height: 100,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text('$value', style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
