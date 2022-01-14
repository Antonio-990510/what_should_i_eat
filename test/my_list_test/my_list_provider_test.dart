import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/constants.dart';
import 'package:what_should_i_eat/model/my_list/my_list.dart';
import 'package:what_should_i_eat/model/my_list/my_list_item.dart';
import 'package:what_should_i_eat/providers/my_list_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'utils/fake_path_provider_platform.dart';
import 'utils/file_utils.dart';

void main() {
  group('MyListProvider 테스트', () {
    setUp(() async {
      PathProviderPlatform.instance = FakePathProviderPlatform();
    });

    tearDown(() async {
      await removeMyListFile(PathProviderPlatform.instance);
      Get.find<MyListProvider>().clear();
    });

    test('MyList 생성 테스트', () async {
      final provider = Get.put(MyListProvider());
      final list = MyList(
        title: '기존',
        items: [
          MyListItem(imagePath: kSampleFoodImagePaths.first, name: '아이템1'),
        ],
      );

      await provider.create(list);

      final savedMyList = await getSavedMyList();

      expect(savedMyList.first.title, list.title);
      expect(savedMyList.first.items.first.name, list.items.first.name);

      expect(provider.myLists.first.title, list.title);
      expect(provider.myLists.first.items.first.name, list.items.first.name);
    });

    test('MyList 업데이트 테스트', () async {
      final provider = Get.put(MyListProvider());
      final list = MyList(
        title: '기존',
        items: [
          MyListItem(imagePath: kSampleFoodImagePaths.first, name: '아이템1'),
        ],
      );
      final newList = list.deepCopyWith(title: '새로운');

      await provider.create(list);
      await provider.updateItem(newList);

      final savedMyList = await getSavedMyList();

      expect(savedMyList.first.title, newList.title);
      expect(savedMyList.first.items.first.name, newList.items.first.name);
      expect(savedMyList.length, 1);

      expect(provider.myLists.first.title, newList.title);
      expect(provider.myLists.first.items.first.name, newList.items.first.name);
      expect(provider.myLists.length, 1);
    });
  });
}

Future<List<MyList>> getSavedMyList() async {
  final file = await getMyListFile(PathProviderPlatform.instance);
  final List<dynamic> json = jsonDecode(await file.readAsString());
  return json.map((e) => MyList.fromJson(e as Map<String, dynamic>)).toList();
}
