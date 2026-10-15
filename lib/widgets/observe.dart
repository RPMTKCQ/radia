import 'package:flutter/material.dart';
import '../state/app_state.dart';

/// Rebuilds its child whenever [app] changes (tab, filters, settings, live data).
/// Wrap every screen's build in this so taps actually update the UI.
class Observe extends StatelessWidget {
  final WidgetBuilder builder;
  const Observe({super.key, required this.builder});

  @override
  Widget build(BuildContext context) =>
      ListenableBuilder(listenable: app, builder: (ctx, _) => builder(ctx));
}
