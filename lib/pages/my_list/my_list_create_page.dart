import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/constants.dart';
import 'package:what_should_i_eat/model/my_list/my_list.dart';
import 'package:what_should_i_eat/model/my_list/my_list_item.dart';
import 'package:what_should_i_eat/pages/home_page.dart';
import 'package:what_should_i_eat/providers/my_list_provider.dart';
import 'package:what_should_i_eat/utils/text_field_utils.dart';
import 'package:what_should_i_eat/widgets/bar_button.dart';
import 'package:what_should_i_eat/widgets/default_scaffold.dart';
import 'package:what_should_i_eat/widgets/my_list/my_list_bottom_sheet.dart';
import 'package:what_should_i_eat/widgets/my_list/my_list_item_edit_field.dart';
import 'package:what_should_i_eat/widgets/my_list/my_list_item_tile.dart';

class MyListCreatePage extends StatefulWidget {
  const MyListCreatePage({Key? key}) : super(key: key);

  @override
  State<MyListCreatePage> createState() => _MyListCreatePageState();
}

class _MyListCreatePageState extends State<MyListCreatePage> {
  final _focusNode = FocusNode();
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
    _focusNode.dispose();
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

    return GestureDetector(
      onTap: _focusNode.unfocus,
      child: DefaultScaffold(
        backgroundColor: context.theme.colorScheme.primary,
        backButtonColor: context.theme.colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        appBarBottomSpace: 0.0,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
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
                focusNode: _focusNode,
                autofocus: true,
                controller: _controller,
                inputFormatters: defaultInputFormatters,
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
            _MyAnimatedCrossFade(
              firstChild: const SizedBox(height: 52.0, width: double.infinity),
              secondChild: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SecondaryBarButton(
                  onPressed: disableButton ? () {} : _onPressedNext,
                  label: '다음',
                ),
              ),
              crossFadeState: disableButton
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            ),
          ],
        ),
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

  @override
  void initState() {
    super.initState();
    final provider = Get.find<CreateProvider>();
    _textController.text = provider.textControllerText;
    _textController.addListener(() {
      provider.textControllerText = _textController.text;
    });
  }


  void _addItemToList(MyListItem listItem) {
    final provider = Get.find<CreateProvider>();
    provider.add(listItem);
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

    await Get.find<MyListProvider>().writeItem(result);

    Get.offUntil(GetPageRoute(page: () => const HomePage()), (route) => false);
    Get.bottomSheet(const MyListBottomSheet(scrollToLast: true));
  }

  @override
  void dispose() {
    scrollController.dispose();
    _textController.dispose();
    _focusNode.dispose();
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
                  padding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
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
                      onTap: _focusNode.unfocus,
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
            GetBuilder(builder: (CreateProvider provider) {
              return Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: context.theme.colorScheme.primary,
                      blurRadius: 4.0,
                      spreadRadius: 4.0,
                      offset: const Offset(0.0, -2.0),
                    ),
                  ],
                ),
                child: _MyAnimatedCrossFade(
                  crossFadeState: provider.list.isEmpty
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild:
                      const SizedBox(height: 20, width: double.infinity),
                  secondChild: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                    child: SecondaryBarButton(
                      onPressed: provider.list.isEmpty ? () {} : _saveList,
                      label: '저장',
                    ),
                  ),
                ),
              );
            }),
            Container(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12.0,
                    spreadRadius: 2.0,
                    offset: Offset(0.0, -2.0),
                  ),
                ],
                color: context.theme.colorScheme.primary,
              ),
              child: GetBuilder<CreateProvider>(
                builder: (provider) {
                  return MyListItemEditField.createMode(
                    focusNode: _focusNode,
                    onSubmitted: _addItemToList,
                    controller: _textController,
                    onChangedImage: (newPath) {
                      provider.selectedImagePath = newPath;
                    },
                    initImagePath: provider.selectedImagePath,
                    enableRecheckingWhenPop: false,
                  );
                }
              ),
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
    update();
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

class _MyAnimatedCrossFade extends AnimatedCrossFade {
  const _MyAnimatedCrossFade({
    Key? key,
    required Widget firstChild,
    required Widget secondChild,
    required CrossFadeState crossFadeState,
  }) : super(
          key: key,
          firstChild: firstChild,
          secondChild: secondChild,
          duration: kThemeChangeDuration,
          secondCurve: Curves.easeOut,
          sizeCurve: Curves.easeOut,
          firstCurve: Curves.easeOut,
          crossFadeState: crossFadeState,
        );
}
