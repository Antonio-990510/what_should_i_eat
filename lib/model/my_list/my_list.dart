import 'package:uuid/uuid.dart';
import 'package:what_should_i_eat/model/my_list/my_list_item.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:what_should_i_eat/model/restaurant_model.dart';

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
  })  : assert(items.isNotEmpty),
        id = const Uuid().v1(),
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

  List<RestaurantModel> toRestaurantList() {
    return _items.map((e) {
      return RestaurantModel(
        // TODO(민성): 아래의 값들 주변에서 식당 정보 얻어오는 branch가 main에 merge되면 수정하기
        rating: 0,
        name: e.name,
        imageSrc: e.imagePath,
        link: '',
        menu: '',
      );
    }).toList();
  }
}
