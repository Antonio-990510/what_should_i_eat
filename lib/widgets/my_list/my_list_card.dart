import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/model/my_list/my_list.dart';
import 'package:what_should_i_eat/pages/my_list/my_list_edit_page.dart';

class MyListCard extends StatelessWidget {
  const MyListCard({Key? key, required this.myList}) : super(key: key);

  final MyList myList;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(16.0));
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius,
        onLongPress: () {
          Get.to(() => MyListEditPage(myList: myList));
        },
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: context.theme.colorScheme.background.withOpacity(0.4),
          ),
          child: Text(
            myList.title,
            style: context.textTheme.subtitle1!.copyWith(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
