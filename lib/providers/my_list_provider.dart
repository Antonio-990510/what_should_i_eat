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

  List<MyList> get myLists => List.unmodifiable(_myLists);
  final List<MyList> _myLists = [];

  bool get isBottomSheetEditMode => _isBottomSheetEditMode;
  bool _isBottomSheetEditMode = false;

  set isBottomSheetEditMode(bool state) {
    _isBottomSheetEditMode = state;
    update();
  }

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

  Future<void> _writeListJsonFile() async {
    final File file = await _localFile;
    await file.writeAsString(jsonEncode(_myLists));
  }

  /// [myList]를 파일에 저장하여 추가한다.
  ///
  // TODO(민성): Firebase와 연동하여 파일을 저장하여야 한다.
  Future<void> writeItem(MyList myList) async {
    await _ensureReadingFutureIsDone();

    _addToLists(myList);
    update();

    _writeListJsonFile();
  }

  /// [myList]와 `id`가 동일한 데이터를 전달된 [myList]로 교체한다.
  Future<void> updateItem(MyList myList) async {
    await _ensureReadingFutureIsDone();

    final index = _myLists.indexWhere((e) => e.id == myList.id);
    if (index == -1) return;

    _myLists[index] = myList;
    update();

    _writeListJsonFile();
  }

  Future<void> deleteItem(MyList myList) async {
    await _ensureReadingFutureIsDone();

    _removeFromLists(myList);
    update();

    _writeListJsonFile();
  }

  Future<void> reorder(int fromIndex, int toIndex) async {
    await _ensureReadingFutureIsDone();

    final myList = _myLists.removeAt(fromIndex);
    _myLists.insert(toIndex, myList);

    _writeListJsonFile();
  }

  void _addToLists(MyList myList) {
    _myLists.add(myList);
  }

  void _removeFromLists(MyList myList) {
    _myLists.remove(myList);
    if (_myLists.isEmpty && _isBottomSheetEditMode) {
      _isBottomSheetEditMode = false;
    }
  }

  @visibleForTesting
  void add(MyList myList) {
    _addToLists(myList);
    update();
  }

  @visibleForTesting
  void remove(MyList myList) {
    _removeFromLists(myList);
    update();
  }
}
