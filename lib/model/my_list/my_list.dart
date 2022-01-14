import 'package:uuid/uuid.dart';
import 'package:what_should_i_eat/model/my_list/my_list_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_list.g.dart';

// flutter pub run build_runner build
// 위의 명령어 터미널에 입력하여 직렬화 파일 생성가능
@JsonSerializable()
class MyList {
  final String id;

  final String title;

  final List<MyListItem> _items;

  MyList({
    required this.title,
    required List<MyListItem> items,
  })  : id = const Uuid().v1(),
        _items = items;

  MyList._({
    required this.id,
    required this.title,
    required List<MyListItem> items,
  }) : _items = items;

  List<MyListItem> get items => List.unmodifiable(_items);

  factory MyList.fromJson(Map<String, dynamic> json) => _$MyListFromJson(json);

  Map<String, dynamic> toJson() => _$MyListToJson(this);

  /// [id]까지 복사하여 새로운 [MyList] 인스턴스를 반환한다.
  MyList deepCopyWith({
    String? title,
    List<MyListItem>? items,
  }) {
    return MyList._(
      id: id,
      title: title ?? this.title,
      items: items ?? _items,
    );
  }
}
