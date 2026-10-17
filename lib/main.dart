import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/shell/shell.dart';
import 'services/auth_service.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.init(); // load saved accounts
  runApp(const RadiantApp());
}

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
        // Login is the first page; the Shell shows once someone is signed in.
        home: app.role == null ? LoginScreen() : Shell(),
      ),
    );
  }
}
