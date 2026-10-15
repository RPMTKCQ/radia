import 'package:flutter/material.dart';
import '../../models/direction.dart';
import '../../state/app_state.dart';
import 'admin_event_log_screen.dart';
import 'driver_event_log_screen.dart';

/// Picks the Event Log layout for the signed-in user type.
class EventLogScreen extends StatelessWidget {
  const EventLogScreen({super.key});

  @override
  Widget build(BuildContext context) => app.role == Role.admin
      ? const AdminEventLogScreen()
      : const DriverEventLogScreen();
}
