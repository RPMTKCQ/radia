import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/auth_field.dart';
import '../../widgets/error_banner.dart';
import '../../widgets/logo.dart';

/// Create an authorized-user account, then sign in automatically.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  final pass2 = TextEditingController();
  bool loading = false;
  String? error;

  bool get emailOk => AuthService.emailOk(email.text);
  String? get passIssue => AuthService.passwordIssue(pass.text);
  bool get matchOk => pass2.text.isNotEmpty && pass.text == pass2.text;
  bool get valid => emailOk && passIssue == null && matchOk;

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    pass2.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (!valid || loading) return;
    setState(() {
      loading = true;
      error = null;
    });
    final result = await AuthService.register(email.text, pass.text);
    if (!mounted) return;
    if (!result.ok) {
      setState(() {
        loading = false;
        error = result.error;
      });
      return;
    }
    app.signInAuthorized(email.text.trim().toLowerCase());
    Navigator.popUntil(context, (r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(24), children: [
          TextButton.icon(
              onPressed: loading ? null : () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back to sign in'),
              style: TextButton.styleFrom(
                  foregroundColor: app.muted, alignment: Alignment.centerLeft)),
          const Logo(),
          const SizedBox(height: 18),
          const Text('Create account',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('For admins and traffic personnel',
              style: TextStyle(color: app.muted)),
          const SizedBox(height: 18),
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
            ok: pass.text.isEmpty ? null : passIssue == null,
            good: 'Password accepted',
            bad: passIssue,
            onChanged: (_) => setState(() => error = null),
          ),
          AuthField(
            label: 'Re-type password',
            controller: pass2,
            obscure: true,
            enabled: !loading,
            ok: pass2.text.isEmpty ? null : matchOk,
            good: 'Passwords match',
            bad: 'Passwords do not match. Re-type to confirm.',
            onChanged: (_) => setState(() => error = null),
            onSubmitted: _create,
          ),
          if (error != null) ErrorBanner(error!),
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: (valid && !loading) ? _create : null,
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
                  : const Text('Create account',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 10),
          Text('Password: 8+ characters with at least one letter and one number.',
              style: TextStyle(color: app.muted, fontSize: 13)),
        ]),
      ),
    );
  }
}
