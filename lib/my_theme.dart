import 'package:flutter/material.dart';

class MyTheme {
  static const Color primaryColor = Color(0xff5D9CEC);
  static const Color whiteColor = Color(0xffffffff);
  static const Color blackColor = Color(0xff383838);
  static const Color blackColorDark = Color(0xff141922);
  static const Color redColor = Color(0xffEC4B4B);
  static const greenColor = Color(0xff61E757);
  static const greyColor = Color(0xff707070);
  static const bgLight = Color(0xffDFECDB);
  static const bgDark = Color(0xff060E1E);

  static ThemeData lightMode = ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: bgLight,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: whiteColor,
          fontWeight: FontWeight.bold,
          fontSize: 22.0,
        ),
      ),
      textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          titleSmall: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          )),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: primaryColor,
          unselectedItemColor: Color(0xffC8C9CB),
          unselectedIconTheme: IconThemeData(
            color: Color(0xffC8C9CB),
            size: 20,
          ),
          selectedIconTheme: IconThemeData(color: primaryColor, size: 22)),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(width: 5, color: whiteColor))));
  static ThemeData darkMode = ThemeData(
      scaffoldBackgroundColor: bgDark,
      appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          titleTextStyle: TextStyle(
            color: bgDark,
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
          ),
          elevation: 0),
      textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          titleSmall: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          )),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: blackColorDark,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          selectedItemColor: primaryColor,
          unselectedItemColor: Color(0xffC8C9CB),
          unselectedIconTheme: IconThemeData(
            color: Color(0xffC8C9CB),
            size: 20,
          ),
          selectedIconTheme: IconThemeData(color: primaryColor, size: 22)));
}
