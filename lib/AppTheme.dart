import 'dart:ui';

import 'package:flutter/material.dart';

class MyTheme {
  Brightness brightness;
  MaterialColor primarySwatch;

  MyTheme(
      {this.brightness,
        this.primarySwatch,
      });
}

class AppTheme {
  String name;
  MyTheme theme;
  AppTheme(this.name, this.theme);
}

List<AppTheme> myThemes = [
  AppTheme(
      'Day',
      MyTheme(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      )),
  AppTheme(
    'Teal',
    MyTheme(
      brightness: Brightness.light,
      primarySwatch: Colors.teal,
    ),
  ),
  AppTheme(
    'Orange',
    MyTheme(
      brightness: Brightness.light,
      primarySwatch: Colors.orange,
    ),
  ),
  AppTheme(
    'Dark',
    MyTheme(
      brightness: Brightness.dark,
      primarySwatch: Colors.blueGrey,
    ),
  ),
];