import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      theme: themeData.copyWith(
        colorScheme: lightColorScheme,
      ),
      darkTheme: themeData.copyWith(
        colorScheme: darkColorScheme,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('안녕하세요', style: context.textTheme.bodyText1),
      ),
    );
  }
}
