import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

Size getTextSize(BuildContext context, String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
    textScaleFactor: context.textScaleFactor,
  )..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}
