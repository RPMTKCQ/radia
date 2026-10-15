import '../models/decision.dart';
import '../models/direction.dart';

/// The agent's decision logic. Edit the green-time rule here only.
class TrafficAgent {
  static const minGreen = 5, yellow = 3, maxGreen = 60;

  static Decision decide(Map<Dir, int> c) {
    final perceive = Dir.values.map((d) => '${d.short}${c[d]}').join(' ');
    final ns = c[Dir.north]! + c[Dir.south]!;
    final ew = c[Dir.east]! + c[Dir.west]!;
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
