import '../models/direction.dart';
import '../models/intersection.dart';
import '../models/log_event.dart';

// ---------------------------------------------------------------------------
// THE WHOLE SETUP IS DEFINED HERE.
//
// One intersection, 2 to 4 cameras, each camera looks at ONE lane.
//   camera 1 -> first lane in the list   (assets/videos/cam_01.mp4, assets/counts/cam_01.json)
//   camera 2 -> second lane              (cam_02 ...)
//   camera 3 -> third lane               (cam_03 ...)
//   camera 4 -> fourth lane              (cam_04 ...)   (4 is the maximum)
// North + South share one signal phase, East + West the other.
// ---------------------------------------------------------------------------
// 4 cameras: camera 1 = North, 2 = East, 3 = South, 4 = West.
// Reorder or remove entries so each camera's lane matches what its video shows.
const activeLanes = [Dir.north, Dir.east, Dir.south, Dir.west];

Intersection seedIntersection() => Intersection(
      name: 'Intersection 01',
      lanes: activeLanes,
      // starting numbers until a video / AI counts file takes over
      initial: {Dir.north: 5, Dir.south: 6, Dir.east: 14, Dir.west: 11},
      adjustments: 12,
    );

List<LogEvent> seedEvents() => [
      LogEvent('09:44:30', 'North', 'DENSITY ADJUST',
          'Extended North-South green by 6 s'),
      LogEvent('09:41:05', 'East', 'DENSITY ADJUST',
          'Extended East-West green by 10 s'),
      LogEvent('09:38:52', 'North', 'DENSITY ADJUST',
          'Extended North-South green by 8 s'),
      LogEvent('09:30:47', 'East', 'DENSITY ADJUST',
          'Switched phase to East-West'),
      LogEvent('09:12:30', 'All', 'IDLE MODE',
          'No vehicles: flashing yellow on all approaches'),
    ];
