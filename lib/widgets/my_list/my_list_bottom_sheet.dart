import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/pages/my_list/my_list_create_page.dart';
import 'package:what_should_i_eat/providers/my_list_provider.dart';
import 'package:what_should_i_eat/widgets/default_bottom_sheet.dart';
import 'package:what_should_i_eat/widgets/my_list/my_list_card.dart';

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

  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheet(
      title: GetBuilder<MyListProvider>(
        builder: (provider) {
          return Text(
            provider.myLists.isEmpty ? '리스트가 비어있어요' : '나의 리스트',
            style: context.textTheme.headline5!.copyWith(
              color: Colors.black,
            ),
          );
        },
      ),
      action: IconButton(
        onPressed: () {
          Get.to(() => const MyListCreatePage());
        },
        icon: const Icon(
          Icons.add_rounded,
          color: Colors.black54,
        ),
      ),
      body: SingleChildScrollView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(24.0),
        child: GetBuilder<MyListProvider>(
          builder: (provider) {
            final myLists = provider.myLists;
            if (myLists.isEmpty) return const SizedBox();
            return Row(
              children: myLists.map((e) {
                int index = myLists.indexOf(e);
                return Padding(
                  padding: myLists.length - 1 == index
                      ? EdgeInsets.zero
                      : const EdgeInsets.only(right: 8.0),
                  child: MyListCard(myList: e),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
