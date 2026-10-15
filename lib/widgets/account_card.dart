import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'panel.dart';
import 'pill.dart';

/// Shows who is using the app (authorized email, or guest driver).
class AccountCard extends StatelessWidget {
  final String title, subtitle, badge;
  const AccountCard(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.badge});

  @override
  Widget build(BuildContext context) => Panel(
        child: Row(children: [
          const CircleAvatar(
              backgroundColor: AppColors.maroonLight,
              child: Icon(Icons.person, color: Colors.white)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            Text(subtitle,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: app.muted, fontSize: 13)),
          ])),
          Pill(badge, color: AppColors.maroonLight, fg: Colors.white),
        ]),
      );
}
