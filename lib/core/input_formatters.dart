import 'package:flutter/services.dart';

class InputFormatters {
  static final TextInputFormatter digitsOnly = FilteringTextInputFormatter.digitsOnly;
  
  static final TextInputFormatter decimal = FilteringTextInputFormatter.allow(
    RegExp(r'^\d*[.,]?\d*'),
  );

  static final TextInputFormatter positiveInteger = FilteringTextInputFormatter.allow(
    RegExp(r'^[0-9]*$'),
  );
}
