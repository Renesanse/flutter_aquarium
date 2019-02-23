import 'package:flutter/material.dart';
import 'dart:math';


class Fish extends StatefulWidget {

  final size;
  final hunter;

  bool dead = false;

  Point startPoint;
  Point currentPoint;
  Point endPoint;

  Fish({this.size, this.hunter});

  final state = _FishState();

  createState() => state;

  hide(){
    if(!dead){
      Future.delayed(Duration(minutes: 1), (){
        dead = false;
      });
    }
  }
}


class _FishState extends State<Fish> with TickerProviderStateMixin {

  var height;
  var width;

  final sizeAndSpeed = {
    10: 50.0,
    20: 40.0,
    30: 30.0,
    40: 20.0,
    50: 10.0
  };

  Animation animation;
  AnimationController controller;

  dispose(){
    controller.dispose();
    super.dispose();
  }

  build(context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    if(widget.startPoint == null){
      final x = Random().nextInt(width.round() - widget.size).roundToDouble();
      final y = Random().nextInt(height.round() - widget.size).roundToDouble();
      widget.startPoint = Point(x,y);
    }
    var x = Random().nextInt(width.round() - widget.size).roundToDouble();
    var y = Random().nextInt(height.round() - widget.size).roundToDouble();
    widget.endPoint = Point(x, y);

    final distance = widget.startPoint.distanceTo(widget.endPoint);

    var time = distance / sizeAndSpeed[widget.size] ?? 1;

    if(time.round() == 0)
      time = 1;
    controller = AnimationController(duration: Duration(seconds: time.round()), vsync: this)
      ..addStatusListener((status) {
        if(status == AnimationStatus.completed) {
          setState(() {
            widget.startPoint = animation.value;
          });
        }
      });

    animation = Tween(begin: widget.startPoint, end: widget.endPoint).animate(controller);

    controller.forward();

    return AnimatedBuilder(
        animation: animation,
        builder: (context,_){
          widget.currentPoint = Point(animation.value.x + widget.size / 2, animation.value.y + widget.size / 2);
          if(widget.dead)
            return Container();
          return Container(
            margin: EdgeInsets.only(
                  left: animation.value.x,
                  top: animation.value.y
            ),
              child: SizedBox(
                width: widget.size.roundToDouble(),
                height: widget.size.roundToDouble(),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: widget.hunter ? Image.asset('assets/shark.png').image
                        : Image.asset('assets/fish.png').image,)
                  ),
                ),
              ),
            );
        });
  }
}
