import 'package:flutter/material.dart';
import 'package:frontend/views/home.dart';

class PictsManagerApp extends StatelessWidget {
  const PictsManagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Picts Manager',
      theme: ThemeData.dark(),
      home: const HomeView(),
    );
  }
}