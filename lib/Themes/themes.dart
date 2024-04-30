import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  //scaffoldBackgroundColor: Colors.yellow,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade200,
    primary: Colors.grey.shade200,
    secondary: Colors.grey.shade400,
  ),

);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  //scaffoldBackgroundColor: Colors.pink,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    primary: Colors.grey.shade900,
    secondary: Colors.grey.shade700,
  ),

);