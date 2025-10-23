import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(
    0xFF120E43,
  ); //Color.fromARGB(255, 6, 33, 109);
  static const Color secondary = Color.fromARGB(255, 170, 206, 236);

  //----------------------------- lightTheme -----------------------------

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(
      fontFamily: 'PTSansNarrow-Regular',
      bodyColor: Colors.black,
    ),
    primaryTextTheme: ThemeData.light().textTheme.apply(
      fontFamily: 'PTSansNarrow-Regular',
      bodyColor: Colors.black,
    ),

    //Color primario
    primaryColor: primary,

    //AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    //TextButtonTheme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primary),
    ),

    //FloatingActionButton
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    //ElevatedButtons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 0,
        //minimumSize: Size(170, 50),
      ),
    ),

    //InputDecoration
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.all(0),
      fillColor: Colors.white,
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: AppTheme.primary, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.grey, width: 1),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.grey, width: 1),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      labelStyle: TextStyle(color: AppTheme.primary),
    ),
  );
}
