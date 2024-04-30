import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'Screens/home_screen.dart';
import 'Themes/themes.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: lightTheme.colorScheme.background, // Couleur de fond de la barre de navigation
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme, //ThemeData.light()
      darkTheme: darkTheme, //ThemeData.dark()
      themeMode: ThemeMode.light, //theme par defaut
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

// theme: ThemeData(
// colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// useMaterial3: true,
// ),
