import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/constants.dart';
import 'package:what_should_i_eat/model/my_list/my_list.dart';
import 'package:what_should_i_eat/model/my_list/my_list_item.dart';
import 'package:what_should_i_eat/pages/home_page.dart';
import 'package:what_should_i_eat/providers/my_list_provider.dart';
import 'package:what_should_i_eat/widgets/bar_button.dart';
import 'package:what_should_i_eat/widgets/default_scaffold.dart';
import 'package:what_should_i_eat/widgets/image_picker_bottom_sheet.dart';
import 'package:what_should_i_eat/widgets/my_list/my_list_bottom_sheet.dart';
import 'package:what_should_i_eat/widgets/my_list/my_list_item_tile.dart';
import 'package:what_should_i_eat/widgets/asset_or_file_image.dart';

class MyListCreatePage extends StatefulWidget {
  const MyListCreatePage({Key? key}) : super(key: key);

  @override
  State<MyListCreatePage> createState() => _MyListCreatePageState();
}

class _MyListCreatePageState extends State<MyListCreatePage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final createProvider = Get.put(CreateProvider());

    _controller.addListener(() {
      setState(() {
        createProvider.title = _controller.text;
      });
    });
  }

  void _onPressedNext() async {
    Get.to(
      () => const MyListCreateDetailPage(),
      transition: Transition.rightToLeft,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = UnderlineInputBorder(
      borderSide: BorderSide(
        color: context.theme.colorScheme.background,
        width: 2,
      ),
    );

    final disableButton = _controller.text.isEmpty;

    return DefaultScaffold(
      backgroundColor: context.theme.colorScheme.primary,
      backButtonColor: context.theme.colorScheme.onPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      appBarBottomSpace: 0.0,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: AutoSizeText(
              '생성할 리스트의 제목을 입력하세요',
              maxLines: 2,
              style: context.textTheme.headline5!.copyWith(
                color: context.theme.colorScheme.onPrimary,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            flex: 1,
            child: TextField(
              autofocus: true,
              controller: _controller,
              inputFormatters: [
                LengthLimitingTextInputFormatter(
                  kLengthLimitingOfMyListTitle,
                ),
              ],
              style: context.textTheme.headline6!.copyWith(
                color: context.theme.colorScheme.onPrimary,
              ),
              decoration: InputDecoration(
                hintText: '제목 입력',
                enabledBorder: inputBorder,
                focusedBorder: inputBorder,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SecondaryBarButton(
            onPressed: disableButton ? null : _onPressedNext,
            label: '다음',
          ),
        ],
      ),
    );
  }
}

@visibleForTesting
class MyListCreateDetailPage extends StatefulWidget {
  const MyListCreateDetailPage({Key? key}) : super(key: key);

  @override
  State<MyListCreateDetailPage> createState() => MyListCreateDetailPageState();
}

@visibleForTesting
class MyListCreateDetailPageState extends State<MyListCreateDetailPage> {
  final GlobalKey _lastItemKey = GlobalKey();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @visibleForTesting
  final ScrollController scrollController = ScrollController();

  bool _enableAddButton = false;

  @override
  void initState() {
    super.initState();
    final provider = Get.find<CreateProvider>();
    _textController.text = provider.textControllerText;
    _textController.addListener(() {
      setState(() {
        _enableAddButton = _textController.text.isNotEmpty;
      });
      provider.textControllerText = _textController.text;
    });
  }

  void _showImagePicker() async {
    final result = await Get.bottomSheet(const ImagePickerBottomSheet());
    if (result != null) {
      Get.find<CreateProvider>().selectedImagePath = result;
    }
  }

  void _addItemToList() {
    if (_textController.text.isEmpty) {
      _focusNode.requestFocus();
      return;
    }
    final provider = Get.find<CreateProvider>();
    provider.add(MyListItem(
      name: _textController.text,
      imagePath: provider.selectedImagePath,
    ));
    _textController.clear();
    _focusNode.requestFocus();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: kThemeAnimationDuration,
        curve: Curves.easeOut,
      );
      // https://stackoverflow.com/a/57645944/14434806로 스크롤을 끝까지
      // 하지 못하는 버그를 해결하고 있다.
      if (_lastItemKey.currentContext != null) {
        Scrollable.ensureVisible(_lastItemKey.currentContext!);
      }
    });
  }

  void _removeItem(MyListItem item) {
    Get.find<CreateProvider>().remove(item);
  }

  void _saveList() async {
    final createProvider = Get.find<CreateProvider>();
    final result =
        MyList(title: createProvider.title, items: createProvider.list);

    await Get.find<MyListProvider>().create(result);

    Get.offUntil(GetPageRoute(page: () => const HomePage()), (route) => false);
    Get.bottomSheet(const MyListBottomSheet(scrollToLast: true));
  }

  @override
  void dispose() {
    _textController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _focusNode.unfocus,
      child: DefaultScaffold(
        backgroundColor: context.theme.colorScheme.primary,
        backButtonColor: context.theme.colorScheme.onPrimary,
        padding: EdgeInsets.zero,
        appBarBottomSpace: 0.0,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GetBuilder<CreateProvider>(builder: (provider) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  controller: scrollController,
                  itemCount: provider.list.length + 1,
                  itemBuilder: (_, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 24.0,
                          right: 24.0,
                          bottom: 16.0,
                        ),
                        child: Text(
                          '${provider.title}의 항목들을 생성하세요',
                          style: context.textTheme.headline5!.copyWith(
                            color: context.theme.colorScheme.onPrimary,
                            height: 1.4,
                          ),
                        ),
                      );
                    }
                    final item = provider.list[index - 1];

                    return MyListItemTile(
                      key: index == provider.list.length ? _lastItemKey : null,
                      onDismissed: (_) => _removeItem(item),
                      onUpdate: (oldItem, newItem) {
                        setState(() {
                          provider.replace(oldItem, newItem);
                        });
                      },
                      item: item,
                    );
                  },
                );
              }),
            ),
            GestureDetector(
              onTap: _focusNode.requestFocus,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: context.theme.colorScheme.primary,
                      blurRadius: 16.0,
                      spreadRadius: 16.0,
                      offset: const Offset(0.0, -8.0),
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _textController.text.isEmpty
                          ? context.isDarkMode
                              ? Colors.white38
                              : Colors.black38
                          : context.theme.colorScheme.background,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: _showImagePicker,
                        child: GetBuilder<CreateProvider>(
                          builder: (provider) => AssetOrFileImage(
                            radius: 14.0,
                            height: 48.0,
                            width: 48.0,
                            path: provider.selectedImagePath,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: TextField(
                          autofocus: true,
                          focusNode: _focusNode,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                              kLengthLimitingOfMyListTitle,
                            ),
                          ],
                          controller: _textController,
                          style: context.textTheme.subtitle1!.copyWith(
                              color: context.theme.colorScheme.onPrimary),
                          onSubmitted: (_) => _addItemToList(),
                          decoration: const InputDecoration(
                            hintText: '추가할 항목의 이름 입력',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _enableAddButton ? _addItemToList : null,
                        icon: Icon(
                          Icons.add_box_rounded,
                          size: 28,
                          color: _enableAddButton
                              ? context.theme.colorScheme.background
                              : context.isDarkMode
                                  ? Colors.white38
                                  : Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: GetBuilder(builder: (CreateProvider provider) {
                return SecondaryBarButton(
                  onPressed: provider.list.isEmpty ? null : _saveList,
                  label: '저장',
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

@visibleForTesting
class CreateProvider extends GetxController {
  /// 생성할 [MyList.title] 값이다.
  String get title => _title;
  String _title = '';

  set title(String s) {
    _title = s;
    update();
  }

  /// 이전 화면으로 이동해도 입력하던 텍스트를 유지하기 위해 저장하는 변수이다.
  String textControllerText = '';

  String _selectedImagePath = kSampleFoodImagePaths.first;

  /// 추가할 항목에 저장된 이미지의 경로이다.
  String get selectedImagePath => _selectedImagePath;

  set selectedImagePath(String path) {
    _selectedImagePath = path;
    update();
  }

  final List<MyListItem> _list = [];

  List<MyListItem> get list => List.unmodifiable(_list);

  void add(MyListItem item) {
    _list.add(item);
  }

  void remove(MyListItem item) {
    _list.remove(item);
    update();
  }

  void replace(MyListItem oldItem, MyListItem newItem) {
    final index = _list.indexOf(oldItem);
    if (index == -1) return;
    _list[index] = newItem;
  }
}
