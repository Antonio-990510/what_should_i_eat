import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

class FlowAnimatedText extends StatefulWidget {
  const FlowAnimatedText({Key? key, required this.label}) : super(key: key);

  final String label;

  @override
  State<FlowAnimatedText> createState() => _FlowAnimatedTextState();
}

class _FlowAnimatedTextState extends State<FlowAnimatedText> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final random = Random();
      final duration = Duration(hours: 8, minutes: random.nextInt(180));
      final maxScrollExtent = controller.position.maxScrollExtent;
      final randomInitPosition = random.nextDouble() * 40;

      controller.jumpTo(randomInitPosition);
      controller.animateTo(maxScrollExtent,
          duration: duration, curve: Curves.linear);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animatedTextStyle = context.textTheme.headline4!.copyWith(
      color: const Color(0x2EFFFFFF),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          reverse: Random().nextDouble() < 0.7,
          controller: controller,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Text(
              widget.label,
              style: animatedTextStyle,
              textScaleFactor: 1.0,
            );
          },
          itemCount: 500,
        ),
      ),
    );
  }
}
