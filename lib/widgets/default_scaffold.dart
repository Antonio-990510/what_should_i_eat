import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/widgets/custom_back_button.dart';

class DefaultScaffold extends StatelessWidget {
  const DefaultScaffold({
    Key? key,
    this.noAppbar = false,
    this.appBarBottomSpace = 24.0,
    this.actions = const [],
    this.padding,
    required this.body,
    this.backgroundColor,
    this.backButtonColor,
  }) : super(key: key);

  final bool noAppbar;
  final double appBarBottomSpace;
  final List<Widget> actions;
  final EdgeInsets? padding;
  final Widget body;
  final Color? backgroundColor;
  final Color? backButtonColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Get.theme.colorScheme;
    final canPop = ModalRoute.of(context)?.canPop ?? false;

    Widget leading = const SizedBox();
    if (canPop) {
      leading = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: CustomBackButton(iconColor: backButtonColor),
      );
    }

    final bool hasAppBarSpace = !noAppbar && (canPop || actions.isNotEmpty);

    return Scaffold(
      backgroundColor: backgroundColor ?? colorScheme.background,
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
            if (hasAppBarSpace) SizedBox(height: appBarBottomSpace),
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
