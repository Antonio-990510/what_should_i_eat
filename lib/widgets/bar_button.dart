import 'package:flutter/material.dart';
import 'package:get/get.dart';

class _BarButton extends StatelessWidget {
  const _BarButton({
    Key? key,
    required this.onPressed,
    this.iconData,
    required this.label,
    this.labelColor,
    this.color,
    this.overlayColor,
  }) : super(key: key);

  final VoidCallback? onPressed;

  final IconData? iconData;

  final String label;

  /// 버튼의 텍스트 색상이 될 변수이다.
  ///
  /// `null`이 전해지는 경우 `context.theme.colorScheme.onPrimary`가 사용된다.
  final Color? labelColor;

  /// 버튼의 색상이 될 변수이다.
  ///
  /// `null`이 전해지는 경우 `context.theme.colorScheme.primary`가 사용된다.
  final Color? color;

  final Color? overlayColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(
            labelColor ?? context.theme.colorScheme.onPrimary,
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            color ?? context.theme.colorScheme.primary,
          ),
          overlayColor:
              MaterialStateProperty.all(overlayColor ?? Colors.black12),
          minimumSize:
              MaterialStateProperty.all<Size>(Size(constraints.maxWidth, 40)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (iconData != null) Icon(iconData!, size: 16),
            if (iconData != null) const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class PrimaryBarButton extends StatelessWidget {
  const PrimaryBarButton({
    Key? key,
    required this.onPressed,
    this.iconData,
    required this.label,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final IconData? iconData;
  final String label;

  @override
  Widget build(BuildContext context) {
    final activated = onPressed != null;

    Color color = context.theme.colorScheme.primary;
    Color labelColor = context.theme.colorScheme.onPrimary;
    if (!activated) {
      color = color.withOpacity(0.2);
      labelColor = labelColor.withOpacity(0.6);
    }

    return _BarButton(
      onPressed: onPressed,
      label: label,
      iconData: iconData,
      labelColor: labelColor,
      color: color,
    );
  }
}

class SecondaryBarButton extends StatelessWidget {
  const SecondaryBarButton({
    Key? key,
    required this.onPressed,
    this.iconData,
    required this.label,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final IconData? iconData;
  final String label;

  @visibleForTesting
  bool get enabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled;

    Color color = context.theme.colorScheme.background;
    Color labelColor = context.theme.colorScheme.onBackground;
    if (!isEnabled) {
      color = color.withOpacity(0.2);
      labelColor = labelColor.withOpacity(0.6);
    }

    return _BarButton(
      onPressed: onPressed,
      label: label,
      iconData: iconData,
      labelColor: labelColor,
      color: color,
    );
  }
}

class TextOnlyBarButton extends StatelessWidget {
  const TextOnlyBarButton({
    Key? key,
    required this.onPressed,
    this.labelColor,
    required this.label,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Color? labelColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return _BarButton(
      onPressed: onPressed,
      label: label,
      labelColor: labelColor,
      color: Colors.transparent,
      overlayColor: Colors.white24,
    );
  }
}
