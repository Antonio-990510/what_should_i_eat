import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:what_should_i_eat/constants.dart';
import 'package:what_should_i_eat/widgets/adaptive_image.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'utils/fake_path_provider_platform.dart';

void main() {
  group('AdaptiveImage 테스트', () {
    testWidgets('샘플 이미지에 속한 경우 에셋 이미지를 보여준다.', (tester) async {
      final path = kSampleFoodImagePaths.first;

      await tester.pumpWidget(GetMaterialApp(home: AdaptiveImage(path: path)));

      expect(find.image(Image.asset(path).image), findsOneWidget);
    });

    testWidgets('웹 사이트 URL 경우 네트워크 이미지를 보여준다.', (tester) async {
      mockNetworkImagesFor(() async {
        const path = 'https://t1.daumcdn.net/cfile/blog/9954544A5B12667A15';

        await tester.pumpWidget(GetMaterialApp(
          home: AdaptiveImage(path: path),
        ));

        expect(find.image(Image.network(path).image), findsOneWidget);
      });
    });

    testWidgets('에셋 혹은 URL이 아닌 경우 파일 이미지를 보여준다.', (tester) async {
      PathProviderPlatform.instance = FakePathProviderPlatform();

      final fileName = kSampleFoodImagePaths.first.split('/').last;
      final fromPath = kSampleFoodImagePaths.first;
      final toPath =
          (await getApplicationDocumentsDirectory()).path + '/' + fileName;

      await tester.runAsync(() async {
        await File(fromPath).copy(toPath);
      });

      await tester.pumpWidget(GetMaterialApp(
        home: AdaptiveImage(path: toPath),
      ));

      final imageFile = File(toPath);
      expect(find.image(Image.file(imageFile).image), findsOneWidget);

      // 테스트를 위해 생성된 이미지 제거
      imageFile.deleteSync();
    });
  });
}
