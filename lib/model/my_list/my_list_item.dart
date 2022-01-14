import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

part 'my_list_item.g.dart';

// flutter pub run build_runner build
// 위의 명령어 터미널에 입력하여 직렬화 파일 생성가능
@JsonSerializable()
class MyListItem {
  final String name;
  final String imagePath;

  const MyListItem({
    required this.name,
    required this.imagePath,
  });

  factory MyListItem.fromJson(Map<String, dynamic> json) =>
      _$MyListItemFromJson(json);

  Map<String, dynamic> toJson() => _$MyListItemToJson(this);

  @override
  String toString() {
    return 'MyListItem: $name, $imagePath\n';
  }

  @override
  bool operator==(Object other) {
    if (other is! MyListItem) return false;
    return name == other.name && imagePath == other.imagePath;
  }

  @override
  int get hashCode => hashValues(name, imagePath);
}
