import 'package:intl/date_symbol_data_local.dart';
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

  static Future<String> formatDateIndo() async {
    await initializeDateFormatting('id_ID', null);
    Intl.defaultLocale = 'id_ID';

    DateTime today = DateTime.now();
    String formattedDate = DateFormat('EEEE, d MMMM yyyy').format(today);
    print(formattedDate);
    return formattedDate;
  }

  static String formatDateToday() {
    final now = DateTime.now();
    return DateFormat('d MMMM y').format(now);
  }
}
