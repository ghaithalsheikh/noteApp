import 'package:flutter/material.dart';

ThemeData brightnessMode = ThemeData(
    brightness: Brightness.light,
    cardColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.black),
    textSelectionTheme: const TextSelectionThemeData(
      selectionHandleColor: Colors.transparent,
    ),
    searchViewTheme: SearchViewThemeData(backgroundColor: Colors.grey[800]),
    scaffoldBackgroundColor: Colors.grey[200],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[200],
    ),
    dividerColor: Colors.grey);
ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    cardColor: Colors.grey[900],
    iconTheme: const IconThemeData(color: Colors.white),
    textSelectionTheme: const TextSelectionThemeData(
      selectionHandleColor: Colors.transparent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.black,
    searchViewTheme: SearchViewThemeData(backgroundColor: Colors.grey[800]),
    dividerColor: Colors.grey[600]);
