import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

class CustomBackButton extends StatelessWidget {
  /// Creates an icon that shows the appropriate "back" image for
  /// the current platform (as obtained from the [Theme]).
  const CustomBackButton({
    Key? key,
    this.hasCircleFill = false,
    this.fillColor,
  }) : super(key: key);

  final bool hasCircleFill;
  final Color? fillColor;

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
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: () => Navigator.maybePop(context),
    );
    if (hasCircleFill) {
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
    }
    return iconButton;
  }
}
