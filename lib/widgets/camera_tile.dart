import 'package:flutter/material.dart';
import '../models/direction.dart';
import '../models/intersection.dart';
import '../state/app_state.dart';
import 'camera_feed.dart';
import 'lane_signal.dart';
import 'panel.dart';
import 'pill.dart';

/// One camera: its video, how many vehicles it sees, and its signal (GO / STOP).
class CameraTile extends StatelessWidget {
  final Intersection x;
  final Dir lane;
  final double width;
  const CameraTile(this.x, this.lane, {super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    final sig = laneSignal(x.decision, lane);
    return SizedBox(
      width: width,
      child: Panel(
        padding: const EdgeInsets.all(10),
        borderColor: sig.color,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${x.cameraLabel(lane)}  ${lane.label} lane',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          CameraFeed(key: ValueKey(lane), intersection: x, lane: lane),
          const SizedBox(height: 8),
          Text('${x.counts[lane]} vehicles',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Pill(sig.label,
              color: sig.color,
              fg: sig.textColor,
              icon: app.colorBlind ? sig.icon : null),
        ]),
      ),
    );
  }
}
