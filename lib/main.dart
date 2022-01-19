import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/providers/my_list_provider.dart';
import 'package:what_should_i_eat/styles/color.dart';
import 'package:what_should_i_eat/styles/font.dart';
import 'pages/search_restaurant_list.dart';

void main() {
  runApp(const MyApp());

  Get.put(MyListProvider());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const iconTheme = IconThemeData(color: Colors.white, opacity: 0.9);

    return GetMaterialApp(
      title: '뭐 먹을까?',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: lightColorScheme,
        bottomSheetTheme: const BottomSheetThemeData(
          modalBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
        ),
        iconTheme: iconTheme,
        textTheme: nanumGothicTextTheme,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: lightColorScheme.background,
          selectionColor: lightColorScheme.background,
          selectionHandleColor: lightColorScheme.background,
        ),
        scaffoldBackgroundColor: lightColorScheme.background,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.black,
        ),
        iconTheme: iconTheme,
        textTheme: nanumGothicTextTheme,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: darkColorScheme.background,
          selectionColor: darkColorScheme.background,
          selectionHandleColor: darkColorScheme.background,
        ),
        scaffoldBackgroundColor: darkColorScheme.background,
      ),
      home: const SearchRestaurantList(),
    );
  }
}
