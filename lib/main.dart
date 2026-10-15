import 'package:flutter/material.dart';
import 'screens/shell/shell.dart';
import 'screens/welcome/welcome_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

void main() => runApp(const RadiantApp());

class RadiantApp extends StatelessWidget {
  const RadiantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (_, __) => MaterialApp(
        title: 'Radiant',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        builder: (ctx, child) => MediaQuery(
          data: MediaQuery.of(ctx)
              .copyWith(textScaler: TextScaler.linear(app.textScale)),
          child: child!,
        ),
        home: app.role == null ? const WelcomeScreen() : const Shell(),
      ),
    );
  }
}
