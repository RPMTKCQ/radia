import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../widgets/app_chip.dart';
import '../../widgets/app_header.dart';
import '../../widgets/driver_intersection_card.dart';
import '../../widgets/event_card.dart';
import '../../widgets/filter_chip_row.dart';
import '../../widgets/panel.dart';
import '../../widgets/observe.dart';

/// Simple view for drivers: how busy each intersection is right now and
/// the most recent signal changes. No monitor links, no daily statistics.
class DriverEventLogScreen extends StatelessWidget {
  const DriverEventLogScreen({super.key});

  @override
  Widget build(BuildContext context) => Observe(builder: _build);

  Widget _build(BuildContext context) {
    final list = app.intersections
        .where((i) => app.filter == null || i.id == app.filter)
        .toList();
    final evs = app.filteredEvents.take(10).toList();

    return Column(children: [
      const AppHeader('Event Log'),
      Expanded(
        child: ListView(padding: const EdgeInsets.all(14), children: [
          FilterChipRow(children: [
              AppChip('All intersections',
                  selected: app.filter == null,
                  onTap: () => app.update(() => app.filter = null)),
              for (final i in app.intersections)
                AppChip(i.name,
                    selected: app.filter == i.id,
                    onTap: () => app.update(() => app.filter = i.id)),
            ]),
          const SizedBox(height: 12),
          const Text('Traffic right now',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          for (final i in list) DriverIntersectionCard(i),
          const SizedBox(height: 8),
          const Text('Recent signal changes',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          if (evs.isEmpty)
            Panel(
                child: Text('No signal changes yet.',
                    style: TextStyle(color: app.muted))),
          for (final e in evs) EventCard(e),
        ]),
      ),
    ]);
  }
}
