enum Role { admin, driver }

enum Dir { north, south, east, west }

extension DirX on Dir {
  String get label => name[0].toUpperCase() + name.substring(1);
  String get short => label[0];
  bool get isNS => this == Dir.north || this == Dir.south;
}
