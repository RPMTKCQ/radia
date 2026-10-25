import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/auth_field.dart';
import '../../widgets/error_banner.dart';
import '../../widgets/logo.dart';
import 'signup_screen.dart';

/// First screen of the app: authorized-user login.
/// Under the password there is a "Create account" link; drivers can skip login.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  bool loading = false;
  String? error;

  bool get emailOk => AuthService.emailOk(email.text);
  bool get valid => emailOk && pass.text.isNotEmpty;

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!valid || loading) return;
    setState(() {
      loading = true;
      error = null;
    });
    final result = await AuthService.login(email.text, pass.text);
    if (!mounted) return;
    if (!result.ok) {
      setState(() {
        loading = false;
        error = result.error;
      });
      return;
    }
    app.signInAuthorized(email.text.trim().toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(24), children: [
          const SizedBox(height: 24),
          const Logo(),
          const SizedBox(height: 22),
          const Text('Authorized user sign in',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('Admins and traffic personnel',
              style: TextStyle(color: app.muted)),
          const SizedBox(height: 22),
          AuthField(
            label: 'Email',
            controller: email,
            enabled: !loading,
            ok: email.text.isEmpty ? null : emailOk,
            good: 'Looks good',
            bad: 'Use your @tip.edu.ph email address',
            onChanged: (_) => setState(() => error = null),
          ),
          AuthField(
            label: 'Password',
            controller: pass,
            obscure: true,
            enabled: !loading,
            onChanged: (_) => setState(() => error = null),
            onSubmitted: _signIn,
          ),
          // Create account link, directly under the password field
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text("Don't have an account?",
                    style: TextStyle(color: app.muted)),
                TextButton(
                  onPressed: loading
                      ? null
                      : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignUpScreen())),
                  child: const Text('Create account',
                      style: TextStyle(
                          color: AppColors.yellow, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          if (error != null) ErrorBanner(error!),
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: (valid && !loading) ? _signIn : null,
              style: FilledButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: AppColors.surface2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: Colors.black))
                  : const Text('Sign in',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 22),
          Row(children: [
            const Expanded(child: Divider(color: Colors.white12)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('or', style: TextStyle(color: app.muted)),
            ),
            const Expanded(child: Divider(color: Colors.white12)),
          ]),
          const SizedBox(height: 16),
          SizedBox(
            height: 52,
            child: OutlinedButton(
              onPressed: loading ? null : app.continueAsDriver,
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24, width: 2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: const Text('Continue as driver (no login)',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ]),
      ),
    );
  }
}
