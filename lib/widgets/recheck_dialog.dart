import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecheckDialog extends StatelessWidget {
  const RecheckDialog({
    Key? key,
    required this.title,
    this.okLabel,
  }) : super(key: key);

  final String title;
  final String? okLabel;

  @override
  Widget build(BuildContext context) {
    final buttonTextStyle = context.textTheme.button!.copyWith(
      color: context.theme.colorScheme.background,
    );

    return AlertDialog(
      title: Text(
        title,
        style: context.textTheme.subtitle1!.copyWith(
          color: context.theme.colorScheme.onSurface,
          height: 1.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: Text(
            '취소',
            style: buttonTextStyle,
          ),
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          child: Text(
            okLabel ?? '확인',
            style: buttonTextStyle,
          ),
        )
      ],
    );
  }
}
