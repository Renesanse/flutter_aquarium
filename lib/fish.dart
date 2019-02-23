import 'package:flutter/material.dart';
import 'dart:math';

class Fish extends StatefulWidget {

  final size;
  final hunter;
  bool dead = false;
  bool portrait = true;

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

  build(context) {

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    if(widget.startPoint == null){
      final x = Random().nextInt(width.round()).roundToDouble();
      final y = Random().nextInt(height.round()).roundToDouble();
      widget.startPoint = Point(x,y);
    }
    if(widget.portrait){
      final x = Random().nextInt(width.round()).roundToDouble();
      final y = Random().nextInt(height.round()).roundToDouble();
      widget.endPoint = Point(x, y);
    }else{
      final y = Random().nextInt(width.round()).roundToDouble();
      final x = Random().nextInt(height.round()).roundToDouble();
      widget.endPoint = Point(x, y);
    }

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
        builder: (context,_) {
          if (widget.dead)
            return Container();
          return OrientationBuilder(builder: (context, or){
            if(or == Orientation.portrait){
              widget.portrait = true;
              final currentX = animation.value.x - widget.size / 2;
              final currentY = animation.value.y - widget.size / 2;
              widget.currentPoint = Point(currentX, currentY);
              return Container(
                margin: EdgeInsets.only(
                  left: widget.currentPoint.x < 1 ? 0 : widget.currentPoint.x,
                  top: widget.currentPoint.y < 1 ? 0 : widget.currentPoint.y,
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
            }else{
              widget.portrait = false;
              final currentX = animation.value.x - widget.size / 2;
              final currentY = animation.value.y - widget.size / 2;
              widget.currentPoint = Point(currentY, currentX);
              return Container(
                margin: EdgeInsets.only(
                  left: widget.currentPoint.x < 1 ? 0 : widget.currentPoint.x,
                  top: widget.currentPoint.y < 1 ? 0 : widget.currentPoint.y,
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
            }
          });
        });
  }
}
