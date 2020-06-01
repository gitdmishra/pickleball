import 'package:flutter/material.dart';

class CourtPainter extends CustomPainter {
  CourtPainter({this.color});

  final Color color;

  void paint(Canvas canvas, Size size) {}

  bool shouldRepaint(CourtPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}