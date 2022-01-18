import 'package:flutter/material.dart';

class DefaultBottomSheet extends StatefulWidget {
  /// 기본 [BottomSheet]이다.
  ///
  /// [title] 혹은 [actions]가 변경된 경우 [AnimatedSwitcher]를 통해 전환 애니메이션이 재생된다.
  const DefaultBottomSheet({
    Key? key,
    required this.title,
    this.actions,
    this.titleSpacing = 24.0,
    required this.body,
  }) : super(key: key);

  final Widget title;
  final double titleSpacing;
  final List<Widget>? actions;
  final Widget body;

  @override
  State<DefaultBottomSheet> createState() => _DefaultBottomSheetState();
}

class _DefaultBottomSheetState extends State<DefaultBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: kThemeChangeDuration,
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: Padding(
              key:
                  ValueKey(widget.title.toString() + widget.actions.toString()),
              padding: EdgeInsets.fromLTRB(
                widget.titleSpacing,
                24.0,
                8.0,
                0.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: widget.title,
                    ),
                  ),
                  if (widget.actions != null) ...widget.actions!,
                ],
              ),
            ),
          ),
          widget.body,
        ],
      ),
    );
  }
}
