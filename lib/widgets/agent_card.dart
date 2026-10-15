import 'package:flutter/material.dart';
import '../models/decision.dart';
import '../services/traffic_agent.dart';
import '../theme/app_theme.dart';
import 'panel.dart';
import 'pill.dart';

/// Shows the agent's PERCEIVE / DECIDE / ACT reasoning.
class AgentCard extends StatelessWidget {
  final Decision d;
  const AgentCard(this.d, {super.key});

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
              width: 76,
              child: Text(k,
                  style: const TextStyle(
                      color: AppColors.yellow,
                      fontSize: 11,
                      fontWeight: FontWeight.w800))),
          Expanded(child: Text(v, style: const TextStyle(height: 1.3))),
        ]),
      );

  @override
  Widget build(BuildContext context) => Panel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Expanded(
                child: Text('Intelligent Agent',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
            const Pill('ACTIVE',
                color: AppColors.maroonLight, fg: Colors.white),
          ]),
          const SizedBox(height: 10),
          _row('PERCEIVE', d.perceive),
          _row('DECIDE', d.decide),
          _row('ACT', d.act),
          Row(children: [
            Pill('Min green ${TrafficAgent.minGreen} s',
                color: AppColors.surface2, fg: Colors.white),
            const SizedBox(width: 8),
            Pill('Yellow ${TrafficAgent.yellow} s', color: AppColors.yellow),
          ]),
        ]),
      );
}
