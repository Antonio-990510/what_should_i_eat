// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyList _$MyListFromJson(Map<String, dynamic> json) => MyList(
      title: json['title'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => MyListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MyListToJson(MyList instance) => <String, dynamic>{
      'title': instance.title,
      'items': instance.items,
    };
