import 'package:flutter/material.dart';
import '../models/direction.dart';
import '../models/intersection.dart';
import '../state/app_state.dart';
import 'panel.dart';
import 'pill.dart';

/// Plain-language traffic summary for drivers (no camera or agent details).
class DriverIntersectionCard extends StatelessWidget {
  final Intersection i;
  const DriverIntersectionCard(this.i, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Panel(
          borderColor: i.heavy ? i.statusColor : null,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                  child: Text(i.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800))),
              Pill(i.status, color: i.statusColor),
            ]),
            const SizedBox(height: 6),
            Text(i.advice, style: TextStyle(color: app.muted)),
            if (!i.idle)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                    'Busiest: ${i.busiestLane.label} lane (${i.counts[i.busiestLane]} vehicles)',
                    style: TextStyle(color: app.muted, fontSize: 12)),
              ),
          ]),
        ),
      );
}
