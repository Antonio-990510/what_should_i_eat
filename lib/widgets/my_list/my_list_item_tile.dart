import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/model/my_list/my_list_item.dart';
import 'package:what_should_i_eat/widgets/adaptive_image.dart';
import 'package:what_should_i_eat/widgets/my_list/my_list_item_edit_field.dart';

typedef MyListItemUpdateCallback = void Function(
    MyListItem oldItem, MyListItem newItem);

class MyListItemTile extends StatelessWidget {
  const MyListItemTile({
    Key? key,
    this.onTap,
    required this.onUpdate,
    required this.item,
    required this.onDismissed,
  }) : super(key: key);

  final VoidCallback? onTap;
  final MyListItemUpdateCallback onUpdate;
  final MyListItem item;
  final DismissDirectionCallback onDismissed;

  void _onTap() async {
    onTap?.call();
    final newItem = await Get.bottomSheet<MyListItem?>(
      MyListItemEditField(item: item),
      enableDrag: false,
    );
    if (newItem != null) {
      onUpdate.call(item, newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      child: Dismissible(
        key: ObjectKey(item),
        onDismissed: onDismissed,
        background: Container(color: Colors.red),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
          child: Row(
            children: [
              AdaptiveImage(
                path: item.imagePath,
                radius: 8,
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 12.0),
              Text(
                item.name,
                style: context.textTheme.bodyText2!.copyWith(
                  color: context.theme.colorScheme.onPrimary.withOpacity(0.65),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}