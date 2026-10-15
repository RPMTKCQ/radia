import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

/// Rounded dark card used across all screens.
class Panel extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  final EdgeInsets padding;
  const Panel(
      {super.key,
      required this.child,
      this.borderColor,
      this.padding = const EdgeInsets.all(14)});

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: borderColor == null
              ? null
              : Border.all(color: borderColor!, width: app.border),
        ),
        child: child,
      );
}
