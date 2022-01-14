import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:what_should_i_eat/model/my_list/my_list.dart';

class MyListProvider extends GetxController {
  static const _fileName = 'my_list.json';

  Future<void>? _readListFuture;

  File? _file;

  final List<MyList> _myLists = [];

  List<MyList> get myLists => List.unmodifiable(_myLists);

  MyListProvider() {
    _readListFuture = _readListFromLocal();
  }

  Future<File> get _localFile async {
    if (_file != null) return _file!;
    _file = await _initLocalFile();
    return _file!;
  }

  Future<File> _initLocalFile() async {
    final _directory = await getApplicationDocumentsDirectory();
    final _path = _directory.path;
    return File('$_path/$_fileName');
  }

  Future<void> _readListFromLocal() async {
    final File file = await _localFile;
    final String content;
    try {
      content = await file.readAsString();
    } on FileSystemException {
      return;
    }

    final List<dynamic> jsonData = jsonDecode(content);
    _myLists.addAll(jsonData
        .map((e) => MyList.fromJson(e as Map<String, dynamic>))
        .toList());
    update();
  }

  Future<void> _ensureReadingFutureIsDone() async {
    if (_readListFuture != null) {
      await _readListFuture;
      _readListFuture = null;
    }
  }

  /// [myList]를 파일에 저장하여 추가한다.
  ///
  // TODO(민성): Firebase와 연동하여 파일을 저장하여야 한다.
  Future<void> create(MyList myList) async {
    await _ensureReadingFutureIsDone();

    final File file = await _localFile;
    _myLists.add(myList);
    update();

    await file.writeAsString(jsonEncode(_myLists));
  }

  /// [myList]와 `id`가 동일한 데이터를 전달된 [myList]로 교체한다.
  Future<void> updateItem(MyList myList) async {
    await _ensureReadingFutureIsDone();

    final index = _myLists.indexWhere((e) => e.id == myList.id);
    if (index == -1) return;

    _myLists[index] = myList;
    update();

    final File file = await _localFile;
    await file.writeAsString(jsonEncode(_myLists));
  }

  Future<void> delete(MyList myList) async {
    await _ensureReadingFutureIsDone();

    final File file = await _localFile;

    _myLists.remove(myList);
    update();

    final myListMap = _myLists.map((e) => e.toJson()).toList();
    await file.writeAsString(jsonEncode(myListMap));
  }

  @visibleForTesting
  void clear() {
    _myLists.clear();
  }
}
