import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:what_should_i_eat/pages/login_page.dart';
import 'package:what_should_i_eat/styles/color.dart';
import 'package:what_should_i_eat/styles/font.dart';

import 'pages/loading.dart';

void main() {
  runApp(const MyApp());
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
        iconTheme: iconTheme,
        textTheme: nanumGothicTextTheme,
        scaffoldBackgroundColor: lightColorScheme.background,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        iconTheme: iconTheme,
        textTheme: nanumGothicTextTheme,
        scaffoldBackgroundColor: darkColorScheme.background,
      ),
      //TODO: LoginPage로 바꾸기
      home: const Loading(),
    );
  }
}
