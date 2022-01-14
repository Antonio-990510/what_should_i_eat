import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/constants.dart';
import 'package:what_should_i_eat/model/my_list/my_list_item.dart';
import 'package:what_should_i_eat/widgets/asset_or_file_image.dart';
import 'package:what_should_i_eat/widgets/image_picker_bottom_sheet.dart';
import 'package:what_should_i_eat/widgets/recheck_dialog.dart';

typedef MyListItemSubmitCallback = void Function(MyListItem item);

class MyListItemEditBottomSheet extends StatefulWidget {
  /// [item]을 수정하는 바텀 시트를 만든다.
  ///
  /// 페이지를 벗어나면 편집된 새로운 [MyListItem]가 `result`로 반환되며 [item]은 수정되지 않는다.
  const MyListItemEditBottomSheet({
    Key? key,
    required this.item,
  })  : onSubmitted = null,
        super(key: key);

  /// [MyListItem]을 계속해서 새로 생성하는 바텀 시트를 만든다.
  ///
  /// 새로 생성이 될때마다 [onSubmitted]이 호출된다. 절대 [onSubmitted]이 `null`이어서는 안된다.
  MyListItemEditBottomSheet.createMode({
    Key? key,
    required this.onSubmitted,
  })  : item = MyListItem(imagePath: kSampleFoodImagePaths.first, name: ''),
        assert(onSubmitted != null),
        super(key: key);

  final MyListItemSubmitCallback? onSubmitted;
  final MyListItem item;

  @override
  State<MyListItemEditBottomSheet> createState() =>
      _MyListItemEditBottomSheetState();
}

class _MyListItemEditBottomSheetState extends State<MyListItemEditBottomSheet> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _newImagePath = '';

  bool get _isItemUpdated =>
      widget.item.name != _controller.text ||
      widget.item.imagePath != _newImagePath;

  bool get _isCreateMode => widget.onSubmitted != null;

  @override
  void initState() {
    super.initState();
    _newImagePath = widget.item.imagePath;
    _controller.text = widget.item.name;
    _controller.addListener(() {
      setState(() {});
    });
  }

  void _onTapImage() async {
    final result =
        await Get.bottomSheet<String?>(const ImagePickerBottomSheet());
    if (result != null) {
      setState(() {
        _newImagePath = result;
      });
    }
  }

  Future<bool> _onWillPop() async {
    // 항목이 수정되지 않으면 다이어로그를 띄우지 않는다.
    if (!_isItemUpdated) {
      return true;
    }
    // unfocus 하지 않으면 확인을 눌렀을 때 키보드가 나타났다 바로 사라지는 현상이 발생한다.
    _focusNode.unfocus();

    final bool? willPop = await Get.dialog(RecheckDialog(
      title: _isCreateMode ? '작성하던 내용은 삭제됩니다.' : '항목 수정을 그만둘까요?',
      okLabel: _isCreateMode ? '확인' : '네',
    ));
    if (willPop == null || !willPop) {
      _focusNode.requestFocus();
    }
    return willPop ?? false;
  }

  void _handleSubmit() {
    if (_controller.text.isEmpty) {
      _focusNode.requestFocus();
      return;
    }

    final result = MyListItem(name: _controller.text, imagePath: _newImagePath);
    if (_isCreateMode) {
      widget.onSubmitted!.call(result);
      _controller.clear();
      _focusNode.requestFocus();
    } else {
      Get.back(result: result);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTextEmpty = _controller.text.isEmpty;
    final enableSubmitButton = !isTextEmpty;
    final onPrimaryColor = context.theme.colorScheme.onPrimary;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 8.0, 12.0, 8.0),
        child: Row(
          children: [
            InkWell(
              onTap: _onTapImage,
              child: AssetOrFileImage(
                path: _newImagePath,
                radius: 8.0,
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: TextField(
                focusNode: _focusNode,
                controller: _controller,
                autofocus: true,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                    kLengthLimitingOfMyListTitle,
                  ),
                ],
                decoration: const InputDecoration(
                  hintText: '이름 입력',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _handleSubmit(),
                style: context.textTheme.subtitle1!.copyWith(
                  color: onPrimaryColor,
                ),
              ),
            ),
            if (enableSubmitButton) const SizedBox(width: 12.0),
            if (enableSubmitButton)
              IconButton(
                onPressed: _handleSubmit,
                icon: Icon(
                  _isCreateMode
                      ? Icons.add_circle_outline_rounded
                      : Icons.check_circle_outline_rounded,
                  color: context.theme.colorScheme.background,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
