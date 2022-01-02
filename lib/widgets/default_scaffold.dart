import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DefaultScaffold extends StatelessWidget {
  const DefaultScaffold({
    Key? key,
    this.actions = const [],
    this.padding,
    required this.body,
  }) : super(key: key);

  final List<Widget> actions;
  final EdgeInsets? padding;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Get.theme.colorScheme;
    final canPop = ModalRoute.of(context)?.canPop ?? false;

    Widget leading = const SizedBox();
    if (canPop) {
      leading = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: IconButton(
          icon: const _BackButtonIcon(),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => Navigator.maybePop(context),
        ),
      );
    }

    final bool hasAppBarSpace = canPop || actions.isNotEmpty;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasAppBarSpace)
              Padding(
                padding: EdgeInsets.only(
                  left: canPop ? 0 : 24,
                  right: 8,
                  top: 8,
                  bottom: 8,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    leading,
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: actions,
                      ),
                    ),
                  ],
                ),
              ),
            if (hasAppBarSpace) const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: padding ?? const EdgeInsets.all(24.0),
                child: body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackButtonIcon extends StatelessWidget {
  /// Creates an icon that shows the appropriate "back" image for
  /// the current platform (as obtained from the [Theme]).
  const _BackButtonIcon({Key? key}) : super(key: key);

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
    return Icon(_getIconData(Theme.of(context).platform));
  }
}
