import 'package:flutter/material.dart';

ColorScheme get lightColorScheme => const ColorScheme.light(
      primary: Color(0xFFFFCDD2),
      primaryVariant: Color(0xFFcb9ca1),
      secondary: Color(0xFFA5D6A7),
      secondaryVariant: Color(0xff75a478),
      surface: Color(0xe6ffffff),
      background: Colors.white,
      error: Color(0xffb00020),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    );

ColorScheme get darkColorScheme => const ColorScheme.dark(
      primary: Color(0xFFFFCDD2),
      primaryVariant: Color(0xFFcb9ca1),
      secondary: Color(0xFFA5D6A7),
      secondaryVariant: Color(0xff75a478),
      surface: Color(0xe6121212),
      background: Color(0xff121212),
      error: Color(0xffcf6679),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.black,
      brightness: Brightness.dark,
    );
