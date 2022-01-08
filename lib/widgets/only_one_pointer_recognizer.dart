import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class _OnlyOnePointerRecognizer extends OneSequenceGestureRecognizer {
  int _p = 0;

  @override
  void addPointer(PointerDownEvent event) {
    startTrackingPointer(event.pointer);
    if (_p == 0) {
      resolve(GestureDisposition.rejected);
      _p = event.pointer;
    } else {
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  String get debugDescription => 'only one pointer recognizer';

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void handleEvent(PointerEvent event) {
    if (!event.down && event.pointer == _p) {
      _p = 0;
    }
  }
}

class OnlyOnePointerRecognizer extends StatelessWidget {
  const OnlyOnePointerRecognizer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        _OnlyOnePointerRecognizer:
            GestureRecognizerFactoryWithHandlers<_OnlyOnePointerRecognizer>(
          () => _OnlyOnePointerRecognizer(),
          (_OnlyOnePointerRecognizer instance) {},
        ),
      },
      child: child,
    );
  }
}
