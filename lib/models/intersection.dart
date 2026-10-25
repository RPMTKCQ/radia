import 'package:flutter/material.dart';
import '../services/traffic_agent.dart';
import '../theme/app_theme.dart';
import 'decision.dart';
import 'direction.dart';

/// ONE intersection watched by 2 to 4 cameras. Each camera looks at ONE lane.
/// Camera 1 watches lanes[0], camera 2 watches lanes[1], and so on.
class Intersection {
  final String name;
  final List<Dir> lanes;
  final Map<Dir, int> counts; // vehicles currently detected per lane
  final Set<Dir> videoDriven = {}; // lanes whose count comes from a video's AI file
  int adjustments;

  Intersection({
    required this.name,
    required this.lanes,
    required Map<Dir, int> initial,
    this.adjustments = 0,
  })  : assert(lanes.length >= 2 && lanes.length <= 4,
            'an intersection needs 2 to 4 lanes / cameras'),
        counts = {for (final l in lanes) l: initial[l] ?? 0};

  int cameraNumber(Dir lane) => lanes.indexOf(lane) + 1;
  String cameraLabel(Dir lane) => 'CAM-0${cameraNumber(lane)}';

  Decision get decision => TrafficAgent.decide(counts);
  int get total => counts.values.fold(0, (a, b) => a + b);
  bool get idle => total == 0;
  bool get heavy =>
      counts.values.any((v) => v >= 15) || total >= 12 * lanes.length;

  Dir get busiestLane =>
      lanes.reduce((a, b) => counts[b]! > counts[a]! ? b : a);

  String get advice => idle
      ? 'Clear. No vehicles detected.'
      : (heavy
          ? 'Heavy traffic. Expect delays on the ${busiestLane.label} lane.'
          : 'Traffic is moving normally.');
  String get status => idle ? 'IDLE' : (heavy ? 'HIGH VOLUME' : 'NORMAL');
  Color get statusColor =>
      idle ? AppColors.yellow : (heavy ? AppColors.amber : AppColors.green);
}
