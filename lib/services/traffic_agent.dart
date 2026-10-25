import '../models/decision.dart';
import '../models/direction.dart';

/// The agent's decision logic. Edit the green-time rule here only.
///
/// Input: vehicles detected per lane (one camera per lane, 2-4 lanes).
/// North + South lanes share one signal phase, East + West the other.
/// The busier phase gets green; lanes that are not configured count as 0.
class TrafficAgent {
  static const minGreen = 5, yellow = 3, maxGreen = 60;

  static Decision decide(Map<Dir, int> c) {
    final perceive = c.entries.map((e) => '${e.key.short}${e.value}').join(' ');
    int axis(bool ns) =>
        c.entries.where((e) => e.key.isNS == ns).fold(0, (a, e) => a + e.value);
    final ns = axis(true), ew = axis(false);

    if (ns + ew == 0) {
      return Decision(true, true, 0, '$perceive. No vehicles in range.',
          'No demand. Cars get flashing yellow.',
          'Flashing yellow on every approach until a vehicle is detected.');
    }
    final nsBusy = ns > ew;
    final busyTotal = nsBusy ? ns : ew;
    final green = (10 + (busyTotal * 0.9).floor()).clamp(minGreen, maxGreen);
    final busy = nsBusy ? 'North-South' : 'East-West';
    final other = nsBusy ? 'East-West' : 'North-South';
    return Decision(
      nsBusy,
      false,
      green,
      '$perceive.',
      '$busy is busiest (${nsBusy ? ns : ew} vs ${nsBusy ? ew : ns} vehicles), so extend $busy green.',
      '$busy green for $green s, then $yellow s yellow, then $other.',
    );
  }
}
