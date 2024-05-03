import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;
  final MaterialColor color;

  const GradientContainer({
    Key? key,
    required this.color,
    required this.child,
  })  : assert(color != null, child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, 1.0],
          colors: [
            color.shade800,
            color.shade400,
          ],
        ),
      ),
      child: child,
    );
  }
}
