import 'package:flutter/material.dart';
import '../models/decision.dart';
import '../models/direction.dart';
import '../theme/app_theme.dart';

/// What the traffic light for one lane is showing right now.
class LaneSignal {
  final String label;
  final Color color;
  final IconData icon;
  const LaneSignal(this.label, this.color, this.icon);

  Color get textColor => color == AppColors.red ? Colors.white : Colors.black;
}

LaneSignal laneSignal(Decision d, Dir lane) {
  if (d.flashing) {
    return const LaneSignal(
        'FLASH YELLOW', AppColors.yellow, Icons.warning_amber_rounded);
  }
  if (d.nsGreen == lane.isNS) {
    return LaneSignal('GO ${d.greenSeconds}s', AppColors.green, Icons.arrow_upward);
  }
  return const LaneSignal('STOP', AppColors.red, Icons.stop_circle_outlined);
}
