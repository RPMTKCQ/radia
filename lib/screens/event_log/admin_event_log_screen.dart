import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../widgets/app_chip.dart';
import '../../widgets/app_header.dart';
import '../../widgets/event_card.dart';
import '../../widgets/filter_chip_row.dart';
import '../../widgets/lane_summary_card.dart';
import '../../widgets/observe.dart';
import '../../widgets/panel.dart';

/// Full log for authorized users: every lane / camera, filters by event type,
/// and links back to the cameras.
class AdminEventLogScreen extends StatelessWidget {
  const AdminEventLogScreen({super.key});

  static const _types = {
    'All types': null,
    'Density adjust': 'DENSITY ADJUST',
    'Idle mode': 'IDLE MODE',
  };

  @override
  Widget build(BuildContext context) => Observe(builder: _build);

  Widget _empty() => Panel(
        padding: const EdgeInsets.symmetric(vertical: 34),
        child: Center(
          child: Column(children: [
            const Icon(Icons.list_rounded, size: 34),
            const SizedBox(height: 8),
            const Text('No events yet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text('Events appear here when the system adjusts signals.',
                textAlign: TextAlign.center,
                style: TextStyle(color: app.muted)),
          ]),
        ),
      );

  Widget _build(BuildContext context) {
    final x = app.intersection;
    final evs = app.filteredEvents;

    return Column(children: [
      const AppHeader('Event Log'),
      Expanded(
        child: ListView(padding: const EdgeInsets.all(14), children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text('${x.name}  |  ${x.lanes.length} cameras',
                style: TextStyle(color: app.muted)),
          ),
          LayoutBuilder(builder: (_, c) {
            final w = (c.maxWidth - 10) / 2;
            return Wrap(spacing: 10, runSpacing: 10, children: [
              for (final lane in x.lanes)
                LaneSummaryCard(x, lane, width: w, showCameraLink: true),
            ]);
          }),
          const SizedBox(height: 14),
          FilterChipRow(children: [
            for (final e in _types.entries)
              AppChip(e.key,
                  selected: app.typeFilter == e.value,
                  onTap: () => app.update(() => app.typeFilter = e.value)),
          ]),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('${evs.length} events',
                style: TextStyle(color: app.muted, fontSize: 13)),
          ),
          if (evs.isEmpty) _empty(),
          for (final e in evs) EventCard(e),
        ]),
      ),
    ]);
  }
}
