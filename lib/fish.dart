import 'package:flutter/material.dart';
import 'dart:math';
import 'main.dart';

class Fish extends StatefulWidget {

  final size;
  final hunter;
  bool dead = false;
  bool rotated;

  bool isPunched = false;
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
    10: 25.0,
    20: 20.0,
    30: 15.0,
    40: 10.0,
    50: 5.0
  };

  Animation animation;
  AnimationController controller;

  initState(){
    super.initState();
  }

  build(context) {

    if(controller != null){
      controller.dispose();
    }

    if(height == null){
      height = MediaQuery.of(context).size.height;
      width = MediaQuery.of(context).size.width;
    }

    if(widget.startPoint == null){
      final x = Random().nextInt(width.round() - widget.size).roundToDouble();
      final y = Random().nextInt(height.round() - widget.size).roundToDouble();
      widget.startPoint = Point(x,y);
    }

    final x = Random().nextInt(width.round() - widget.size).roundToDouble();
    final y = Random().nextInt(height.round() - widget.size).roundToDouble();

    widget.endPoint = Point(x, y);

    final distance = widget.startPoint.distanceTo(widget.endPoint);

    var time = distance / sizeAndSpeed[widget.size];

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
        builder: (context,_) {final currentX = animation.value.x - widget.size / 2;
        final currentY = animation.value.y - widget.size / 2;
        widget.currentPoint = Point(currentX, currentY);
        if (widget.dead)
          return Container();
        return OrientationBuilder(builder: (context, or) {
          or == Orientation.portrait ?  widget.rotated = false : widget.rotated = true;
          return Container(
            margin: EdgeInsets.only(
              left: widget.rotated ? animation.value.y : animation.value.x,
              top: widget.rotated ? animation.value.x : animation.value.y,
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
        });
  }
}
