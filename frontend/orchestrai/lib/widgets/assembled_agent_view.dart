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
        Image.asset(
          agent.headAsset.isEmpty
              ? 'assets/head_default.png'
              : 'assets/head_${agent.headAsset.split('_').last}',
          height: 100,
          errorBuilder: (context, error, stackTrace) {
            print('Error loading head image: ${error.toString()}');
            return Image.asset('assets/head_default.png', height: 100);
          },
        ),
        Image.asset(
          agent.bodyAsset.isEmpty
              ? 'assets/body_default.png'
              : 'assets/body_${agent.bodyAsset.split('_').last}',
          height: 150,
          errorBuilder: (context, error, stackTrace) {
            print('Error loading body image: ${error.toString()}');
            return Image.asset('assets/body_default.png', height: 150);
          },
        ),
        SizedBox(height: 20),
        Text('선택된 도구:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: agent.tools.isEmpty
              ? [Text('선택된 도구가 없습니다.')]
              : agent.tools
                  .map((tool) => Chip(
                        label: Text(tool),
                        backgroundColor: Colors.blue[100],
                      ))
                  .toList(),
        ),
      ],
    );
  }
}