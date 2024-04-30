import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:weather/Themes/themes.dart';

class ThemeController extends GetxController{
  var isDarkMode = false.obs;
  Rx<ThemeData> themeData = ThemeData.light().obs;

  void changeTheme(){
    isDarkMode.value = !isDarkMode.value;

    //si le isDarkMode == true alors on met le mode sombre sinon le mode light
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

    //ThemeMode currentThemeMode = themeMode.value;
    themeData.value =  isDarkMode.value ? darkTheme : lightTheme;


  }

}