import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Logo extends StatelessWidget {
  final double size;
  const Logo({super.key, this.size = 26});

  @override
  Widget build(BuildContext context) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24)),
          child: Row(children: [
            for (final c in [AppColors.red, AppColors.yellow, AppColors.green])
              Container(
                  width: 9,
                  height: 9,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
          ]),
        ),
        const SizedBox(width: 10),
        Text('RADIANT',
            style: TextStyle(
                fontSize: size, fontWeight: FontWeight.w800, letterSpacing: 4)),
      ]);
}
