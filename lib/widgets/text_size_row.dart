import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class TextSizeRow extends StatelessWidget {
  const TextSizeRow({super.key});

  Widget _btn(String label, double scale) {
    final on = app.textScale == scale;
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: InkWell(
        onTap: () => app.update(() => app.textScale = scale),
        child: Container(
          width: 52,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: on ? AppColors.maroonLight : AppColors.surface2,
              borderRadius: BorderRadius.circular(10)),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Text size',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Text('Make text larger.',
                style: TextStyle(color: app.muted, fontSize: 13)),
          ])),
          _btn('A-', 0.9),
          _btn('A', 1.0),
          _btn('A+', 1.2),
        ]),
      );
}
