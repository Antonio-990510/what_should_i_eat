import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:what_should_i_eat/pages/login_page.dart';
import 'package:what_should_i_eat/styles/color.dart';
import 'package:what_should_i_eat/styles/font.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = ThemeData(textTheme: nanumGothicTextTheme);

    return GetMaterialApp(
      title: '뭐 먹을까?',
      themeMode: ThemeMode.system,
      theme: themeData.copyWith(
        colorScheme: lightColorScheme,
      ),
      darkTheme: themeData.copyWith(
        colorScheme: darkColorScheme,
      ),
      home: Builder(
        builder: (context) => Theme(
          data: context.theme.copyWith(
            scaffoldBackgroundColor: context.theme.colorScheme.background,
            textTheme: context.theme.textTheme.apply(
              displayColor: context.theme.colorScheme.onBackground,
              bodyColor: context.theme.colorScheme.onBackground,
            ),
          ),
          child: const LoginPage(),
        ),
      ),
    );
  }
}
