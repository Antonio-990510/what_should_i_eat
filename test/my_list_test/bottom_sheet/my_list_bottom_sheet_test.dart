import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/constants.dart';
import 'package:what_should_i_eat/model/my_list/my_list.dart';
import 'package:what_should_i_eat/model/my_list/my_list_item.dart';
import 'package:what_should_i_eat/providers/my_list_provider.dart';
import 'package:what_should_i_eat/widgets/my_list/my_list_bottom_sheet.dart';

final MyList sampleMyList = MyList(
  title: '기존',
  items: [
    MyListItem(imagePath: kSampleFoodImagePaths.first, name: '아이템1'),
  ],
);

void main() {
  group('MyListBottomSheet 테스트', () {
    tearDown(() {
      Get.deleteAll();
    });

    testWidgets('리스트가 비어있는 경우 편집 버튼이 안보인다.', (tester) async {
      final provider = Get.put(MyListProvider());
      await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));

      Get.bottomSheet(const MyListBottomSheet());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit_rounded), findsNothing);

      provider.add(sampleMyList);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit_rounded), findsOneWidget);
    });

    testWidgets('편집 버튼을 누르면 편집모드로 전환되어 뒤로가기 버튼이 생기고 기존 액션 버튼들은 사라진다.',
        (tester) async {
      final provider = Get.put(MyListProvider())..add(sampleMyList);

      await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));

      Get.bottomSheet(const MyListBottomSheet());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.edit_rounded));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit_rounded), findsNothing);
      expect(find.byIcon(Icons.add_rounded), findsNothing);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(provider.isBottomSheetEditMode, true);
    });

    testWidgets('편집모드에서 마지막 하나 남은 리스트를 삭제하면 기본 모드로 돌아간다.', (tester) async {
      final provider = Get.put(MyListProvider())..add(sampleMyList);

      await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));

      Get.bottomSheet(const MyListBottomSheet());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.edit_rounded));
      await tester.pumpAndSettle();

      expect(provider.isBottomSheetEditMode, true);

      provider.remove(sampleMyList);
      await tester.pumpAndSettle();

      expect(provider.isBottomSheetEditMode, false);
    });
  });
}
