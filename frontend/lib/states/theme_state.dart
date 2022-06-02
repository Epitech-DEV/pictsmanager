
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/themes/default.dart';

class ThemeState extends ChangeNotifier with Diagnosticable {
  ThemeState({ bool useDarkTheme = false }) {
    _isDark = useDarkTheme;
  }
  
  bool _isDark = true;

  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  static ThemeData get lightTheme => ThemeData.light().copyWith(
    inputDecorationTheme: kInputDecorationTheme,
    elevatedButtonTheme: elevatedButtonThemeData
  );

  static ThemeData get darkTheme => ThemeData.dark().copyWith(
    inputDecorationTheme: kInputDecorationTheme,
    elevatedButtonTheme: elevatedButtonThemeData
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('isDark', value: _isDark, ifTrue: 'Dark', ifFalse: 'Light'));
  }
}