import 'package:flutter/material.dart';
import 'package:web_admin_1/widget/date_formatter.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Text('Hari Ini (${DateFormatter.formatDateToday()})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _statusCard('pesanan', 'Total', pesanan, Colors.grey[300]!),
            _statusCard(
                'pesanan', 'Belum Dikirim', belumDikirim, Colors.red[100]!),
            _statusCard('pesanan', 'Sedang Dikirim', sedangDikirim,
                Colors.orange[100]!),
            _statusCard('pesanan', 'Selesai', selesai, Colors.green[100]!),
          ],
        )
      ],
    );
  }

  Widget _statusCard(String desc, String title, int value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(16),
        height: 150,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            Text('$value', style: const TextStyle(fontSize: 40)),
            Text(desc, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
