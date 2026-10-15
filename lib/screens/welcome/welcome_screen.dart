import 'package:flutter/material.dart';
import '../../models/direction.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/logo.dart';
import '../auth/sign_in_screen.dart';
import '../../widgets/observe.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Widget _card(String title, String body, String cta, Color border,
      Color ctaBg, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border, width: 2)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(body, style: TextStyle(color: app.muted, height: 1.35)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: ctaBg, borderRadius: BorderRadius.circular(20)),
            child: Text(cta, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Observe(builder: _build);

  Widget _build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Spacer(),
            const Logo(),
            const SizedBox(height: 22),
            const Text('Welcome to Radiant',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('Choose how you want to use the app.',
                style: TextStyle(color: app.muted)),
            const SizedBox(height: 22),
            _card(
                'Authorized user',
                'Traffic personnel and admins. Login required. Full access to the live monitor, event log and settings.',
                'Sign in >',
                AppColors.maroonLight,
                AppColors.maroonLight,
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SignInScreen()))),
            _card(
                'Driver',
                'No login needed. See lane volume summaries and recent signal changes at each intersection.',
                'Continue as driver >',
                Colors.white24,
                AppColors.surface2,
                () => app.update(() {
                      app.role = Role.driver;
                      app.tab = 0;
                    })),
            Text('Radiant for Android',
                style: TextStyle(color: app.muted, fontSize: 12)),
            const Spacer(flex: 2),
          ]),
        ),
      ),
    );
  }
}
