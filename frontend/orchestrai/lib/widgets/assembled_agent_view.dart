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
        Stack(
          alignment: Alignment.topCenter,
          children: [
            // Body (Task) image
            Image.asset(
              agent.bodyAsset.isEmpty
                  ? 'assets/body_default.png'
                  : 'assets/body_${agent.bodyAsset.split('_').last}',
              height: 120,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading body image: ${error.toString()}');
                return Image.asset('assets/body_default.png', height: 120);
              },
            ),
            // Head image
            Positioned(
              top: -15,
              child: Image.asset(
                agent.headAsset.isEmpty
                    ? 'assets/head_default.png'
                    : 'assets/head_${agent.headAsset.split('_').last}',
                height: 60,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading head image: ${error.toString()}');
                  return Image.asset('assets/head_default.png', height: 60);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text('선택된 도구:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Container(
          width: 160,
          height: 160,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: index < agent.tools.length
                    ? Image.asset(
                        'assets/tool_${index + 1}.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading tool image: ${error.toString()}');
                          return Icon(Icons.build, color: Colors.grey);
                        },
                      )
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}