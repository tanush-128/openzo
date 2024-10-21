import "package:flutter/material.dart";

class Skeleton extends StatelessWidget {
  Skeleton({
    Key? key,
    this.width = 100,
    this.height = 80,
  }) : super(key: key);
  int width = 100;
  int height = 80;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.toDouble(),
      height: height.toDouble(),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
  }
}
