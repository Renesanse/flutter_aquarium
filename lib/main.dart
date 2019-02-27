import 'package:flutter/material.dart';

import 'figure.dart';

main() => runApp(MaterialApp(
      home: Scaffold(
        body: MyApp(),
      ),
    ));

class MyApp extends StatefulWidget {
  createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Stream eventWatcher = Stream.periodic(Duration(milliseconds: 10));

  final figures = [
    Figure(10, false),
    Figure(20, true),
    Figure(30, false),
    Figure(40, true),
    Figure(50, false),
    Figure(10, true),
    Figure(20, false),
    Figure(30, true),
    Figure(40, false),
    Figure(50, true)
  ];

  initState() {
    super.initState();
    _watch();
  }

  build(context) {
    return Container(
      decoration: BoxDecoration(),
      child: Stack(children: figures),
    );
  }

  _watch() {
    eventWatcher.listen((time) async {
      await _checkPositions();
    });
  }

  _checkPositions() async {
    for (Figure figure1 in figures) {
      for (Figure figure2 in figures) {
        if (!figure1.dead &&
            !figure2.dead &&
            figure1.hunter &&
            figure1 != figure2 &&
            figure1.size - figure2.size >= -10 &&
            figure1.killPoint.distanceTo(figure2.killPoint) <=
                (figure1.size + figure2.size) / 2) {
          figure2.hide();
          figure2.dead = true;
        }
      }
    }
  }
}
