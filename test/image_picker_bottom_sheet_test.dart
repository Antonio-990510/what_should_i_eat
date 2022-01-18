import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/constants.dart';
import 'package:what_should_i_eat/widgets/image_picker_bottom_sheet.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'utils/fake_path_provider_platform.dart';

void main() {
  group('ImagePickerBottomSheet 테스트', () {
    setUp(() async {
      PathProviderPlatform.instance = FakePathProviderPlatform();
    });

    testWidgets('기기에 있는 이미지를 선택할 수 있다.', (tester) async {
      const MethodChannel channel =
          MethodChannel('plugins.flutter.io/image_picker');
      // 에셋에 있는 파일을 기기에 있는 파일 중 선택된 파일이라고 가정한다.
      final selectedImagePath = kSampleFoodImagePaths.last;
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        return selectedImagePath;
      });

      await tester.pumpWidget(GetMaterialApp(home: Container()));

      final bottomSheetFuture =
          Get.bottomSheet<String>(const ImagePickerBottomSheet());
      await tester.pumpAndSettle();

      await tester.tap(find.text('기기 사진에서\n선택하기'));
      await tester.runAsync(() async {
        await Future.delayed(const Duration(milliseconds: 500));
      });
      await tester.pumpAndSettle();

      final returnedPath = await bottomSheetFuture;
      final fileName = selectedImagePath.split('/').last;
      final path =
          (await PathProviderPlatform.instance.getApplicationDocumentsPath());

      expect(
        returnedPath!.split('/').last,
        fileName,
      );
      expect(
        returnedPath,
        '$path/$fileName',
      );

      // 테스트를 위해 생성된 파일을 삭제한다.
      File(returnedPath).deleteSync();
    });
  });
}
