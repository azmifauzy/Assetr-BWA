import 'package:intl/intl.dart';

class AppFormats {
  static String date(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('d MMM y', 'id_ID').format(dateTime);
  }

  static String currency(String number) {
    return NumberFormat.currency(
            decimalDigits: 2, locale: 'id_ID', symbol: 'Rp. ')
        .format(double.parse(number));
  }
}
