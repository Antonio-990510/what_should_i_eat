import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/constants.dart';
import 'package:what_should_i_eat/model/my_list/my_list_item.dart';
import 'package:what_should_i_eat/widgets/my_list/my_list_item_tile.dart';

void main() {
  group('MyListItemTile 테스트', () {
    testWidgets('이름을 수정 후 저장하면 `onUpdate` 콜백 함수가 정확한 매개변수와 함께 호출된다.',
        (tester) async {
      final item = MyListItem(
        name: '항목',
        imagePath: kSampleFoodImagePaths.first,
      );

      await tester.pumpWidget(
        _Wrapper(
          child: _MockMyListItemTile(
            item: item,
            onUpdate: (oldItem, newItem) {
              expect(oldItem.name, item.name);
              expect(newItem.name, '바뀐이름');
            },
          ),
        ),
      );
      await tester.tap(find.byType(_MockMyListItemTile));
      await tester.pumpAndSettle();

      expect(Get.isBottomSheetOpen, true);

      await tester.enterText(find.byType(TextField), '바뀐이름');
      await tester.pump();
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
    });
  });
}

class _MockMyListItemTile extends MyListItemTile {
  _MockMyListItemTile({
    Key? key,
    required MyListItem item,
    MyListItemUpdateCallback? onUpdate,
  }) : super(
          key: key,
          item: item,
          onDismissed: (direction) {},
          onUpdate: onUpdate ?? (oldItem, newItem) {},
        );
}

class _Wrapper extends StatelessWidget {
  const _Wrapper({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }
}
