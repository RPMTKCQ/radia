import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/direction.dart';
import '../models/intersection.dart';
import '../models/log_event.dart';

/// Global UI + simulation state. Access through the `app` singleton.
class AppState extends ChangeNotifier {
  Role? role;
  String? userEmail; // set on authorized sign-in
  int tab = 0, selected = 1;
  int? filter; // intersection filter, null = all
  String? typeFilter; // event type filter (admin), null = all
  bool alerts = true, phaseAlerts = true;
  bool highContrast = false, colorBlind = true;
  double textScale = 1.0;
  final _rng = Random();

  final intersections = seedIntersections();
  final events = seedEvents();

  AppState() {
    Timer.periodic(const Duration(seconds: 6), (_) => _tick());
  }

  Intersection get current => intersections.firstWhere((i) => i.id == selected);
  Color get muted => highContrast ? Colors.white : const Color(0xFF9CA3AF);
  double get border => highContrast ? 3 : 2;

  List<LogEvent> get filteredEvents => events
      .where((e) =>
          (filter == null || e.intersection == filter) &&
          (typeFilter == null || e.type == typeFilter))
      .toList();

  String _now() {
    final t = DateTime.now();
    String p(int v) => v.toString().padLeft(2, '0');
    return '${p(t.hour)}:${p(t.minute)}:${p(t.second)}';
  }

  /// Simulated camera input so the prototype feels live.
  void _tick() {
    for (final i in intersections) {
      if (i.idle) continue;
      final before = i.decision;
      for (final d in Dir.values) {
        i.counts[d] = (i.counts[d]! + _rng.nextInt(5) - 2).clamp(0, 20);
      }
      i.vehiclesToday += _rng.nextInt(6) + 2;
      final after = i.decision;
      if (before.nsGreen != after.nsGreen && !after.flashing) {
        i.adjustments++;
        events.insert(
            0,
            LogEvent(_now(), i.id, after.nsGreen ? 'North' : 'East',
                'DENSITY ADJUST',
                'Switched phase to ${after.nsGreen ? 'North-South' : 'East-West'}'));
      }
    }
    notifyListeners();
  }

  void signInAuthorized(String email) {
    role = Role.admin;
    userEmail = email;
    tab = 0;
    notifyListeners();
  }

  void continueAsDriver() {
    role = Role.driver;
    userEmail = null;
    tab = 0;
    notifyListeners();
  }

  /// Ends the session (both user types) and returns to the welcome screen.
  void logout() {
    role = null;
    userEmail = null;
    tab = 0;
    selected = 1;
    filter = null;
    typeFilter = null;
    notifyListeners();
  }

  void update(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}

final app = AppState();
