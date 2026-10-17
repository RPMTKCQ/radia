import 'package:flutter/material.dart';
import 'screens/shell/shell.dart';
import 'screens/welcome/welcome_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

void main() => runApp(const RadiantApp());

/// Max width of the app column. On fullscreen / desktop / tablet windows the
/// UI stays phone-proportioned and centered instead of stretching.
const double kMaxAppWidth = 480;

class RadiantApp extends StatelessWidget {
  const RadiantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (_, _) => MaterialApp(
        title: 'Radiant',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        builder: (ctx, child) => MediaQuery(
          data: MediaQuery.of(ctx)
              .copyWith(textScaler: TextScaler.linear(app.textScale)),
          child: ColoredBox(
            color: Colors.black,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: kMaxAppWidth),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    border: Border.symmetric(
                        vertical: BorderSide(color: Colors.white12)),
                  ),
                  child: ClipRect(child: child!),
                ),
              ),
            ),
          ),
        ),
        home: app.role == null ? WelcomeScreen() : Shell(),
      ),
    );
  }
}
