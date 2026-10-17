import 'package:flutter/material.dart';
import '../../models/direction.dart';
import '../../services/auth_service.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/logo.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  final pass2 = TextEditingController();
  bool loading = false;
  String? error;

  // Format validation (shown live while typing)
  bool get emailOk => email.text.trim().toLowerCase().endsWith('@tip.edu.ph');
  bool get passOk => pass.text.length >= 8;
  bool get matchOk => pass2.text.isNotEmpty && pass.text == pass2.text;
  bool get valid => emailOk && passOk && matchOk;

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    pass2.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
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
    app.update(() {
      app.role = Role.admin;
      app.userEmail = email.text.trim().toLowerCase();
      app.tab = 0;
    });
    Navigator.popUntil(context, (r) => r.isFirst);
  }

  Widget _field(String label, TextEditingController c,
      {bool? ok, String? good, String? bad, bool obscure = false}) {
    final color =
        ok == null ? Colors.white12 : (ok ? AppColors.green : AppColors.red);
    OutlineInputBorder border() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: 2));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(color: app.muted)),
      const SizedBox(height: 6),
      TextField(
        controller: c,
        obscureText: obscure,
        enabled: !loading,
        keyboardType: obscure ? TextInputType.text : TextInputType.emailAddress,
        onChanged: (_) => setState(() => error = null),
        decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            enabledBorder: border(),
            focusedBorder: border()),
      ),
      if (ok != null)
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(ok ? good! : '! $bad',
              style: TextStyle(
                  color: ok ? AppColors.green : AppColors.red, fontSize: 12)),
        ),
      const SizedBox(height: 14),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(24), children: [
          TextButton.icon(
              onPressed: loading ? null : () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back'),
              style: TextButton.styleFrom(
                  foregroundColor: app.muted, alignment: Alignment.centerLeft)),
          const Logo(),
          const SizedBox(height: 18),
          const Text('Authorized user sign in',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('Admins and traffic personnel', style: TextStyle(color: app.muted)),
          const SizedBox(height: 18),
          _field('Email', email,
              ok: email.text.isEmpty ? null : emailOk,
              good: 'Looks good',
              bad: 'Use your @tip.edu.ph email address'),
          _field('Password', pass,
              obscure: true,
              ok: pass.text.isEmpty ? null : passOk,
              good: 'Password accepted',
              bad: 'Use at least 8 characters'),
          _field('Re-type password', pass2,
              obscure: true,
              ok: pass2.text.isEmpty ? null : matchOk,
              good: 'Passwords match',
              bad: 'Passwords do not match. Re-type to confirm.'),
          if (error != null)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: AppColors.red.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.red)),
              child: Row(children: [
                const Icon(Icons.error_outline, color: AppColors.red, size: 18),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(error!,
                        style: const TextStyle(color: AppColors.red))),
              ]),
            ),
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
          const SizedBox(height: 10),
          Text(
              valid
                  ? 'Fields look valid. Tap Sign in to verify your account.'
                  : 'Fill in every field correctly to sign in.',
              style: TextStyle(color: app.muted, fontSize: 13)),
        ]),
      ),
    );
  }
}
