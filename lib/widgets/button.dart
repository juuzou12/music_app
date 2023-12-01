import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget{

  final Widget widget;
  final double height,width,radius;
  final int color,borderColor;

  const ButtonWidget({required this.widget, required this.height, required this.width, required this.radius, required this.color, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return height!=0?AnimatedContainer(
      width: width,
      height: height,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Color(color),
      ), duration: Duration(milliseconds: 400),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget,
      ),
    ):AnimatedContainer(
      duration: Duration(milliseconds: 400),
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Color(color),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget,
      ),
    );
  }

}