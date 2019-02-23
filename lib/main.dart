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

  Stream eventWatcher = Stream.periodic(Duration(milliseconds: 10));

  createState() => MyAppState();

  final fishes = [
    Fish(size: 10, hunter: false),
    Fish(size: 20, hunter: true),
    Fish(size: 30, hunter: false),
    Fish(size: 40, hunter: true),
    Fish(size: 50, hunter: false),
    Fish(size: 10, hunter: true),
    Fish(size: 20, hunter: false),
    Fish(size: 30, hunter: true),
    Fish(size: 40, hunter: false),
    Fish(size: 50, hunter: true),
  ];

  final source = [];

}


class MyAppState extends State<MyApp> {

  initState(){
    super.initState();
    Future.delayed(Duration(milliseconds: 15), (){
      _watch();
    });
  }

  build(context) {
    return Container(
      height : MediaQuery.of(context).size.height,
      width : MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.indigo,
      ),
      child: Stack(
        children: widget.fishes,
      ),
    );
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
            && fish1.size - fish2.size >= -10
            && fish1.currentPoint.distanceTo(fish2.currentPoint) < fish1.size / 2
        ){
          fish2.hide();
          fish2.dead = true;
        }
      }
    }
  }
}
