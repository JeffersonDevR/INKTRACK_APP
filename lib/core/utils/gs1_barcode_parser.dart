/// Pure-Dart GS1 variable-weight/price barcode parser.
///
/// Decodes AIs 3100–3199 (net weight in kg, 5-digit value) and
/// 3200–3299 (price, 5-digit value). The last digit of the 4-digit AI
/// indicates the number of decimal places (0–9).
///
/// For a 13-digit EAN-13 barcode the layout is:
///   [AI 4 digits][value 5 digits][productId 3 digits][check digit 1]
///
/// For other lengths the remaining digits after AI+value become the
/// productId (no check-digit stripping).
class Gs1ParseResult {
  final String productId;
  final double? weightKg;
  final double? price;

  Gs1ParseResult.weight(this.productId, this.weightKg) : price = null;
  Gs1ParseResult.price(this.productId, this.price) : weightKg = null;

  bool get isWeight => weightKg != null;
  bool get isPrice => price != null;
}

class Gs1ParseException implements Exception {
  final String message;
  Gs1ParseException(this.message);

  @override
  String toString() => 'Gs1ParseException: $message';
}

class Gs1BarcodeParser {
  static const int _aiLength = 4;
  static const int _valueLength = 5;
  static const int _minLength = _aiLength + _valueLength + 1;
  static const int _ean13Length = 13;

  Gs1ParseResult parse(String code) {
    if (code.length < _minLength) {
      throw Gs1ParseException('Barcode too short for GS1 variable parsing');
    }
    if (!RegExp(r'^\d+$').hasMatch(code)) {
      throw Gs1ParseException('Barcode must contain only digits');
    }

    final firstTwo = code.substring(0, 2);

    if (firstTwo == '31') {
      return _parseWeight(code);
    } else if (firstTwo == '32') {
      return _parsePrice(code);
    } else {
      throw Gs1ParseException(
        'Not a GS1 variable-weight/price barcode (AI must start with 31 or 32)',
      );
    }
  }

  Gs1ParseResult _parseWeight(String code) {
    final decimalPlaces = int.parse(code[3]);
    final valueStr = code.substring(_aiLength, _aiLength + _valueLength);
    final value = int.parse(valueStr);
    final weightKg = value / _pow10(decimalPlaces);
    final productId = _extractProductId(code);

    return Gs1ParseResult.weight(productId, weightKg);
  }

  Gs1ParseResult _parsePrice(String code) {
    final decimalPlaces = int.parse(code[3]);
    final valueStr = code.substring(_aiLength, _aiLength + _valueLength);
    final value = int.parse(valueStr);
    final price = value / _pow10(decimalPlaces);
    final productId = _extractProductId(code);

    return Gs1ParseResult.price(productId, price);
  }

  String _extractProductId(String code) {
    final remaining = code.substring(_aiLength + _valueLength);
    if (code.length == _ean13Length && remaining.length >= 2) {
      return remaining.substring(0, remaining.length - 1);
    }
    return remaining;
  }

  double _pow10(int exponent) {
    double result = 1;
    for (var i = 0; i < exponent; i++) {
      result *= 10;
    }
    return result;
  }
}
