import '../models/intersection.dart';
import '../models/log_event.dart';

// Replace these with database / camera data later.
List<Intersection> seedIntersections() => [
      Intersection(1, 5, 6, 14, 11, 4210, 12),
      Intersection(2, 12, 9, 4, 3, 3680, 9),
      Intersection(3, 16, 13, 5, 4, 4590, 15),
      Intersection(4, 0, 0, 0, 0, 0, 0),
      Intersection(5, 8, 6, 3, 2, 3950, 7),
    ];

List<LogEvent> seedEvents() => [
      LogEvent('09:44:30', 5, 'North', 'DENSITY ADJUST',
          'Extended North-South green by 6 s'),
      LogEvent('09:41:05', 1, 'East', 'DENSITY ADJUST',
          'Extended East-West green by 10 s'),
      LogEvent('09:38:52', 2, 'North', 'DENSITY ADJUST',
          'Extended North-South green by 8 s'),
      LogEvent('09:30:47', 3, 'North', 'DENSITY ADJUST',
          'Switched phase to North-South'),
      LogEvent('09:12:30', 4, 'All', 'IDLE MODE',
          'No vehicles: flashing yellow on all approaches'),
    ];
