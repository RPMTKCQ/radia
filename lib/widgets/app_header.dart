import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const AppHeader(this.title, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) => Container(
        color: AppColors.maroon,
        padding: EdgeInsets.fromLTRB(
            20, MediaQuery.of(context).padding.top + 12, 20, 14),
        child: Row(children: [
          Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w800))),
          if (trailing != null) trailing!,
        ]),
      );
}
