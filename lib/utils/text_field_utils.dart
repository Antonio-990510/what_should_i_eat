import 'package:flutter/services.dart';

List<LengthLimitingTextInputFormatter> get defaultInputFormatters {
  return [
    LengthLimitingTextInputFormatter(40),
  ];
}
