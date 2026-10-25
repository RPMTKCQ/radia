import 'package:flutter/material.dart';
import '../models/direction.dart';
import '../models/intersection.dart';
import '../state/app_state.dart';
import 'lane_signal.dart';
import 'panel.dart';
import 'pill.dart';

/// Plain-language summary for drivers: how busy the intersection is and
/// what each lane's light is doing. No camera or agent details.
class DriverOverviewCard extends StatelessWidget {
  final Intersection x;
  const DriverOverviewCard(this.x, {super.key});

  @override
  Widget build(BuildContext context) {
    final d = x.decision;
    return Panel(
      borderColor: x.heavy ? x.statusColor : null,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
              child: Text(x.name,
                  style:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
          Pill(x.status, color: x.statusColor),
        ]),
        const SizedBox(height: 6),
        Text(x.advice, style: TextStyle(color: app.muted)),
        const SizedBox(height: 12),
        for (final lane in x.lanes)
          Builder(builder: (_) {
            final sig = laneSignal(d, lane);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                Expanded(
                    child: Text('${lane.label} lane',
                        style: const TextStyle(fontWeight: FontWeight.w700))),
                Text('${x.counts[lane]} vehicles',
                    style: TextStyle(color: app.muted, fontSize: 13)),
                const SizedBox(width: 10),
                Pill(sig.label,
                    color: sig.color,
                    fg: sig.textColor,
                    icon: app.colorBlind ? sig.icon : null),
              ]),
            );
          }),
      ]),
    );
  }
}
