import '../models/intersection.dart';
import '../models/log_event.dart';

// The whole system is defined by these 3 intersections (kept small on purpose).
// To add or remove one, edit only this file. Replace with database / camera
// data later.
//
// Intersection(id, north, south, east, west, vehiclesToday, signalAdjusts)
List<Intersection> seedIntersections() => [
      Intersection(1, 5, 6, 14, 11, 4210, 12), // normal traffic
      Intersection(2, 16, 13, 5, 4, 4590, 15), // high volume
      Intersection(3, 0, 0, 0, 0, 0, 0), // idle (flashing yellow)
    ];

List<LogEvent> seedEvents() => [
      LogEvent('09:44:30', 2, 'North', 'DENSITY ADJUST',
          'Extended North-South green by 6 s'),
      LogEvent('09:41:05', 1, 'East', 'DENSITY ADJUST',
          'Extended East-West green by 10 s'),
      LogEvent('09:38:52', 1, 'North', 'DENSITY ADJUST',
          'Extended North-South green by 8 s'),
      LogEvent('09:30:47', 2, 'North', 'DENSITY ADJUST',
          'Switched phase to North-South'),
      LogEvent('09:12:30', 3, 'All', 'IDLE MODE',
          'No vehicles: flashing yellow on all approaches'),
    ];
