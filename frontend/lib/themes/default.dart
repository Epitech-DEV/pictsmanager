// ignore_for_file: unused_element

import 'package:flutter/material.dart';

const _backgroundColor = Colors.white;

const _primaryColor = Color(0xFF778AF1);
const _accentPrimaryColor = Color(0xFF5464B8);

const _secondaryColor = Color(0xFF696FA7);
const _tertiaryColor = Color(0xFFAFB1C6);
const _quaternaryColor = Color(0xFF393B4D);

const _errorColor = Color(0xFFF17777);
const _succesColor = Color(0xFFA2E085);
const _warningColor = Color(0xFFF8B05D);

const _foregroundColor = Colors.white;
const _headerForegroundColor = _secondaryColor;

const _inputLabelColor = _tertiaryColor;
const _inputBackgroundColor = Color(0xFFF1F2F8);
const _inputTextColor = Colors.black;
const _inputPlaceholderColor = Color(0xFFBAB8C0);

// CLASSIC TEXT STYLES

const h1Style = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: _secondaryColor,
);

const h2Style = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.w600,
  color: _secondaryColor,
);

// TILE TEXT STYLES

const tileTitleTextStyle = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w600,
  color: _quaternaryColor,
);

const tileDetailsTextStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w600,
  color: _secondaryColor,
);

// INPUT TEXT STYLES

const inputLabelStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: _inputLabelColor,
);

const inputTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: _inputTextColor,
);

const inputPlaceholderStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: _inputPlaceholderColor,
);

const inputErrorTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: _errorColor,
);

// TEXT FIELD STYLES

const textFieldThemeData = InputDecorationTheme(border: OutlineInputBorder());

// BUTTON STYLES

final buttonThemeData = ElevatedButtonThemeData(
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return _accentPrimaryColor;
        }
        return _primaryColor; // Use the component's default.
      },
    ),
  ),
);
