import 'package:flutter/material.dart';

class DotControl extends StatelessWidget {
  final double radius;
  final Color color;

  const DotControl({
    Key key,
    @required this.color,
    @required this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
