import 'package:flutter/material.dart';

ColorScheme get lightColorScheme => const ColorScheme.light(
      primary: Colors.white,
      primaryVariant: Color(0xFFFFADB0),
      secondary: Color(0xFFFFE600),
      secondaryVariant: Color(0xff82A79F),
      surface: Color(0xe6ffffff),
      background: Color(0xFFF77A52),
      error: Color(0xffb00020),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    );

ColorScheme get darkColorScheme => const ColorScheme.dark(
      primary: Color(0xFF212121),
      primaryVariant: Color(0xFFFFADB0),
      secondary: Color(0xFFFFE600),
      secondaryVariant: Color(0xff82A79F),
      surface: Color(0xe6121212),
      background: Color(0xFFF77A52),
      error: Color(0xffcf6679),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.black,
      brightness: Brightness.dark,
    );
