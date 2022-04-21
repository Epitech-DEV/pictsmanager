import 'package:flutter/material.dart';

import '../themes/default.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var counter = 0;

  void count() {
    setState(() {
      counter = counter + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text("Themed elevated button", style: h1Style),
            ElevatedButton(
              child: Text(counter.toString()),
              onPressed: () {
                count();
              },
            ),
          ],
        ),
      ),
    );
  }
}
