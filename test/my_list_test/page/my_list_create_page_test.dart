import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/constants.dart';
import 'package:what_should_i_eat/model/my_list/my_list_item.dart';
import 'package:what_should_i_eat/pages/my_list/my_list_create_page.dart';
import 'package:what_should_i_eat/providers/my_list_provider.dart';
import 'package:what_should_i_eat/widgets/bar_button.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../utils/fake_path_provider_platform.dart';
import '../utils/file_utils.dart';

void main() {
  group('MyListCreatePage 테스트', () {
    setUp(() async {
      PathProviderPlatform.instance = FakePathProviderPlatform();
    });

    tearDown(() async {
      Get.deleteAll();
      await removeMyListFile(PathProviderPlatform.instance);
    });

    testWidgets('첫 번째 페이지에서 제목을 입력해야 다음 버튼이 보이고 탭할 수 있다.', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: MyListCreatePage()));

      Future<void> tapContinueButton() async {
        await tester.tap(find.text('다음'), warnIfMissed: false);
      }

      await tapContinueButton();
      await tester.pumpAndSettle();
      await tapContinueButton();
      await tester.pumpAndSettle();

      expect(find.byType(MyListCreatePage), findsOneWidget);

      await tester.enterText(find.byType(TextField), '입력한 제목');
      await tester.pumpAndSettle();
      await tapContinueButton();
      await tester.pumpAndSettle();

      expect(find.byType(MyListCreatePage), findsNothing);
      expect(find.byType(MyListCreateDetailPage), findsOneWidget);
    });

    testWidgets('`CreatePage`에서 만든 제목이 `CreateDetailPage`에서 전달되어 나타난다.',
        (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: MyListCreatePage()));

      await tester.enterText(find.byType(TextField), '새로운 리스트');
      await tester.pump();
      await tester.tap(find.byType(SecondaryBarButton));
      await tester.pumpAndSettle();

      expect(find.textContaining('새로운 리스트'), findsOneWidget);
    });

    testWidgets('`MyListDetailPage`에서 뒤로가기를 하고 다시 진입해도 상태가 유지된다.',
        (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: MyListCreatePage()));
      await tester.enterText(find.byType(TextField), '새로운 리스트');
      await tester.pump();
      await tester.tap(find.byType(SecondaryBarButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '항목1');
      await tester.pump();
      await _tapAddIcon(tester);
      await tester.pumpAndSettle();

      Get.back();
      await tester.pumpAndSettle();

      expect(find.text('새로운 리스트'), findsOneWidget);

      await tester.tap(find.byType(SecondaryBarButton));
      await tester.pumpAndSettle();

      expect(find.text('항목1'), findsOneWidget);
    });

    testWidgets('샘플 이미지를 변경하면 `TextField`의 좌측 이미지도 해당 이미지로 변경된다.',
        (tester) async {
      Get.put(CreateProvider());
      await tester.pumpWidget(const GetMaterialApp(
        home: MyListCreateDetailPage(),
      ));

      await tester.tap(find.byType(Image));
      await tester.pumpAndSettle();

      final imageFinder = find.byType(Image).last;
      final imageWidget = tester.widget<Image>(imageFinder);
      await tester.tap(imageFinder);
      await tester.pumpAndSettle();

      expect(find.image(imageWidget.image), findsOneWidget);
    });

    testWidgets('기기에 있는 샘플 이미지를 선택할 수 있다.', (tester) async {
      const MethodChannel channel =
          MethodChannel('plugins.flutter.io/image_picker');
      // 에셋에 있는 파일을 기기에 있는 파일 중 선택된 파일이라고 가정한다.
      final selectedImagePath = kSampleFoodImagePaths.last;
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return selectedImagePath;
      });

      final createProvider = Get.put(CreateProvider());
      await tester.pumpWidget(const GetMaterialApp(
        home: MyListCreateDetailPage(),
      ));
      await tester.tap(find.byType(Image));
      await tester.pumpAndSettle();
      await tester.tap(find.text('기기 사진에서\n선택하기'));
      await tester.runAsync(() async {
        await Future.delayed(const Duration(milliseconds: 500));
      });
      await tester.pumpAndSettle();

      final fileName = selectedImagePath.split('/').last;
      final path =
          (await PathProviderPlatform.instance.getApplicationDocumentsPath());

      expect(
        createProvider.selectedImagePath.split('/').last,
        fileName,
      );
      expect(
        createProvider.selectedImagePath,
        '$path/$fileName',
      );

      // 테스트를 위해 생성된 파일을 삭제한다.
      File(createProvider.selectedImagePath).deleteSync();
    });

    testWidgets('항목을 추가하면 항목 리스트에 나타난다.', (tester) async {
      Get.put(CreateProvider());
      await tester.pumpWidget(const GetMaterialApp(
        home: MyListCreateDetailPage(),
      ));

      await tester.enterText(find.byType(TextField), '항목1');
      await tester.pump();
      await _tapAddIcon(tester);
      await tester.pumpAndSettle();

      expect(find.text('항목1'), findsOneWidget);
      expect(Get.find<CreateProvider>().list.length, 1);
    });

    testWidgets('항목이 많을 때 항목을 추가하면 제일 아래로 스크롤되며 추가한 항목이 보인다.', (tester) async {
      final provider = Get.put(CreateProvider());
      for (int i = 0; i < 50; ++i) {
        provider.add(MyListItem(
          name: '항목',
          imagePath: kSampleFoodImagePaths.first,
        ));
      }
      provider.add(MyListItem(
        name: '제일 마지막 항목',
        imagePath: kSampleFoodImagePaths.first,
      ));

      final globalKey = GlobalKey<MyListCreateDetailPageState>();
      await tester.pumpWidget(GetMaterialApp(
        home: MyListCreateDetailPage(key: globalKey),
      ));

      expect(find.text('제일 마지막 항목'), findsNothing);

      await tester.enterText(find.byType(TextField), '새로운 항목');
      await tester.pump();
      await _tapAddIcon(tester);
      await tester.pumpAndSettle();

      expect(find.text('제일 마지막 항목'), findsOneWidget);
      expect(find.text('새로운 항목'), findsOneWidget);

      final scrollController = globalKey.currentState!.scrollController;
      expect(
        scrollController.offset,
        scrollController.position.maxScrollExtent,
      );
    });

    testWidgets('새로운 나의 리스트를 생성하면 해당 리스트가 `MyListBottomSheet`에서 등장한다.',
        (tester) async {
      await tester.runAsync(() async {
        Get.put(MyListProvider());
        Get.put(CreateProvider()).title = '새 리스트';
        await tester.pumpWidget(const GetMaterialApp(
          home: MyListCreateDetailPage(),
        ));

        await tester.enterText(find.byType(TextField), '항목1');
        await tester.pump();
        await _tapAddIcon(tester);
        await tester.pumpAndSettle();

        await tester.tap(find.byType(SecondaryBarButton));
        await tester.pumpAndSettle();
        await Future.delayed(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        expect(Get.isBottomSheetOpen, true);
        expect(Get.find<MyListProvider>().myLists.last.title, '새 리스트');
        expect(find.text('새 리스트'), findsOneWidget);
      });
    });

    testWidgets('두 번째 페이지에서 항목을 추가해야 저장 버튼이 보이고 탭할 수 있다.', (tester) async {
      await tester.runAsync(() async {
        Get.put(MyListProvider());
        Get.put(CreateProvider()).title = '새 리스트';
        await tester.pumpWidget(const GetMaterialApp(
          home: MyListCreateDetailPage(),
        ));

        await tester.tap(find.byType(SecondaryBarButton), warnIfMissed: false);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(SecondaryBarButton), warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(
          find.byType(MyListCreateDetailPage),
          findsOneWidget,
          reason: '버튼이 보이지 않아 페이지가 그대로 있다.',
        );

        await tester.enterText(find.byType(TextField), '항목1');
        await tester.pump();
        await _tapAddIcon(tester);
        await tester.pumpAndSettle();

        await tester.tap(find.byType(SecondaryBarButton));
        await tester.pumpAndSettle();
        await Future.delayed(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        expect(find.byType(MyListCreateDetailPage), findsNothing);
      });
    });
  });
}

Future<void> _tapAddIcon(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.add_circle_outline_rounded));
}

class MockPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements ImagePickerPlatform {}
