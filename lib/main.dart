import 'package:flutter/material.dart';
import 'fish.dart';

void main() => runApp(
  MaterialApp(
    home: Scaffold(
      body: MyApp(),
    ),
  )
);

class MyApp extends StatefulWidget{

  Stream eventWatcher = Stream.periodic(Duration(milliseconds: 100));

  createState() => MyAppState();

  final fishes = [
    Fish(size: 30, hunter: true),
    Fish(size: 20, hunter: false),
    Fish(size: 30, hunter: true),
    Fish(size: 40, hunter: false),
    Fish(size: 50, hunter: true),
    Fish(size: 30, hunter: false),
    Fish(size: 20, hunter: true),
    Fish(size: 30, hunter: false),
    Fish(size: 40, hunter: true),
    Fish(size: 50, hunter: false),
  ];

  final source = [];

}


class MyAppState extends State<MyApp> {

  build(context) {
    _watch();
    return OrientationBuilder(builder: (context, or){
      if (or == Orientation.landscape){
        widget.fishes.forEach((fish){
          fish.state.setState((){});
        });
      }
    });
  }

  _watch() {
    widget.eventWatcher.listen((time) async {
      await _checkPositions();
    });
  }

  _checkPositions() async {
    for(Fish fish1 in  widget.fishes){
      for (Fish fish2 in widget.fishes){
        if(!fish1.dead
            && !fish2.dead
            && fish1.hunter
            && fish1 != fish2
            && fish1.size - fish2.size >= -1
            && fish1.currentPoint.distanceTo(fish2.currentPoint) < (fish1.size + fish2.size)/4
        ){
          fish2.hide();
          fish2.dead = true;
        }
      }
    }
  }
}