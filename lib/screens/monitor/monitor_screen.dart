import 'package:flutter/material.dart';
import '../../models/direction.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/agent_card.dart';
import '../../widgets/app_header.dart';
import '../../widgets/intersection_painter.dart';
import '../../widgets/lane_card.dart';
import '../../widgets/panel.dart';
import '../../widgets/pill.dart';
import 'intersection_picker_dialog.dart';
import '../../widgets/observe.dart';

class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  Widget _picker(BuildContext context, String name) => InkWell(
        onTap: () => showIntersectionPicker(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: AppColors.maroonLight,
              borderRadius: BorderRadius.circular(10)),
          child: Row(children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
            const Icon(Icons.keyboard_arrow_down, size: 18),
          ]),
        ),
      );

  Widget _latestEvents(int id) {
    final events = app.events.where((e) => e.intersection == id).take(3).toList();
    return Panel(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Latest events',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        if (events.isEmpty)
          Text('No events yet for this intersection.',
              style: TextStyle(color: app.muted)),
        for (final e in events)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('${e.time}  ${e.message}',
                style: TextStyle(color: app.muted, fontSize: 13)),
          ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) => Observe(builder: _build);

  Widget _build(BuildContext context) {
    final i = app.current;
    final d = i.decision;

    return Column(children: [
      AppHeader('Monitor', trailing: _picker(context, i.name)),
      Expanded(
        child: ListView(padding: const EdgeInsets.all(14), children: [
          Panel(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                    child: Text('CAM-0${i.id} live feed',
                        style: TextStyle(color: app.muted))),
                Pill(
                    i.idle
                        ? 'IDLE - FLASHING YELLOW'
                        : (i.heavy ? 'LIVE - HIGH VOLUME' : 'LIVE - NORMAL'),
                    color: i.statusColor),
              ]),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 1.55,
                  child: CustomPaint(painter: IntersectionPainter(i.counts, d)),
                ),
              ),
              if (i.idle) ...[
                const SizedBox(height: 8),
                Text('No vehicles detected. Signals are flashing yellow.',
                    style: TextStyle(color: app.muted, fontSize: 12)),
              ],
            ]),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.75,
            children: [
              for (final dir in Dir.values) LaneCard(dir, i.counts[dir]!, d),
            ],
          ),
          const SizedBox(height: 12),
          AgentCard(d),
          const SizedBox(height: 12),
          _latestEvents(i.id),
        ]),
      ),
    ]);
  }
}
