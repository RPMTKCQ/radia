import 'package:flutter/material.dart';
import '../models/intersection.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'panel.dart';
import 'pill.dart';

String _fmt(int n) => n
    .toString()
    .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');

/// Event Log summary tile for one intersection.
class IntersectionSummaryCard extends StatelessWidget {
  final Intersection i;
  final double width;
  final bool showMonitorLink;
  const IntersectionSummaryCard(this.i,
      {super.key, required this.width, required this.showMonitorLink});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: Panel(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(i.name, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Pill(i.status, color: i.statusColor),
            const SizedBox(height: 8),
            Text('Vehicles today  ${_fmt(i.vehiclesToday)}',
                style: TextStyle(color: app.muted, fontSize: 12)),
            Text('Signal adjusts  ${i.adjustments}',
                style: TextStyle(color: app.muted, fontSize: 12)),
            if (showMonitorLink)
              GestureDetector(
                onTap: () => app.update(() {
                  app.selected = i.id;
                  app.tab = 0;
                }),
                child: const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text('View live monitor >',
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
