import 'package:flutter/material.dart';
import '../../models/direction.dart';
import '../../state/app_state.dart';
import 'admin_settings_screen.dart';
import 'driver_settings_screen.dart';

/// Picks the Settings layout for the signed-in user type.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => app.role == Role.admin
      ? const AdminSettingsScreen()
      : const DriverSettingsScreen();
}
