import 'dart:math';

import 'package:flutter/material.dart';

class Figure extends StatefulWidget {
  final double size;
  final hunter;

  Figure(this.size, this.hunter);

  Point killPoint;
  bool dead = false;
  bool rotated;

  createState() => FigureState();

  hide() {
    if (!dead) {
      Future.delayed(Duration(minutes: 1), () {
        dead = false;
      });
    }
  }
}

class FigureState extends State<Figure> with TickerProviderStateMixin {
  Point startPoint;
  Point endPoint;

  double x;
  double y;

  Animation animation;
  AnimationController controller;

  build(context) {
    if (x == null) {
      x = MediaQuery.of(context).size.width;
      y = MediaQuery.of(context).size.height;
    }

    if (controller != null) controller.dispose();

    if (startPoint == null) {
      double startX = Random().nextDouble() * x;
      double startY = Random().nextDouble() * y;
      startPoint = Point(
        startX - widget.size >= x ? x : startX - widget.size,
        startY - widget.size >= y ? y : startY - widget.size,
      );
    }

    double endX = Random().nextDouble() * x;
    double endY = Random().nextDouble() * y;

    endPoint = Point(
      endX - widget.size >= x ? x : endX - widget.size,
      endY - widget.size >= y ? y : endY - widget.size,
    );

    final distance = startPoint.distanceTo(endPoint);

    var time = distance / 500;

    if (time.round() == 0) time = 1;

    controller = AnimationController(
        duration: Duration(seconds: time.round()), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            startPoint = animation.value;
          });
        }
      });

    animation = Tween(begin: startPoint, end: endPoint).animate(controller);

    controller.forward();

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        if (widget.dead) return Container();
        return OrientationBuilder(
          builder: (context, orientation) {
            orientation == Orientation.portrait
                ? widget.rotated = false
                : widget.rotated = true;
            widget.killPoint = Point(x - animation.value.x - widget.size / 2,
                y - animation.value.y - widget.size / 2);
            return Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.green)),
              child: Container(
                decoration: BoxDecoration(
                    color: widget.hunter ? Colors.deepOrange : Colors.green,
                    borderRadius: BorderRadius.circular(widget.size)),
                child: SizedBox(
                  width: widget.size,
                  height: widget.size,
                ),
              ),
              padding: EdgeInsets.only(
                left: widget.rotated
                    ? animation.value.y < 0 ? 0 : animation.value.y
                    : animation.value.x < 0 ? 0 : animation.value.x,
                top: widget.rotated
                    ? animation.value.x < 0 ? 0 : animation.value.x
                    : animation.value.y < 0 ? 0 : animation.value.y,
              ),
            );
          },
        );
      },
    );
  }
}
