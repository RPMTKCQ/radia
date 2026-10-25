import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/decision.dart';
import '../models/direction.dart';
import '../models/log_event.dart';

/// Global UI + simulation state. Access through the `app` singleton.
class AppState extends ChangeNotifier {
  Role? role;
  String? userEmail; // set on authorized sign-in
  int tab = 0;
  String? typeFilter; // event type filter (admin), null = all
  bool alerts = true, phaseAlerts = true;
  bool highContrast = false, colorBlind = true;
  double textScale = 1.0;
  final _rng = Random();

  final intersection = seedIntersection();
  final events = seedEvents();

  AppState() {
    Timer.periodic(const Duration(seconds: 6), (_) => _tick());
  }

  Color get muted => highContrast ? Colors.white : const Color(0xFF9CA3AF);
  double get border => highContrast ? 3 : 2;

  List<LogEvent> get filteredEvents =>
      events.where((e) => typeFilter == null || e.type == typeFilter).toList();

  String _now() {
    final t = DateTime.now();
    String p(int v) => v.toString().padLeft(2, '0');
    return '${p(t.hour)}:${p(t.minute)}:${p(t.second)}';
  }

  /// Logs a phase switch if the agent's decision changed after new counts.
  void _recordPhaseChange(Decision before) {
    final x = intersection;
    final after = x.decision;
    if (before.nsGreen != after.nsGreen && !after.flashing && !before.flashing) {
      x.adjustments++;
      final lane = x.lanes.firstWhere((l) => l.isNS == after.nsGreen,
          orElse: () => x.lanes.first);
      events.insert(
          0,
          LogEvent(_now(), lane.label, 'DENSITY ADJUST',
              'Switched phase to ${after.nsGreen ? 'North-South' : 'East-West'}'));
    }
  }

  /// New vehicle count for ONE lane, from that camera's detector (see CameraFeed).
  void applyCounts(Dir lane, int count) {
    final before = intersection.decision;
    intersection.counts[lane] = count;
    _recordPhaseChange(before);
    notifyListeners();
  }

  /// Simulated counts for lanes whose camera has no AI counts file.
  void _tick() {
    final x = intersection;
    if (!x.idle) {
      final before = x.decision;
      for (final l in x.lanes) {
        if (x.videoDriven.contains(l)) continue;
        x.counts[l] = (x.counts[l]! + _rng.nextInt(5) - 2).clamp(0, 20);
      }
      _recordPhaseChange(before);
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

  /// Ends the session (both user types) and returns to the login screen.
  void logout() {
    role = null;
    userEmail = null;
    tab = 0;
    typeFilter = null;
    notifyListeners();
  }

  void update(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}

final app = AppState();
