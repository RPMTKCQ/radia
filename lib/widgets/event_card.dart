import 'package:flutter/material.dart';
import '../models/log_event.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'panel.dart';
import 'pill.dart';

class EventCard extends StatelessWidget {
  final LogEvent e;
  const EventCard(this.e, {super.key});

  @override
  Widget build(BuildContext context) {
    final idle = e.type == 'IDLE MODE';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Panel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(e.time, style: TextStyle(color: app.muted))),
            Pill(e.type,
                color: idle ? AppColors.yellow : AppColors.surface2,
                fg: idle ? Colors.black : Colors.white),
          ]),
          const SizedBox(height: 4),
          Text('${app.intersection.name}  |  ${e.lane}',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          Text(e.message, style: TextStyle(color: app.muted)),
        ]),
      ),
    );
  }
}
