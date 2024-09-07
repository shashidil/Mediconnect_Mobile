import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final double elevation;
  final ShapeBorder shape;
  final Widget child;

  const CardWidget({
    super.key,
    required this.elevation,
    required this.shape,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: shape,
      child: child,
    );
  }
}