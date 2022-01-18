import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:what_should_i_eat/model/my_list/my_list.dart';
import 'package:what_should_i_eat/pages/loading_page.dart';
import 'package:what_should_i_eat/pages/my_list/my_list_create_page.dart';
import 'package:what_should_i_eat/pages/my_list/my_list_edit_page.dart';
import 'package:what_should_i_eat/pages/search_result_page.dart';
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
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
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
                          color: context.theme.colorScheme.onSurface
                              .withOpacity(0.36),
                          height: 1.4,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    )
                  : ImplicitlyAnimatedReorderableList<MyList>(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      controller: controller,
                      scrollDirection: Axis.horizontal,
                      items: myLists,
                      areItemsTheSame: (a, b) => a.id == b.id,
                      onReorderFinished: (_, from, to, __) {
                        Get.find<MyListProvider>().reorder(from, to);
                      },
                      itemBuilder: (_, listAnimation, myList, __) {
                        return Reorderable(
                          key: ValueKey(myList.id),
                          builder: (_, dragAnimation, __) {
                            return _CardWrapper(
                              listAnimation: listAnimation,
                              child: _MyListCard(
                                myList: myList,
                                dragAnimation: dragAnimation,
                                isEditMode: provider.isBottomSheetEditMode,
                              ),
                            );
                          },
                        );
                      },
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

class _CardWrapper extends StatelessWidget {
  const _CardWrapper({
    Key? key,
    required this.listAnimation,
    required this.child,
  }) : super(key: key);

  final Animation<double> listAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeOutTransition(
      animation: listAnimation,
      child: Handle(
        capturePointer: false,
        delay: kLongPressTimeout,
        child: child,
      ),
    );
  }
}

class _MyListCard extends StatefulWidget {
  const _MyListCard({
    Key? key,
    required this.myList,
    required this.isEditMode,
    required this.dragAnimation,
  }) : super(key: key);

  final bool isEditMode;
  final MyList myList;
  final Animation<double> dragAnimation;

  @override
  State<_MyListCard> createState() => _MyListCardState();
}

class _MyListCardState extends State<_MyListCard> {
  void _handleRemoveButton() async {
    final bool? result = await Get.dialog(RecheckDialog(
      title: '${widget.myList.title}을(를) 삭제할까요?',
      okLabel: '삭제',
    ));
    if (result != null && result) {
      await Get.find<MyListProvider>().deleteItem(widget.myList);
    }
  }

  void _handleTap() async {
    // 먼저 bottom sheet 를 없앤다.
    Get.back();
    Get.to(() => const LoadingPage());
    await Future.delayed(const Duration(seconds: 2));

    final list = widget.myList.toRestaurantList();
    Get.off(
      () => SearchResultPage(
        restaurantModel: list[Random().nextInt(list.length)],
        retryLabel: '이 항목 제외하고 다시 찾기',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(16.0));
    final cardColor = HSLColor.fromColor(context.theme.colorScheme.background)
        .withLightness(0.85)
        .toColor();

    return Stack(
      children: [
        AnimatedPadding(
          duration: kThemeChangeDuration,
          curve: Curves.easeOut,
          padding: widget.isEditMode
              ? const EdgeInsets.only(right: 12.0, top: 20.0)
              : const EdgeInsets.only(top: 20.0),
          child: AnimatedBuilder(
            animation: widget.dragAnimation,
            builder: (BuildContext context, Widget? child) {
              final onSurfaceColor = context.theme.colorScheme.onSurface.withOpacity(0.12);

              return Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: onSurfaceColor,
                      blurRadius: widget.dragAnimation.value * 4.0,
                      spreadRadius: widget.dragAnimation.value * 4.0,
                    ),
                    BoxShadow(
                      color: cardColor,
                      spreadRadius: widget.dragAnimation.value * 2.0,
                    ),
                  ],
                ),
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: child,
              );
            },
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: borderRadius,
                onLongPress: widget.isEditMode
                    ? null
                    : () => Get.to(() => MyListEditPage(myList: widget.myList)),
                onTap: widget.isEditMode ? null : _handleTap,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
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
