import 'package:flutter/material.dart';
import '../models/decision.dart';
import '../models/direction.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'pill.dart';

/// One lane: vehicle count + GO / STOP / FLASH YELLOW state.
class LaneCard extends StatelessWidget {
  final Dir dir;
  final int count;
  final Decision d;
  const LaneCard(this.dir, this.count, this.d, {super.key});

  @override
  Widget build(BuildContext context) {
    final String label;
    final Color color;
    final IconData icon;
    if (d.flashing) {
      label = 'FLASH YELLOW';
      color = AppColors.yellow;
      icon = Icons.warning_amber_rounded;
    } else if (d.nsGreen == dir.isNS) {
      label = 'GO ${d.greenSeconds}s';
      color = AppColors.green;
      icon = Icons.arrow_upward;
    } else {
      label = 'STOP';
      color = AppColors.red;
      icon = Icons.stop_circle_outlined;
    }
    final darkText = color != AppColors.red;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color, width: app.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${dir.label.toUpperCase()} LANE',
            style: TextStyle(color: app.muted, fontSize: 11)),
        const SizedBox(height: 2),
        Text('$count vehicles',
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
        const Spacer(),
        Pill(label,
            color: color,
            fg: darkText ? Colors.black : Colors.white,
            icon: app.colorBlind ? icon : null),
      ]),
    );
  }
}
