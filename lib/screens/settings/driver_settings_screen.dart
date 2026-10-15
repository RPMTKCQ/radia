import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../widgets/account_card.dart';
import '../../widgets/app_header.dart';
import '../../widgets/logout_button.dart';
import '../../widgets/panel.dart';
import '../../widgets/settings_toggle.dart';
import '../../widgets/text_size_row.dart';
import '../../widgets/observe.dart';

class DriverSettingsScreen extends StatelessWidget {
  const DriverSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => Observe(builder: (context) => Column(children: [
        const AppHeader('Settings'),
        Expanded(
          child: ListView(padding: const EdgeInsets.all(14), children: [
            AccountCard(
                title: 'Driver',
                subtitle: 'No login needed',
                badge: 'DRIVER'),
            const SizedBox(height: 12),
            Panel(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Display & notifications',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                SettingsToggle('Traffic alerts',
                    'Notify me about heavy traffic at intersections.',
                    value: app.alerts, onChanged: (v) => app.alerts = v),
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
            const SizedBox(height: 10),
            Text('Authorized users can sign in again from the welcome screen.',
                textAlign: TextAlign.center,
                style: TextStyle(color: app.muted, fontSize: 12)),
          ]),
        ),
      ]));
}
