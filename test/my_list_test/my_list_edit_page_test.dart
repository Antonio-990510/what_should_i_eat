import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/constants.dart';
import 'package:what_should_i_eat/model/my_list/my_list.dart';
import 'package:what_should_i_eat/model/my_list/my_list_item.dart';
import 'package:what_should_i_eat/pages/my_list/my_list_edit_page.dart';
import 'package:what_should_i_eat/widgets/bar_button.dart';
import 'package:what_should_i_eat/widgets/my_list/my_list_item_tile.dart';

void main() {
  group('MyListEditPage 테스트', () {
    testWidgets('`MyList`가 수정되지 않으면 저장 버튼은 비활성화 되어있다.', (tester) async {
      final MyList myList = MyList(
        title: '리스트',
        items: [
          MyListItem(name: '항목1', imagePath: kSampleFoodImagePaths.first),
          MyListItem(name: '항목2', imagePath: kSampleFoodImagePaths.first),
        ],
      );

      await tester.pumpWidget(GetMaterialApp(
        home: MyListEditPage(myList: myList),
      ));

      expect(_getSaveButton(tester).enabled, false);
    });

    testWidgets('`MyList`의 항목이 수정되고 비어있지 않아야 저장 버튼이 활성화 된다.', (tester) async {
      final MyList myList = MyList(
        title: '리스트',
        items: [
          MyListItem(name: '항목1', imagePath: kSampleFoodImagePaths.first),
          MyListItem(name: '항목2', imagePath: kSampleFoodImagePaths.first),
        ],
      );

      await tester.pumpWidget(GetMaterialApp(
        home: MyListEditPage(myList: myList),
      ));

      expect(find.byType(MyListItemTile), findsNWidgets(2));
      expect(_getSaveButton(tester).enabled, false);

      await _dismissFirstItemTile(tester);

      expect(find.byType(MyListItemTile), findsOneWidget);
      expect(_getSaveButton(tester).enabled, true);

      await _dismissFirstItemTile(tester);

      expect(find.byType(MyListItemTile), findsNothing);
      expect(_getSaveButton(tester).enabled, false);
    });

    testWidgets('`MyList`의 제목이 수정되고 공백이 아니면 저장 버튼이 활성화 된다.', (tester) async {
      final MyList myList = MyList(
        title: '기존이름',
        items: [
          MyListItem(name: '항목1', imagePath: kSampleFoodImagePaths.first),
        ],
      );

      await tester.pumpWidget(GetMaterialApp(
        home: MyListEditPage(myList: myList),
      ));

      expect(_getSaveButton(tester).enabled, false);

      await tester.enterText(find.byType(TextField), '바뀐제목');
      await tester.pump();

      expect(_getSaveButton(tester).enabled, true);

      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      expect(_getSaveButton(tester).enabled, false);
    });

    testWidgets('`MyList`의 제목이 수정되었으나 리스트 항목이 비었다면 저장 버튼은 비활성화된다.',
        (tester) async {
      final MyList myList = MyList(
        title: '기존이름',
        items: [
          MyListItem(name: '항목1', imagePath: kSampleFoodImagePaths.first),
        ],
      );

      await tester.pumpWidget(GetMaterialApp(
        home: MyListEditPage(myList: myList),
      ));

      expect(_getSaveButton(tester).enabled, false);

      await tester.enterText(find.byType(TextField), '바뀐제목');
      await tester.pump();

      expect(_getSaveButton(tester).enabled, true);

      await _dismissFirstItemTile(tester);

      expect(_getSaveButton(tester).enabled, false);
    });

    testWidgets('항목이 많을 때 새로 아이템을 추가하면 제일 아래로 스크롤이 되어 항목이 보인다.',
        (tester) async {
      final MyList myList = MyList(
        title: '기존이름',
        items: [
          for (int i = 0; i < 50; ++i)
            MyListItem(name: '항목', imagePath: kSampleFoodImagePaths.first),
          MyListItem(
            name: '제일 아래 항목',
            imagePath: kSampleFoodImagePaths.first,
          ),
        ],
      );

      await tester.pumpWidget(GetMaterialApp(
        home: MyListEditPage(myList: myList),
      ));

      expect(find.text('제일 아래 항목'), findsNothing);

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(Get.isBottomSheetOpen, true);

      await tester.enterText(find.byType(TextField).last, '새로운 항목');
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add_circle_outline_rounded));
      await tester.pumpAndSettle();

      expect(find.text('제일 아래 항목'), findsOneWidget);
      expect(find.text('새로운 항목'), findsOneWidget);
    });
  });
}

SecondaryBarButton _getSaveButton(WidgetTester tester) {
  return tester.widget<SecondaryBarButton>(find.byType(SecondaryBarButton));
}

Future<void> _dismissFirstItemTile(WidgetTester tester) async {
  await tester.drag(
    find.byType(MyListItemTile).first,
    const Offset(500.0, 0.0),
  );
  await tester.pumpAndSettle();
  await tester.runAsync(() async {
    // 실제 리스트가 삭제될 때까지 기다린다.
    await Future.delayed(const Duration(milliseconds: 100));
  });
}
