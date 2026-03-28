import 'package:flutter/services.dart';

class InputFormatters {
  static final TextInputFormatter digitsOnly =
      FilteringTextInputFormatter.digitsOnly;

  static final TextInputFormatter decimal = FilteringTextInputFormatter.allow(
    RegExp(r'^\d*[.,]?\d*'),
  );

  static final TextInputFormatter positiveInteger =
      FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'));

  static final TextInputFormatter phone = FilteringTextInputFormatter.allow(
    RegExp(r'^[0-9]{0,10}$'),
  );

  static final TextInputFormatter phoneExact =
      FilteringTextInputFormatter.digitsOnly;

  static final TextInputFormatter textOnly = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]'),
  );

  static final TextInputFormatter price = FilteringTextInputFormatter.allow(
    RegExp(r'^\d{0,7}$'),
  );

  static final TextInputFormatter stock = FilteringTextInputFormatter.allow(
    RegExp(r'^\d{0,2}$'),
  );
}
