import 'package:flutter/material.dart';

import 'themes/default.dart';
import 'views/login.dart';

class PictsManagerApp extends StatelessWidget {
  const PictsManagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Picts Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        elevatedButtonTheme: buttonThemeData,
        inputDecorationTheme: textFieldThemeData,
      ),
      home: const LoginView(),
    );
  }
}
