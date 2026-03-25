import 'package:intl/intl.dart';

class NumberFormatter {
  static final _currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 0,
    locale: 'es_CO',
  );

  static final _currencyFormatWithDecimals = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
    locale: 'es_CO',
  );

  static String formatCurrency(double amount, {bool showDecimals = false}) {
    if (showDecimals && amount != amount.truncateToDouble()) {
      return _currencyFormatWithDecimals.format(amount);
    }
    return _currencyFormat.format(amount);
  }

  static String _cleanNumber(String numStr) {
    if (numStr.contains('.')) {
      numStr = numStr.replaceAll(RegExp(r'\.?0+$'), '');
      if (numStr.endsWith('.')) {
        numStr = numStr.substring(0, numStr.length - 1);
      }
    }
    return numStr;
  }

  static String formatCompact(double amount) {
    if (amount >= 1000000) {
      return '\$${_cleanNumber((amount / 1000000).toStringAsFixed(2))}M';
    }
    if (amount >= 1000) {
      return '\$${_cleanNumber((amount / 1000).toStringAsFixed(2))}K';
    }
    return '\$${amount.truncate()}';
  }

  static String formatCompactWithDecimals(double amount) {
    if (amount >= 1000000) {
      return '\$${_cleanNumber((amount / 1000000).toStringAsFixed(2))}M';
    }
    if (amount >= 1000) {
      return '\$${_cleanNumber((amount / 1000).toStringAsFixed(2))}K';
    }
    return formatCurrency(amount, showDecimals: true);
  }

  static String formatNumber(int number) {
    return NumberFormat('#,###', 'es_CO').format(number);
  }

  static String formatDecimal(double number) {
    if (number == number.truncateToDouble()) {
      return number.toInt().toString();
    }
    return number.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
  }
}
