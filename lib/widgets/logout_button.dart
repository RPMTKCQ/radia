import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

/// Log out button used by both user types. Asks for confirmation first.
class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  Future<void> _confirm(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Log out?'),
        content: Text(
            app.role == null
                ? ''
                : 'You will return to the welcome screen and can choose how to use Radiant again.',
            style: TextStyle(color: app.muted)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(backgroundColor: AppColors.red),
              child: const Text('Log out')),
        ],
      ),
    );
    if (ok == true) app.logout();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 52,
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _confirm(context),
          icon: const Icon(Icons.logout, color: Colors.white),
          label: const Text('Log out',
              style: TextStyle(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.maroonLight, width: app.border),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
        ),
      );
}
