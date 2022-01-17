import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/model/my_list/my_list.dart';
import 'package:what_should_i_eat/pages/my_list/my_list_create_page.dart';
import 'package:what_should_i_eat/pages/my_list/my_list_edit_page.dart';
import 'package:what_should_i_eat/providers/my_list_provider.dart';
import 'package:what_should_i_eat/widgets/default_bottom_sheet.dart';
import 'package:what_should_i_eat/widgets/recheck_dialog.dart';

class MyListBottomSheet extends StatefulWidget {
  const MyListBottomSheet({
    Key? key,
    this.scrollToLast = false,
  }) : super(key: key);

  final bool scrollToLast;

  @override
  State<MyListBottomSheet> createState() => _MyListBottomSheetState();
}

class _MyListBottomSheetState extends State<MyListBottomSheet> {
  final GlobalKey<AnimatedListState> _animatedListKey =
      GlobalKey<AnimatedListState>();
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    final myListProvider = Get.find<MyListProvider>();
    myListProvider.animatedListKey = _animatedListKey;
    if (widget.scrollToLast) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: kThemeChangeDuration,
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<bool> _handlePop() async {
    final provider = Get.find<MyListProvider>();
    if (provider.isBottomSheetEditMode) {
      provider.isBottomSheetEditMode = false;
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handlePop,
      child: GetBuilder<MyListProvider>(
        builder: (provider) {
          final myLists = provider.myLists;

          return DefaultBottomSheet(
            titleSpacing: provider.isBottomSheetEditMode ? 8.0 : 24.0,
            title: _Title(provider: provider),
            actions: provider.isBottomSheetEditMode
                ? null
                : _getDefaultModeActions(provider),
            body: SizedBox(
              height: 114.0,
              child: myLists.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        '오른쪽 상단의 생성 버튼을 눌러 나의 리스트를 만들어보세요.',
                        style: context.textTheme.subtitle1!.copyWith(
                          color:
                              context.theme.colorScheme.onSurface.withOpacity(
                            0.36,
                          ),
                          height: 1.4,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    )
                  : AnimatedList(
                      key: _animatedListKey,
                      controller: controller,
                      padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
                      initialItemCount: myLists.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (_, index, animation) => FadeOutTransition(
                        animation: animation,
                        child: Padding(
                          padding: myLists.length - 1 == index
                              ? EdgeInsets.zero
                              : const EdgeInsets.only(right: 8.0),
                          child: MyListCard(
                            myList: myLists[index],
                            isEditMode: provider.isBottomSheetEditMode,
                          ),
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _getDefaultModeActions(MyListProvider provider) {
    return [
      if (provider.myLists.isNotEmpty)
        IconButton(
          onPressed: () {
            provider.isBottomSheetEditMode = true;
          },
          icon: const Icon(
            Icons.edit_rounded,
            color: Colors.black54,
          ),
        ),
      IconButton(
        onPressed: () {
          Get.to(() => const MyListCreatePage());
        },
        icon: const Icon(
          Icons.add_rounded,
          color: Colors.black54,
        ),
      )
    ];
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key, required this.provider}) : super(key: key);

  final MyListProvider provider;

  @override
  Widget build(BuildContext context) {
    final title = provider.isBottomSheetEditMode
        ? '나의 리스트 편집'
        : provider.myLists.isEmpty
            ? '리스트가 비어있어요'
            : '리스트를 선택하세요';
    Widget result = Text(
      title,
      style: context.textTheme.headline5!.copyWith(
        color: Colors.black,
      ),
      textAlign: TextAlign.left,
      textScaleFactor: 1.0,
    );
    if (provider.isBottomSheetEditMode) {
      result = Row(
        children: [
          IconButton(
            onPressed: () {
              provider.isBottomSheetEditMode = false;
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 16.0),
          result,
        ],
      );
    }
    return result;
  }
}

class MyListCard extends StatefulWidget {
  const MyListCard({
    Key? key,
    required this.myList,
    required this.isEditMode,
  }) : super(key: key);

  final bool isEditMode;
  final MyList myList;

  @override
  State<MyListCard> createState() => _MyListCardState();
}

class _MyListCardState extends State<MyListCard> {
  void _handleRemoveButton() async {
    final bool? result = await Get.dialog(RecheckDialog(
      title: '${widget.myList.title}을(를) 삭제할까요?',
      okLabel: '삭제',
    ));
    if (result != null && result) {
      await Get.find<MyListProvider>().deleteItem(widget.myList);
    }
  }

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(16.0));
    return Stack(
      children: [
        AnimatedPadding(
          duration: kThemeChangeDuration,
          curve: Curves.easeOut,
          padding: widget.isEditMode
              ? const EdgeInsets.only(right: 20.0, top: 20.0)
              : const EdgeInsets.only(top: 20.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: borderRadius,
              onLongPress: widget.isEditMode
                  ? null
                  : () => Get.to(() => MyListEditPage(myList: widget.myList)),
              onTap: widget.isEditMode ? null : () {},
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: context.theme.colorScheme.background.withOpacity(0.4),
                ),
                child: Text(
                  widget.myList.title,
                  style: context.textTheme.subtitle1!
                      .copyWith(color: Colors.black),
                  textScaleFactor: 1.0,
                ),
              ),
            ),
          ),
        ),
        if (widget.isEditMode)
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: _handleRemoveButton,
              icon: const Icon(
                Icons.remove_circle,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }
}

class FadeOutTransition extends StatelessWidget {
  const FadeOutTransition({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key);

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tween = Tween(begin: 0.0, end: 1.0);

    return FadeTransition(
      opacity: tween.animate(CurvedAnimation(
        parent: animation,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      )),
      child: SizeTransition(
        axis: Axis.horizontal,
        sizeFactor: tween.animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
        )),
        child: child,
      ),
    );
  }
}
