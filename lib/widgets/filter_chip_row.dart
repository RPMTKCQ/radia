import 'package:flutter/material.dart';

/// Horizontally scrollable row of filter chips with a visible scrollbar.
/// Works with touch, mouse drag and trackpad (see AppScrollBehavior in main.dart).
class FilterChipRow extends StatefulWidget {
  final List<Widget> children;
  const FilterChipRow({super.key, required this.children});

  @override
  State<FilterChipRow> createState() => _FilterChipRowState();
}

class _FilterChipRowState extends State<FilterChipRow> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scrollbar(
        controller: _controller,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(children: widget.children),
        ),
      );
}
