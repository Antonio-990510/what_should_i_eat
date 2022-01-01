import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BarButton extends StatelessWidget {
  const BarButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.labelColor,
    this.color,
  }) : super(key: key);

  final VoidCallback onPressed;

  final String label;

  /// 버튼의 텍스트 색상이 될 변수이다.
  ///
  /// `null`이 전해지는 경우 `context.theme.colorScheme.onPrimary`가 사용된다.
  final Color? labelColor;

  /// 버튼의 색상이 될 변수이다.
  ///
  /// `null`이 전해지는 경우 `context.theme.colorScheme.primary`가 사용된다.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(
          labelColor ?? context.theme.colorScheme.onPrimary,
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          color ?? context.theme.colorScheme.primary,
        ),
        overlayColor: MaterialStateProperty.all(Colors.black12),
        minimumSize: MaterialStateProperty.all<Size>(Size(context.width, 40)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        ),
      ),
      child: Text(label),
    );
  }
}
