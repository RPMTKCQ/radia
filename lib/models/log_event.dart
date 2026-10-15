class LogEvent {
  final String time, type, message, lane;
  final int intersection;
  LogEvent(this.time, this.intersection, this.lane, this.type, this.message);
}
