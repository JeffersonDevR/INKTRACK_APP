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
    // For Colombian Pesos, decimals are rarely used in retail, 
    // but we'll show them if they are non-zero or explicitly requested.
    if (showDecimals || (amount % 1 != 0)) {
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
    // Only use compact formatting if value is large (e.g. over 1M)
    if (amount >= 1000000) {
       if (amount >= 1000000000) {
         return '\$${_cleanNumber((amount / 1000000000).toStringAsFixed(1))}B';
       }
       return '\$${_cleanNumber((amount / 1000000).toStringAsFixed(1))}M';
    }
    
    // For most cases, use full currency formatting
    return formatCurrency(amount);
  }

  static String formatCompactWithDecimals(double amount) {
    if (amount >= 100000000) {
      return formatCompact(amount);
    }
    return formatCurrency(amount, showDecimals: true);
  }

  static String formatNumber(int number) {
    return NumberFormat('#,###', 'es_CO').format(number);
  }

  static double parseAmount(String text) {
    if (text.isEmpty) return 0.0;
    
    // Clean string: remove any $ or spaces
    String clean = text.replaceAll('\$', '').replaceAll(' ', '').trim();
    
    // Detection of Colombian format: 1.234.567,89 
    // If there's a comma, it's the decimal. All dots are thousand separators.
    if (clean.contains(',')) {
      clean = clean.replaceAll('.', '').replaceAll(',', '.');
    } else {
      // If there are only dots, check if it looks like thousand separators (e.g. 60.000)
      // or a single decimal dot (e.g. 60.5)
      int lastDot = clean.lastIndexOf('.');
      if (lastDot != -1) {
        // If there's more than one dot, they are definitely thousand separators.
        if (clean.indexOf('.') != lastDot) {
          clean = clean.replaceAll('.', '');
        } else {
          // Single dot: heuristic. In Colombia, 60.000 is much more common than 60.0
          // If followed by 3 digits, we'll assume thousand separator unless it's small?
          // Actually, let's keep it simple: if exactly 3 digits after the ONLY dot, 
          // and total length > 4, it's likely a thousand separator.
          String afterDot = clean.substring(lastDot + 1);
          if (afterDot.length == 3 && clean.length > 4) {
            clean = clean.replaceAll('.', '');
          }
        }
      }
    }
    
    return double.tryParse(clean) ?? 0.0;
  }
}
