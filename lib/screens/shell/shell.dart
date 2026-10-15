import 'package:flutter/material.dart';
import '../../models/direction.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/observe.dart';
import '../event_log/event_log_screen.dart';
import '../monitor/monitor_screen.dart';
import '../settings/settings_screen.dart';

/// Bottom-navigation container. Drivers do not get the Monitor tab.
class Shell extends StatelessWidget {
  const Shell({super.key});

  @override
  Widget build(BuildContext context) => Observe(builder: _build);

  Widget _build(BuildContext context) {
    final admin = app.role == Role.admin;
    final pages = <Widget>[
      if (admin) MonitorScreen(),
      EventLogScreen(),
      SettingsScreen(),
    ];
    final items = <BottomNavigationBarItem>[
      if (admin)
        const BottomNavigationBarItem(
            icon: Icon(Icons.videocam_outlined), label: 'Monitor'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.list_rounded), label: 'Event Log'),
      const BottomNavigationBarItem(icon: Icon(Icons.tune), label: 'Settings'),
    ];
    final idx = app.tab.clamp(0, pages.length - 1);
    return Scaffold(
      body: pages[idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: idx,
        items: items,
        backgroundColor: AppColors.surface,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.yellow,
        unselectedItemColor: app.muted,
        onTap: (i) => app.update(() => app.tab = i),
      ),
    );
  }
}
