import 'package:flutter/material.dart';

/// Small rounded status label (NORMAL, STOP, GO 32s, ...).
class Pill extends StatelessWidget {
  final String text;
  final Color color;
  final Color fg;
  final IconData? icon;
  const Pill(this.text,
      {super.key, required this.color, this.fg = Colors.black, this.icon});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: fg),
            const SizedBox(width: 3)
          ],
          Text(text,
              style: TextStyle(
                  color: fg, fontSize: 10, fontWeight: FontWeight.w800)),
        ]),
      );
}
