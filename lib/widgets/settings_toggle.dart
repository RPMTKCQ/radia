import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class SettingsToggle extends StatelessWidget {
  final String title, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const SettingsToggle(this.title, this.subtitle,
      {super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Text(subtitle, style: TextStyle(color: app.muted, fontSize: 13)),
          ])),
          Switch(
              value: value,
              onChanged: (x) => app.update(() => onChanged(x)),
              activeTrackColor: AppColors.green,
              activeColor: Colors.white),
        ]),
      );
}
