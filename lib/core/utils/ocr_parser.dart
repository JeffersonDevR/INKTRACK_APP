class OcrParser {
  /// Extract monetary values from a block of text.
  /// Looks for patterns like $100, 100.00, $ 50.5, etc.
  static List<double> extractAmounts(String text) {
    // Regex for: optional symbol, spaces, digits, optional decimal separator (dot or comma), more digits.
    // Example matches: $1,200.50, 500,00, $ 45.10
    final RegExp amountRegex = RegExp(
      r'(\$)?\s?(\d{1,3}([,.]\d{3})*([,.]\d{2})?)',
    );

    final matches = amountRegex.allMatches(text);
    final List<double> results = [];

    for (var match in matches) {
      String valueStr = match.group(2) ?? '';
      if (valueStr.isEmpty) continue;

      // Clean separators. Handle common Spanish/Latam formats:
      // $1.500,00 -> 1500.00
      // $1,500.00 -> 1500.00

      // If there's both a dot and a comma, the last one is likely the decimal.
      bool hasComma = valueStr.contains(',');
      bool hasDot = valueStr.contains('.');

      if (hasComma && hasDot) {
        int commaIndex = valueStr.lastIndexOf(',');
        int dotIndex = valueStr.lastIndexOf('.');
        if (commaIndex > dotIndex) {
          // 1.500,00 format
          valueStr = valueStr.replaceAll('.', '').replaceAll(',', '.');
        } else {
          // 1,500.00 format
          valueStr = valueStr.replaceAll(',', '');
        }
      } else if (hasComma) {
        // Only commas. Could be 1.000 (missing dot) or 10,00
        // Heuristic: if comma is near the end (2 digits), it's probably decimal.
        if (valueStr.length - valueStr.lastIndexOf(',') == 3) {
          valueStr = valueStr.replaceAll(',', '.');
        } else {
          valueStr = valueStr.replaceAll(',', '');
        }
      } else if (hasDot) {
        // Only dots. 1.000 or 10.00
        if (valueStr.length - valueStr.lastIndexOf('.') == 3) {
          // 10.00 -> decimal
        } else {
          valueStr = valueStr.replaceAll('.', '');
        }
      }

      final val = double.tryParse(valueStr);
      if (val != null && val > 0) {
        results.add(val);
      }
    }

    return results;
  }

  /// Tries to find the "Total" amount in a text.
  /// If not found, returns the largest amount found.
  static double? findTotal(String text) {
    // Check for "Total" or similar keywords
    final totalKeywords = [
      'total',
      'monto',
      'suma',
      'pagar',
      'importe',
      'liquido',
    ];

    final lines = text.split('\n');
    for (var line in lines) {
      final lowerLine = line.toLowerCase();
      if (totalKeywords.any((k) => lowerLine.contains(k))) {
        final amounts = extractAmounts(line);
        if (amounts.isNotEmpty) {
          return amounts.first; // First amount in the same line as "Total"
        }
      }
    }

    // fallback: biggest amount
    final allAmounts = extractAmounts(text);
    if (allAmounts.isEmpty) return null;

    allAmounts.sort((a, b) => b.compareTo(a));
    return allAmounts.first;
  }

  /// Tries to find a client name in the text.
  /// Looks for keywords like "Cliente", "Nombre", "Para", etc.
  static String? findClientName(String text) {
    final nameKeywords = [
      'cliente',
      'nombre',
      'para:',
      'atn:',
      'estimado',
      'sr(a)',
      'facturado a',
    ];
    final lines = text.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lowerLine = line.toLowerCase();

      for (var keyword in nameKeywords) {
        if (lowerLine.contains(keyword)) {
          // Check if name is on the same line after the keyword
          String potentialName = line
              .substring(lowerLine.indexOf(keyword) + keyword.length)
              .trim();

          // Remove common punctuation and "clean" the name
          potentialName = _cleanName(potentialName);

          if (potentialName.isNotEmpty && potentialName.length > 2) {
            return potentialName;
          }

          // If current line only had the keyword, check the next line
          if (i + 1 < lines.length) {
            String nextLineName = _cleanName(lines[i + 1].trim());
            if (nextLineName.isNotEmpty && nextLineName.length > 2) {
              return nextLineName;
            }
          }
        }
      }
    }

    return null;
  }

  static String _cleanName(String name) {
    return name
        .replaceAll(RegExp(r'^[:\s\-._"]+'), '')
        .replaceAll(RegExp(r'[:\s\-._"]+$'), '')
        .trim();
  }
}
