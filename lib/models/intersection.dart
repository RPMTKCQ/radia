import 'package:flutter/material.dart';
import '../services/traffic_agent.dart';
import '../theme/app_theme.dart';
import 'decision.dart';
import 'direction.dart';

class Intersection {
  final int id;
  final Map<Dir, int> counts;
  int vehiclesToday, adjustments;

  Intersection(this.id, int n, int s, int e, int w, this.vehiclesToday,
      this.adjustments)
      : counts = {Dir.north: n, Dir.south: s, Dir.east: e, Dir.west: w};

  String get name => 'Intersection ${id.toString().padLeft(2, '0')}';
  Decision get decision => TrafficAgent.decide(counts);
  int get total => counts.values.fold(0, (a, b) => a + b);
  bool get idle => total == 0;
  bool get heavy => total >= 40 || counts.values.any((v) => v >= 15);
  Dir get busiestLane =>
      counts.entries.reduce((a, b) => b.value > a.value ? b : a).key;
  String get advice => idle
      ? 'Clear. No vehicles detected.'
      : (heavy
          ? 'Heavy traffic. Expect delays on the ${busiestLane.label} lane.'
          : 'Traffic is moving normally.');
  String get status => idle ? 'IDLE' : (heavy ? 'HIGH VOLUME' : 'NORMAL');
  Color get statusColor =>
      idle ? AppColors.yellow : (heavy ? AppColors.amber : AppColors.green);
}
