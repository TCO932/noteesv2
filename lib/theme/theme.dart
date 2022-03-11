import 'package:flutter/material.dart';

final appTheme = ThemeData(
  // *** TEXT ***
  textTheme: const TextTheme(
      headline1: TextStyle(fontWeight: FontWeight.w300, fontSize: 26),
      headline2: TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
      bodyText1: TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
      bodyText2: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 14,
      )),

  // *** COLORS ***
  primarySwatch: Colors.blue,
  primaryColorLight: Colors.blue[50],
  primaryIconTheme: const IconThemeData(color: Colors.black45),
);
