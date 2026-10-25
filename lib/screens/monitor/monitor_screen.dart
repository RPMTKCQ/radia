import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/agent_card.dart';
import '../../widgets/app_header.dart';
import '../../widgets/camera_tile.dart';
import '../../widgets/observe.dart';
import '../../widgets/panel.dart';
import '../../widgets/pill.dart';

/// One intersection, one camera per lane. The vehicles seen by each camera
/// decide which lanes get the green light.
class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context) => Observe(builder: _build);

  Widget _signalSummary() {
    final x = app.intersection;
    final d = x.decision;
    final headline = d.flashing
        ? 'Flashing yellow: no vehicles detected'
        : '${d.nsGreen ? 'North-South' : 'East-West'} green for ${d.greenSeconds} s';
    return Panel(
      child: Row(children: [
        const Icon(Icons.traffic, color: AppColors.yellow),
        const SizedBox(width: 12),
        Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(headline,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
          Text('${x.lanes.length} cameras, one per lane',
              style: TextStyle(color: app.muted, fontSize: 12)),
        ])),
        Pill(x.status, color: x.statusColor),
      ]),
    );
  }

  Widget _latestEvents() {
    final events = app.events.take(3).toList();
    return Panel(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Latest events',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        if (events.isEmpty)
          Text('No events yet.', style: TextStyle(color: app.muted)),
        for (final e in events)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('${e.time}  ${e.message}',
                style: TextStyle(color: app.muted, fontSize: 13)),
          ),
      ]),
    );
  }

  Widget _build(BuildContext context) {
    final x = app.intersection;
    return Column(children: [
      AppHeader('Monitor',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                color: AppColors.maroonLight,
                borderRadius: BorderRadius.circular(10)),
            child: Text(x.name,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          )),
      Expanded(
        child: ListView(padding: const EdgeInsets.all(14), children: [
          _signalSummary(),
          const SizedBox(height: 12),
          LayoutBuilder(builder: (_, c) {
            final w = (c.maxWidth - 10) / 2;
            return Wrap(spacing: 10, runSpacing: 10, children: [
              for (final lane in x.lanes) CameraTile(x, lane, width: w),
            ]);
          }),
          const SizedBox(height: 12),
          AgentCard(x.decision),
          const SizedBox(height: 12),
          _latestEvents(),
        ]),
      ),
    ]);
  }
}
