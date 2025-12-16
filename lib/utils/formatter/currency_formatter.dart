import 'package:intl/intl.dart';

class CurrencyFormatter {
  // Base formatter without decimals
  static final NumberFormat _idr = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // Formatter with decimals (if needed)
  static final NumberFormat _idrWithDecimal = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 2,
  );

  /// Format numeric value → Rp with thousand separator
  /// Example: 14500 → "Rp 14.500"
  static String format(num value) => _idr.format(value);

  /// Format numeric value with decimals
  /// Example: 14500 → "Rp 14.500,00"
  static String formatWithDecimal(num value) => _idrWithDecimal.format(value);

  /// Parse string like "14.500" → 14500
  /// Automatically strips dots and spaces
  static num parse(String value) {
    String clean = value.replaceAll('.', '').replaceAll(',', '').trim();
    return num.tryParse(clean) ?? 0;
  }

  /// Format string input directly
  /// Example: "14.500" → "Rp 14.500"
  static String formatString(String value) {
    final parsed = parse(value);
    return format(parsed);
  }

  /// Format nullable values safely
  static String? formatNullable(num? value) {
    if (value == null) return null;
    return format(value);
  }
}
