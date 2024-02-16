import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visivista/style/color_palete.dart';
import 'package:visivista/style/text_style.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode currentTheme = ThemeMode.system;

  ThemeMode get themeMode => currentTheme;

  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? themeIndex = prefs.getInt('theme');
    if (themeIndex != null) {
      currentTheme = ThemeMode.values[themeIndex];
    } else {
      currentTheme = ThemeMode.system;
    }
    notifyListeners();
  }

  void setCurrentTheme(ThemeMode themeMode) {
    currentTheme = themeMode;
    notifyListeners();
    saveTheme(themeMode);
  }

  Future<void> saveTheme(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme', themeMode.index);
  }
}

class ThemeApp {
  static const String textFontFamily = 'BalooChettan2';

  ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    //color
    indicatorColor: const Color.fromRGBO(87, 87, 87, 1),
    cardColor: const Color.fromRGBO(87, 87, 87, 1),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: Color.fromRGBO(52, 52, 52, 1),
    ),
    scaffoldBackgroundColor: const Color.fromRGBO(17, 17, 17, 1),
    colorScheme: const ColorScheme.dark(
      primary: Color.fromRGBO(42, 157, 143, 1),
      onPrimary: Color.fromRGBO(255, 255, 255, 1),
    ),

    //form
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: StyleText.formLabelStyle,
      filled: true,
      fillColor: const Color.fromRGBO(122, 122, 122, 1),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: ColorPalette.black,
          width: 2,
        ),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: ColorPalette.black,
          width: 2,
        ),
      ),
    ),

    //teks
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontSize: 16,
        color: Color.fromRGBO(255, 255, 255, 1),
        fontFamily: textFontFamily,
      ),
      labelSmall: TextStyle(
        fontSize: 16,
        color: Color.fromRGBO(229, 55, 58, 1),
        fontFamily: textFontFamily,
      ),
      titleSmall: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(255, 255, 255, 1),
        fontWeight: FontWeight.bold,
        fontFamily: textFontFamily,
      ),
      bodySmall: TextStyle(
        color: ColorPalette.white,
        fontFamily: textFontFamily,
        fontSize: 16,
      ),
      labelMedium: TextStyle(
        color: ColorPalette.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        fontFamily: textFontFamily,
      ),
      titleMedium: TextStyle(
        color: ColorPalette.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontFamily: textFontFamily,
      ),
    ),
  );

  //light mode
  ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    //color
    cardColor: ColorPalette.secondary,
    bottomAppBarTheme: const BottomAppBarTheme(
      color: ColorPalette.white,
    ),
    scaffoldBackgroundColor: ColorPalette.white,
    colorScheme: const ColorScheme.light(
      primary: Color.fromRGBO(42, 157, 143, 1),
      onPrimary: ColorPalette.primary,
    ),

    //form
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: StyleText.formLabelStyle,
      filled: true,
      fillColor: ColorPalette.white,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: ColorPalette.black,
          width: 2,
        ),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: ColorPalette.black,
          width: 2,
        ),
      ),
    ),

    //teks
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontSize: 16,
        color: ColorPalette.black,
        fontFamily: textFontFamily,
      ),
      labelSmall: TextStyle(
        fontSize: 16,
        color: Color.fromRGBO(229, 55, 58, 1),
        fontFamily: textFontFamily,
      ),
      titleSmall: TextStyle(
        fontSize: 20,
        color: ColorPalette.black,
        fontWeight: FontWeight.bold,
        fontFamily: textFontFamily,
      ),
      bodySmall: TextStyle(
        color: ColorPalette.black,
        fontFamily: textFontFamily,
        fontSize: 16,
      ),
      labelMedium: TextStyle(
        color: ColorPalette.black,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        fontFamily: textFontFamily,
      ),
      titleMedium: TextStyle(
        color: ColorPalette.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontFamily: textFontFamily,
      ),
    ),
  );
}
