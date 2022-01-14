import 'package:flutter/material.dart';

class DefaultBottomSheet extends StatelessWidget {
  const DefaultBottomSheet({
    Key? key,
    required this.title,
    this.action,
    required this.body,
  }) : super(key: key);

  final Widget title;
  final Widget? action;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 24.0, 8.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                title,
                if (action != null) action!,
              ],
            ),
          ),
          body,
        ],
      ),
    );
  }
}
