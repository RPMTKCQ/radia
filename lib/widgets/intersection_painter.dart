import 'dart:math';
import 'package:flutter/material.dart';
import '../models/decision.dart';
import '../models/direction.dart';
import '../theme/app_theme.dart';

/// Top-down schematic of an intersection with vehicles per lane.
class IntersectionPainter extends CustomPainter {
  final Map<Dir, int> counts;
  final Decision d;
  IntersectionPainter(this.counts, this.d);

  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2, cy = s.height / 2, rw = s.height * 0.2;
    canvas.drawRect(Offset.zero & s, Paint()..color = const Color(0xFF111113));
    final road = Paint()..color = const Color(0xFF2A2A2E);
    canvas.drawRect(Rect.fromLTRB(0, cy - rw, s.width, cy + rw), road);
    canvas.drawRect(Rect.fromLTRB(cx - rw, 0, cx + rw, s.height), road);

    final yellow = Paint()
      ..color = AppColors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    final box =
        Rect.fromCenter(center: Offset(cx, cy), width: rw * 2, height: rw * 2);
    canvas.drawRect(box, yellow);
    canvas.drawLine(box.topLeft, box.bottomRight, yellow);
    canvas.drawLine(box.topRight, box.bottomLeft, yellow);

    final fill = Paint()..color = const Color(0xFF2E7D4F);
    final edge = Paint()
      ..color = AppColors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    void car(Rect r) {
      final rr = RRect.fromRectAndRadius(r, const Radius.circular(2));
      canvas.drawRRect(rr, fill);
      canvas.drawRRect(rr, edge);
    }

    const l = 15.0, w = 9.0, gap = 4.0;
    for (var k = 0; k < min(counts[Dir.west]!, 8); k++) {
      car(Rect.fromLTWH(
          cx - rw - 8 - (k + 1) * (l + gap), cy - rw * .5 - w / 2, l, w));
    }
    for (var k = 0; k < min(counts[Dir.east]!, 8); k++) {
      car(Rect.fromLTWH(
          cx + rw + 8 + k * (l + gap), cy + rw * .5 - w / 2, l, w));
    }
    for (var k = 0; k < min(counts[Dir.north]!, 5); k++) {
      car(Rect.fromLTWH(
          cx - rw * .5 - w / 2, cy - rw - 8 - (k + 1) * (l + gap), w, l));
    }
    for (var k = 0; k < min(counts[Dir.south]!, 5); k++) {
      car(Rect.fromLTWH(
          cx + rw * .5 - w / 2, cy + rw + 8 + k * (l + gap), w, l));
    }

    Color sig(bool ns) => d.flashing
        ? AppColors.yellow
        : (d.nsGreen == ns ? AppColors.green : AppColors.red);
    void dot(Offset o, Color c) => canvas.drawCircle(o, 4.5, Paint()..color = c);
    dot(Offset(cx - rw - 8, cy - rw - 8), sig(false)); // west
    dot(Offset(cx + rw + 8, cy + rw + 8), sig(false)); // east
    dot(Offset(cx + rw + 8, cy - rw - 8), sig(true)); // north
    dot(Offset(cx - rw - 8, cy + rw + 8), sig(true)); // south
  }

  @override
  bool shouldRepaint(covariant IntersectionPainter old) => true;
}
