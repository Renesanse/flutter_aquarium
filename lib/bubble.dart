import 'package:flutter/material.dart';
import 'dart:math';
import 'main.dart';

class Bubble extends StatefulWidget {

  bool rotated;
  Point startPoint;
  Point endPoint;

  createState() => _BubbleState();

}


class _BubbleState extends State<Bubble> with TickerProviderStateMixin {

  var height;
  var width;

  Animation animation;
  AnimationController controller;

  build(context) {

    if(controller != null) controller.dispose();

    if(height == null){
      height = MediaQuery.of(context).size.height;
      width = MediaQuery.of(context).size.width;
      if(height < width){
        final buf = height;
        height = width;
        width = buf;
      }
    }

    final x = Random().nextInt(width.round()).roundToDouble();
    final y = 0.0;
    widget.startPoint = Point(x,y);

    widget.endPoint = Point(x, height);

    controller = AnimationController(duration: Duration(seconds: 2), vsync: this);

    animation = Tween(begin: widget.startPoint, end: widget.endPoint).animate(controller);
    controller.forward();

    return AnimatedBuilder(
        animation: animation,
        builder: (context,_) {
          return OrientationBuilder(builder: (context, or) {
            or == Orientation.portrait ? widget.rotated = false : widget.rotated = true;
            final currentX = animation.value.x < 0.0 ? 0.0 : animation.value.x;
            final currentY = animation.value.y < 0.0 ? 0.0 : animation.value.y;
            return Container(
              padding: EdgeInsets.only(
                left: widget.rotated ? currentY : currentX,
                top: widget.rotated ? currentX : currentY,
              ),
              child: SizedBox(
                width: 30,
                height: 30,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(image: Image.asset('assets/bubble.png').image)
                  ),
                ),
              ),
            );
          });
        });
  }
}
