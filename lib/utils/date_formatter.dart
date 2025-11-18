import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat fullDate = DateFormat('EEEE, dd MMM yyyy', 'id_ID');
  static final DateFormat shortDate = DateFormat('dd/MM/yyyy', 'id_ID');
  static final DateFormat time = DateFormat('HH:mm', 'id_ID');

  static String formatFull(DateTime date) => fullDate.format(date);
  static String formatShort(DateTime date) => shortDate.format(date);
  static String formatTime(DateTime date) => time.format(date);

  /// Return the full month name 
  static String monthName(DateTime date) => DateFormat.MMMM('id_ID').format(date);
}