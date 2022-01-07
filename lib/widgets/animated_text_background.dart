import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:what_should_i_eat/utils/text_size_utils.dart';

class AnimatedTextBackground extends StatelessWidget {
  const AnimatedTextBackground({Key? key, required this.child})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, __) => const _FlowAnimatedText(
            label: '뭐 먹을까? 뭐 먹을까? 뭐 먹을까? 뭐 먹을까? 뭐 먹을까? ',
          ),
          itemCount: 100,
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.6, sigmaY: 1.6),
            child: Container(color: Colors.black.withOpacity(0.0)),
          ),
        ),
        child,
      ],
    );
  }
}

class _FlowAnimatedText extends StatefulWidget {
  const _FlowAnimatedText({Key? key, required this.label}) : super(key: key);

  final String label;

  @override
  State<_FlowAnimatedText> createState() => _FlowAnimatedTextState();
}

class _FlowAnimatedTextState extends State<_FlowAnimatedText> {
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
    final textHeight =
        getTextSize(context, widget.label, animatedTextStyle).height;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: SizedBox(
        height: textHeight,
        child: ListView.builder(
          reverse: Random().nextDouble() < 0.7,
          controller: controller,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Text(
              widget.label,
              style: animatedTextStyle,
            );
          },
          itemCount: 500,
        ),
      ),
    );
  }
}
