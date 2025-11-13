import 'package:intl/intl.dart';

class FormatCurrency {
  static String formatRupiah(num number) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return formatter.format(number);
}
}