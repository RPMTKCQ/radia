import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class _Sample {
  final double t;
  final int count;
  const _Sample(this.t, this.count);
}

/// Vehicles detected in ONE camera's lane for every second of its video,
/// produced by radiant_ai/count_video.py  (assets/counts/cam_0N.json).
/// Format: {"duration": 13.0, "samples": [{"t":0,"count":5}, {"t":1,"count":6}, ...]}
class CountTimeline {
  final List<_Sample> _samples;
  CountTimeline._(this._samples);

  /// Returns null if the file is missing or invalid.
  static Future<CountTimeline?> load(String assetPath) async {
    try {
      final j = jsonDecode(await rootBundle.loadString(assetPath))
          as Map<String, dynamic>;
      final list = (j['samples'] as List).map((e) {
        final m = e as Map<String, dynamic>;
        return _Sample((m['t'] as num).toDouble(), (m['count'] as num).toInt());
      }).toList()
        ..sort((a, b) => a.t.compareTo(b.t));
      return list.isEmpty ? null : CountTimeline._(list);
    } catch (_) {
      return null;
    }
  }

  /// Count at a playback position (latest sample at or before it).
  int at(Duration position) {
    final t = position.inMilliseconds / 1000;
    var cur = _samples.first;
    for (final s in _samples) {
      if (s.t <= t) {
        cur = s;
      } else {
        break;
      }
    }
    return cur.count;
  }
}
