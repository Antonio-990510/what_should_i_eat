import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/model/my_list/my_list.dart';
import 'package:what_should_i_eat/model/my_list/my_list_item.dart';
import 'package:what_should_i_eat/providers/my_list_provider.dart';
import 'package:what_should_i_eat/utils/text_field_utils.dart';
import 'package:what_should_i_eat/widgets/bar_button.dart';
import 'package:what_should_i_eat/widgets/default_scaffold.dart';
import 'package:what_should_i_eat/widgets/my_list/my_list_item_edit_field.dart';
import 'package:what_should_i_eat/widgets/my_list/my_list_item_tile.dart';
import 'package:what_should_i_eat/widgets/recheck_dialog.dart';

class MyListEditPage extends StatefulWidget {
  const MyListEditPage({Key? key, required this.myList}) : super(key: key);

  final MyList myList;

  @override
  State<MyListEditPage> createState() => _MyListEditPageState();
}

class _MyListEditPageState extends State<MyListEditPage> {
  final GlobalKey _lastItemKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  late final List<MyListItem> _newItemList;

  bool get _isListUpdated {
    if (_newItemList.length != widget.myList.items.length) return true;
    for (int i = 0; i < _newItemList.length; ++i) {
      if (_newItemList[i] != widget.myList.items[i]) return true;
    }
    return _titleController.text != widget.myList.title;
  }

  bool get _canSave {
    return _isListUpdated &&
        _newItemList.isNotEmpty &&
        _titleController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _newItemList = List.from(widget.myList.items);
    _titleController.text = widget.myList.title;
  }

  void _handleAddButtonTap() async {
    await Get.bottomSheet(
      MyListItemEditField.createMode(
        onSubmitted: (item) {
          setState(() {
            _newItemList.add(item);
          });
          WidgetsBinding.instance!.addPostFrameCallback((_) async {
            await _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: kThemeChangeDuration,
              curve: Curves.easeOut,
            );
            // https://stackoverflow.com/a/57645944/14434806로 스크롤을 끝까지
            // 하지 못하는 버그를 해결하고 있다.
            if (_lastItemKey.currentContext != null) {
              Scrollable.ensureVisible(_lastItemKey.currentContext!);
            }
          });
        },
      ),
      enableDrag: false,
      barrierColor: Colors.black12,
    );
  }

  void _removeItem(MyListItem item) {
    setState(() {
      _newItemList.remove(item);
    });
  }

  Future<bool> _onWillPop() async {
    if (!_isListUpdated) {
      return true;
    }
    _titleFocusNode.unfocus();
    return (await Get.dialog(const RecheckDialog(
          title: '편집한 내용은 저장되지 않습니다.',
        ))) ??
        false;
  }

  void _handleSaveTap() async {
    final newList = widget.myList.deepCopyWith(
      title: _titleController.text,
      items: _newItemList,
    );
    await Get.find<MyListProvider>().updateItem(newList);
    Get.back();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _titleFocusNode.unfocus,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: DefaultScaffold(
          appBarBottomSpace: 0.0,
          padding: const EdgeInsets.only(top: 12.0),
          backgroundColor: context.theme.colorScheme.primary,
          backButtonColor: context.theme.colorScheme.onPrimary,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _titleController,
                        inputFormatters: defaultInputFormatters,
                        focusNode: _titleFocusNode,
                        style: context.textTheme.headline5!.copyWith(
                          color: context.theme.colorScheme.onPrimary,
                        ),
                        onChanged: (_) {
                          setState(() {});
                        },
                        onEditingComplete: _titleFocusNode.unfocus,
                      ),
                    ),
                    IconButton(
                      onPressed: _handleAddButtonTap,
                      icon: Icon(
                        Icons.add_rounded,
                        color: context.theme.colorScheme.onPrimary.withOpacity(
                          0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  itemCount: _newItemList.length,
                  itemBuilder: (_, index) => MyListItemTile(
                    key: _newItemList.length - 1 == index ? _lastItemKey : null,
                    onUpdate: (oldItem, newItem) {
                      setState(() {
                        final index = _newItemList.indexOf(oldItem);
                        if (index == -1) return;
                        _newItemList[index] = newItem;
                      });
                    },
                    item: _newItemList[index],
                    onDismissed: (_) => _removeItem(_newItemList[index]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
                child: SecondaryBarButton(
                  onPressed: _canSave ? _handleSaveTap : null,
                  label: '저장',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
