import 'package:flutter/material.dart';
import 'package:frontend/views/home.dart';

class PictsManagerApp extends StatelessWidget {
  const PictsManagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Picts Manager',
<<<<<<< HEAD
      theme: ThemeData.dark(),
      home: const Home(),
=======
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeView(),
>>>>>>> e991ee5e0e684b7c9e4b0b1d54f342d83fdb4f9f
    );
  }
}
