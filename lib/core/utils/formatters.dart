import 'package:intl/intl.dart';

/// Sayı ve para formatlama yardımcı sınıfı
class Formatters {
  Formatters._();

  /// Para birimi formatı (örn: 1,234.56 TRY)
  static String formatCurrency(
    double? value, {
    String currency = 'TRY',
    String locale = 'tr_TR',
  }) {
    if (value == null) return '0.00';

    final formatter = NumberFormat.currency(
      symbol: _getCurrencySymbol(currency),
      decimalDigits: 2,
      locale: locale,
    );
    return formatter.format(value);
  }

  /// Kısa sayı formatı (örn: 1.23M, 456K)
  static String formatCompactNumber(double? value) {
    if (value == null) return '0';

    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(2)}B';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(2)}K';
    } else {
      return value.toStringAsFixed(2);
    }
  }

  /// Yüzde formatı (örn: +5.23%, -2.15%)
  static String formatPercentage(double? value) {
    if (value == null) return '0.00%';
    final sign = value >= 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(2)}%';
  }

  /// Tarih formatı
  static String formatDate(DateTime? date, {String format = 'dd.MM.yyyy'}) {
    if (date == null) return '';
    return DateFormat(format).format(date);
  }

  /// Saat formatı
  static String formatTime(DateTime? date, {String format = 'HH:mm'}) {
    if (date == null) return '';
    return DateFormat(format).format(date);
  }

  /// Para birimi sembolü
  static String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'TRY':
        return '₺';
      case 'JPY':
        return '¥';
      case 'CNY':
        return '¥';
      default:
        return currency;
    }
  }
}
