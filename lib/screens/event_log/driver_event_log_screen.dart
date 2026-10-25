import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../widgets/app_header.dart';
import '../../widgets/driver_overview_card.dart';
import '../../widgets/event_card.dart';
import '../../widgets/observe.dart';
import '../../widgets/panel.dart';

/// Simple view for drivers: how busy the intersection is right now, what each
/// lane's light is doing, and the most recent signal changes.
class DriverEventLogScreen extends StatelessWidget {
  const DriverEventLogScreen({super.key});

  @override
  Widget build(BuildContext context) => Observe(builder: _build);

  Widget _build(BuildContext context) {
    final evs = app.events.take(10).toList();

    return Column(children: [
      const AppHeader('Event Log'),
      Expanded(
        child: ListView(padding: const EdgeInsets.all(14), children: [
          const Text('Traffic right now',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          DriverOverviewCard(app.intersection),
          const SizedBox(height: 16),
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
