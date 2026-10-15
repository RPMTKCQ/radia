import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../widgets/account_card.dart';
import '../../widgets/app_header.dart';
import '../../widgets/logout_button.dart';
import '../../widgets/panel.dart';
import '../../widgets/settings_toggle.dart';
import '../../widgets/text_size_row.dart';
import '../../widgets/observe.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => Observe(builder: (context) => Column(children: [
        const AppHeader('Settings'),
        Expanded(
          child: ListView(padding: const EdgeInsets.all(14), children: [
            AccountCard(
                title: 'Signed in',
                subtitle: app.userEmail ?? 'Authorized user',
                badge: 'AUTHORIZED'),
            const SizedBox(height: 12),
            Panel(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Display & notifications',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                SettingsToggle('Heavy traffic alerts',
                    'Notify me when a lane is heavily congested.',
                    value: app.alerts, onChanged: (v) => app.alerts = v),
                SettingsToggle('Phase change alerts',
                    'Notify me when the agent switches signal phase.',
                    value: app.phaseAlerts, onChanged: (v) => app.phaseAlerts = v),
                SettingsToggle('High-contrast mode', 'Bold colors on black.',
                    value: app.highContrast,
                    onChanged: (v) => app.highContrast = v),
                TextSizeRow(),
                SettingsToggle('Color-blind-safe signals',
                    'Adds icons and labels to signal states.',
                    value: app.colorBlind, onChanged: (v) => app.colorBlind = v),
              ]),
            ),
            const SizedBox(height: 14),
            LogoutButton(),
          ]),
        ),
      ]));
}
