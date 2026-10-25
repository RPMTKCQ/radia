import 'package:flutter/material.dart';
import '../models/direction.dart';
import '../models/intersection.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'lane_signal.dart';
import 'panel.dart';
import 'pill.dart';

/// Event Log tile for one lane / camera.
class LaneSummaryCard extends StatelessWidget {
  final Intersection x;
  final Dir lane;
  final double width;
  final bool showCameraLink;
  const LaneSummaryCard(this.x, this.lane,
      {super.key, required this.width, required this.showCameraLink});

  @override
  Widget build(BuildContext context) {
    final sig = laneSignal(x.decision, lane);
    return SizedBox(
      width: width,
      child: Panel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${lane.label} lane',
              style: const TextStyle(fontWeight: FontWeight.w800)),
          Text(x.cameraLabel(lane),
              style: TextStyle(color: app.muted, fontSize: 12)),
          const SizedBox(height: 8),
          Pill(sig.label,
              color: sig.color,
              fg: sig.textColor,
              icon: app.colorBlind ? sig.icon : null),
          const SizedBox(height: 8),
          Text('Vehicles now  ${x.counts[lane]}',
              style: TextStyle(color: app.muted, fontSize: 12)),
          if (showCameraLink)
            GestureDetector(
              onTap: () => app.update(() => app.tab = 0),
              child: const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text('View camera >',
                    style: TextStyle(
                        color: AppColors.yellow,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ),
        ]),
      ),
    );
  }
}
