import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../widgets/app_chip.dart';
import '../../widgets/app_header.dart';
import '../../widgets/event_card.dart';
import '../../widgets/intersection_summary_card.dart';
import '../../widgets/panel.dart';
import '../../widgets/observe.dart';

/// Full log for authorized users: filters by intersection and event type,
/// daily stats, and links to the live monitor.
class AdminEventLogScreen extends StatelessWidget {
  const AdminEventLogScreen({super.key});

  static const _types = {
    'All types': null,
    'Density adjust': 'DENSITY ADJUST',
    'Idle mode': 'IDLE MODE',
  };

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

  @override
  Widget build(BuildContext context) => Observe(builder: _build);

  Widget _build(BuildContext context) {
    final list = app.intersections
        .where((i) => app.filter == null || i.id == app.filter)
        .toList();
    final evs = app.filteredEvents;

    return Column(children: [
      const AppHeader('Event Log'),
      Expanded(
        child: ListView(padding: const EdgeInsets.all(14), children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              AppChip('All intersections',
                  selected: app.filter == null,
                  onTap: () => app.update(() => app.filter = null)),
              for (final i in app.intersections)
                AppChip(i.name,
                    selected: app.filter == i.id,
                    onTap: () => app.update(() => app.filter = i.id)),
            ]),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              for (final e in _types.entries)
                AppChip(e.key,
                    selected: app.typeFilter == e.value,
                    onTap: () => app.update(() => app.typeFilter = e.value)),
            ]),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(builder: (_, c) {
            final w = (c.maxWidth - 10) / 2;
            return Wrap(spacing: 10, runSpacing: 10, children: [
              for (final i in list)
                IntersectionSummaryCard(i, width: w, showMonitorLink: true),
            ]);
          }),
          const SizedBox(height: 14),
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
