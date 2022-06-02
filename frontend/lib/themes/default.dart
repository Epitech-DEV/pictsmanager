// ignore_for_file: unused_element

import 'package:flutter/material.dart';


final elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ButtonStyle(
    shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
      (states) => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    ),
    padding: MaterialStateProperty.resolveWith((states) => const EdgeInsets.all(20.0))
  ),
);

const kInputDecorationTheme = InputDecorationTheme(border: OutlineInputBorder());
