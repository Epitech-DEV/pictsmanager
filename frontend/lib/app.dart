import 'package:flutter/material.dart';
import 'package:frontend/presentations/pages/home.dart';

import 'presentations/themes/default.dart';

class PictsManagerApp extends StatelessWidget {
  const PictsManagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Picts Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        elevatedButtonTheme: buttonThemeData
      ),
      home: const Home(),
    );
  }
}
