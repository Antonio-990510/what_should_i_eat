import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:what_should_i_eat/utils/text_size_utils.dart';
import 'package:what_should_i_eat/widgets/default_scaffold.dart';
import 'package:what_should_i_eat/widgets/flow_animated_text.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const titleLabel = '뭐 먹을까?';
    final titleTextStyle = context.textTheme.headline3!.copyWith(
      fontWeight: FontWeight.bold,
    );
    final titleTextSize = getTextSize(titleLabel, titleTextStyle);

    return WillPopScope(
      onWillPop: () => Future(() => false),
      child: DefaultScaffold(
        noAppbar: true,
        padding: EdgeInsets.zero,
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  for (int i = 0; i < 14; ++i)
                    const FlowAnimatedText(
                      label: '뭐 먹을까? 뭐 먹을까? 뭐 먹을까? 뭐 먹을까? 뭐 먹을까? ',
                    ),
                ],
              ),
            ),
            Center(
              child: Container(
                color: context.theme.colorScheme.background,
                child: Hero(
                  tag: 'mainTitle',
                  child: SizedBox(
                    width: titleTextSize.width + 10,
                    height: titleTextSize.height,
                    child: Text(
                      titleLabel,
                      style: titleTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
