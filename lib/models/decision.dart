/// Result of one PERCEIVE -> DECIDE -> ACT cycle of the traffic agent.
class Decision {
  final bool nsGreen, flashing;
  final int greenSeconds;
  final String perceive, decide, act;
  const Decision(this.nsGreen, this.flashing, this.greenSeconds, this.perceive,
      this.decide, this.act);
}
