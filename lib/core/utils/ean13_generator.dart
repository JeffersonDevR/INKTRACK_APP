class Ean13Generator {
  static const String _colombianPrefix = '770';

  static String generate() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final base = _colombianPrefix + timestamp.substring(timestamp.length - 9);
    final checkDigit = _calculateCheckDigit(base);
    return '$base$checkDigit';
  }

  static int _calculateCheckDigit(String base) {
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      int digit = int.parse(base[i]);
      sum += (i % 2 == 0) ? digit : digit * 3;
    }
    return (10 - (sum % 10)) % 10;
  }

  static bool isValid(String code) {
    if (code.length != 13) return false;
    if (!RegExp(r'^\d+$').hasMatch(code)) return false;

    int sum = 0;
    for (int i = 0; i < 12; i++) {
      int digit = int.parse(code[i]);
      sum += (i % 2 == 0) ? digit : digit * 3;
    }
    int calculatedCheckDigit = (10 - (sum % 10)) % 10;
    int actualCheckDigit = int.parse(code[12]);

    return calculatedCheckDigit == actualCheckDigit;
  }

  static String generateFromCustomCode(String customCode) {
    final cleanCode = customCode.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    final hashCode = cleanCode.hashCode.abs();
    final base =
        _colombianPrefix + hashCode.toString().padLeft(9, '0').substring(0, 9);
    final checkDigit = _calculateCheckDigit(base);
    return '$base$checkDigit';
  }
}
