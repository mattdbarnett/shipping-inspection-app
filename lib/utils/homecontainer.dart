import 'package:flutter/material.dart';
import 'package:shipping_inspection_app/utils/colours.dart';

class TopContainer extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;
  final EdgeInsets padding;
  TopContainer({required this.height, required this.width, required this.child,required this.padding});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding!=null ? padding : EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
          color: LightColors.sPurple,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40.0),
            bottomLeft: Radius.circular(40.0),
          )),
      height: height,
      width: width,
      child: child,
    );
  }
}