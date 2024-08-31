import 'package:flutter/material.dart';
import '../models/crew_model.dart';

class AssembledAgentView extends StatelessWidget {
  final AgentModel agent;

  AssembledAgentView({required this.agent});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/head_${agent.headAsset.split('_').last}',
            height: 100),
        Image.asset('assets/body_${agent.bodyAsset.split('_').last}',
            height: 150),
        const SizedBox(height: 20),
        const Text('선택된 도구:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: agent.tools
              .map((tool) => Chip(
                    label: Text(tool['name']!),
                    backgroundColor: Colors.blue[100],
                  ))
              .toList(),
        ),
      ],
    );
  }
}
