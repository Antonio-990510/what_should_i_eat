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
    return GetMaterialApp(
      title: '뭐 먹을까?',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: lightColorScheme,
        iconTheme: const IconThemeData(color: Colors.black, opacity: 0.8),
        textTheme: nanumGothicLightTextTheme,
        scaffoldBackgroundColor: lightColorScheme.background,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        iconTheme: const IconThemeData(color: Colors.white, opacity: 0.8),
        textTheme: nanumGothicDarkTextTheme,
        scaffoldBackgroundColor: darkColorScheme.background,
      ),
      home: const LoginPage(),
    );
  }
}
