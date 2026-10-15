import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Filter chip used in the Event Log.
class AppChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const AppChip(this.label,
      {super.key, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          selectedColor: AppColors.maroonLight,
          backgroundColor: AppColors.surface,
          showCheckmark: false,
          onSelected: (_) => onTap(),
        ),
      );
}
