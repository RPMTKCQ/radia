import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

/// Text field with live green / red validation, used by login and sign-up.
class AuthField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure, enabled;
  final bool? ok; // null = untouched, true = valid, false = invalid
  final String? good, bad;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;
  const AuthField(
      {super.key,
      required this.label,
      required this.controller,
      this.obscure = false,
      this.enabled = true,
      this.ok,
      this.good,
      this.bad,
      this.onChanged,
      this.onSubmitted});

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  late bool _hidden = widget.obscure;

  @override
  Widget build(BuildContext context) {
    final ok = widget.ok;
    final color =
        ok == null ? Colors.white12 : (ok ? AppColors.green : AppColors.red);
    OutlineInputBorder border() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: 2));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(widget.label, style: TextStyle(color: app.muted)),
      const SizedBox(height: 6),
      TextField(
        controller: widget.controller,
        obscureText: _hidden,
        enabled: widget.enabled,
        keyboardType:
            widget.obscure ? TextInputType.text : TextInputType.emailAddress,
        onChanged: widget.onChanged,
        onSubmitted: (_) => widget.onSubmitted?.call(),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.surface,
          enabledBorder: border(),
          focusedBorder: border(),
          suffixIcon: widget.obscure
              ? IconButton(
                  icon: Icon(_hidden ? Icons.visibility_off : Icons.visibility,
                      size: 20),
                  onPressed: () => setState(() => _hidden = !_hidden),
                )
              : null,
        ),
      ),
      if (ok != null)
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(ok ? (widget.good ?? '') : '! ${widget.bad ?? ''}',
              style: TextStyle(color: color, fontSize: 12)),
        ),
      const SizedBox(height: 14),
    ]);
  }
}
