import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

enum CustomBackButtonStyle {
  normal,
  fill,
  border,
}

class CustomBackButton extends StatelessWidget {
  /// Creates an icon that shows the appropriate "back" image for
  /// the current platform (as obtained from the [Theme]).
  const CustomBackButton({
    Key? key,
    this.style = CustomBackButtonStyle.normal,
    this.fillColor,
    this.iconColor,
  }) : super(key: key);

  final CustomBackButtonStyle style;
  final Color? fillColor;
  final Color? iconColor;

  /// Returns the appropriate "back" icon for the given `platform`.
  static IconData _getIconData(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return Icons.arrow_back_rounded;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return Icons.arrow_back_ios_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconButton = IconButton(
      icon: Icon(_getIconData(Theme.of(context).platform)),
      color: iconColor,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () => Navigator.maybePop(context),
    );
    switch (style) {
      case CustomBackButtonStyle.normal:
        return iconButton;
      case CustomBackButtonStyle.fill:
        return Container(
          decoration: BoxDecoration(
            color: fillColor ?? context.theme.colorScheme.background,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                offset: Offset(2.0, 2.0),
                spreadRadius: 2,
                blurRadius: 4,
              )
            ],
          ),
          child: iconButton,
        );
      case CustomBackButtonStyle.border:
        return Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white70),
          ),
          child: iconButton,
        );
    }
  }
}
