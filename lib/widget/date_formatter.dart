import 'package:intl/intl.dart';

class DateFormatter {
  static String formatToday() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  static String formatDate(String tanggal) {
    try {
      final parsed = DateFormat('dd-MM-yyyy').parse(tanggal);
      return DateFormat('d MMMM yyyy', 'en_US').format(parsed);
    } catch (e) {
      return tanggal;
    }
  }

  static String formatDateToday() {
    final now = DateTime.now();
    return DateFormat('d MMMM y').format(now);
  }
}
