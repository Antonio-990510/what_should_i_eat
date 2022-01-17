import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/constants.dart';
import 'package:what_should_i_eat/model/my_list/my_list_item.dart';
import 'package:what_should_i_eat/widgets/asset_or_file_image.dart';
import 'package:what_should_i_eat/widgets/my_list/my_list_item_edit_field.dart';

void main() {
  group('MyListItemEditField 테스트', () {
    testWidgets('공백이 아닌 이름을 입력한 경우만 저장 버튼이 보인다.', (tester) async {
      final item = MyListItem(
        name: '항목',
        imagePath: kSampleFoodImagePaths.first,
      );

      await tester.pumpWidget(GetMaterialApp(home: Container()));

      Get.bottomSheet(MyListItemEditField(item: item));
      await tester.pumpAndSettle();

      expect(Get.isBottomSheetOpen, true);
      expect(find.byType(IconButton), findsOneWidget);

      // 공백을 입력한 경우
      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      expect(find.byType(IconButton), findsNothing);

      await tester.enterText(find.byType(TextField), '입니다');
      await tester.pump();

      expect(find.byType(IconButton), findsOneWidget);

      // 사진만 수정한 경우
      await tester.tap(find.byType(AssetOrFileImage).last);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Image).last);
      await tester.pumpAndSettle();

      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('저장을 누르고 반환된 인스턴스는 기존에 있던 인스턴스와는 다른 것이다.', (tester) async {
      final item = MyListItem(
        name: '기존항목',
        imagePath: kSampleFoodImagePaths.first,
      );

      await tester.pumpWidget(GetMaterialApp(home: Container()));

      final bottomSheetFuture =
          Get.bottomSheet<MyListItem>(MyListItemEditField(item: item));
      await tester.pumpAndSettle();

      expect(Get.isBottomSheetOpen, true);

      await tester.enterText(find.byType(TextField), '새로운항목');
      await tester.pump();

      expect(find.byType(IconButton), findsOneWidget);

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        final newItem = await bottomSheetFuture;
        expect(newItem.hashCode != item.hashCode, true);
      });
    });

    testWidgets('기본 생성자로 만들어진 경우 제출 버튼을 누르면 바텀 시트가 사라진다.', (tester) async {
      await tester.pumpWidget(GetMaterialApp(home: Container()));

      Get.bottomSheet<MyListItem>(
        MyListItemEditField(
          item: MyListItem(
            name: '항목',
            imagePath: kSampleFoodImagePaths.first,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(Get.isBottomSheetOpen, true);

      await tester.enterText(find.byType(TextField), '새로운항목');
      await tester.pump();

      expect(find.byType(IconButton), findsOneWidget);

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(Get.isBottomSheetOpen, false);
    });

    testWidgets('`createMode` 생성자로 만들어진 경우 제출 버튼을 눌러도 바텀 시트가 사라지지 않는다.',
        (tester) async {
      await tester.pumpWidget(GetMaterialApp(home: Container()));

      Get.bottomSheet<MyListItem>(
        MyListItemEditField.createMode(
          onSubmitted: (item) {
            expect(item.name, '새로운항목');
          },
        ),
      );
      await tester.pumpAndSettle();

      expect(Get.isBottomSheetOpen, true);

      await tester.enterText(find.byType(TextField), '새로운항목');
      await tester.pump();

      expect(find.byType(IconButton), findsOneWidget);

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(Get.isBottomSheetOpen, true);
    });

    testWidgets('제목이 공백이면 키보드의 엔터 버튼으로 제출이 안된다.', (tester) async {
      await tester.pumpWidget(GetMaterialApp(home: Container()));

      Get.bottomSheet<MyListItem>(
        MyListItemEditField(
          item: MyListItem(
            name: '항목',
            imagePath: kSampleFoodImagePaths.first,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(Get.isBottomSheetOpen, true);

      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(Get.isBottomSheetOpen, true);
    });

    group('`initImagePath` 매개변수가', () {
      testWidgets('`null`로 전달되면 `item`의 이미지가 보인다.', (tester) async {
        final imagePath = kSampleFoodImagePaths[2];

        await tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: MyListItemEditField(
                item: MyListItem(
                  name: '항목',
                  imagePath: imagePath,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          tester.widget<AssetOrFileImage>(find.byType(AssetOrFileImage)).path,
          imagePath,
        );
      });

      testWidgets('전달되면 해당 이미지가 보인다.', (tester) async {
        final imagePath = kSampleFoodImagePaths[2];
        final initImagePath = kSampleFoodImagePaths[4];

        await tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: MyListItemEditField(
                item: MyListItem(
                  name: '항목',
                  imagePath: imagePath,
                ),
                initImagePath: initImagePath,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          tester.widget<AssetOrFileImage>(find.byType(AssetOrFileImage)).path,
          initImagePath,
        );
      });
    });

    group('`controller 매개 변수가', () {
      testWidgets('`null`이면 `item`의 이름이 보인다.', (tester) async {
        const name = '항목';

        await tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: MyListItemEditField(
                item: MyListItem(
                  name: name,
                  imagePath: kSampleFoodImagePaths[2],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(name), findsOneWidget);
      });

      testWidgets('전달되면 `controller`의 텍스트가 보인다.', (tester) async {
        final controller = TextEditingController()..text = '텍스트';

        await tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: MyListItemEditField(
                item: MyListItem(
                  name: '항목',
                  imagePath: kSampleFoodImagePaths[2],
                ),
                controller: controller,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(controller.text), findsOneWidget);
      });
    });
  });
}
