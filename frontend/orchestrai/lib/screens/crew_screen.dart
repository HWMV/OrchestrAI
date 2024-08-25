import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/crew_model.dart';
import 'agent_screen.dart';

class CrewScreen extends StatelessWidget {
  final List<Offset> chairPositions = [
    Offset(0.35, 0.35),  // 왼쪽 상단
    Offset(0.62, 0.35),  // 오른쪽 상단
    Offset(0.35, 0.55),  // 왼쪽 하단
    Offset(0.62, 0.55),  // 오른쪽 하단
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OrchestrAI')),
      body: Consumer<CrewModel>(
        builder: (context, crewModel, child) {
          return Stack(
            children: [
              Image.asset(
                'assets/main.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              ...List.generate(4, (index) {
                return Positioned(
                  left: MediaQuery.of(context).size.width *
                      chairPositions[index].dx - 70,
                  top: MediaQuery.of(context).size.height *
                      chairPositions[index].dy - 70,
                  child: GestureDetector(
                    onTap: () async {
                      if (index < crewModel.agents.length) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AgentScreen(agentIndex: index),
                          ),
                        );
                      } else if (crewModel.agents.length < 4) {
                        crewModel.addAgent(AgentModel(
                          name: "New Agent ${crewModel.agents.length + 1}",
                          role: "New Role",
                          goal: "New Goal",
                          headAsset: 'default',
                          bodyAsset: 'default',
                          toolAsset: 'default',
                          task: Task(name: "New Task"),
                          tools: [],
                        ));
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AgentScreen(
                                agentIndex: crewModel.agents.length - 1),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Maximum number of agents reached')),
                        );
                      }
                    },
                    child: SizedBox(
                      width: 140,
                      height: 140,
                      child: Stack(
                        children: [
                          Image.asset('assets/chair.png', width: 140, height: 140),
                          if (index < crewModel.agents.length)
                            Positioned(
                              bottom: 40,
                              left: 20,
                              right: 20,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/body_${crewModel.agents[index].bodyAsset}.png',
                                    fit: BoxFit.contain,
                                    height: 90,
                                  ),
                                  Positioned(
                                    top: -8,
                                    child: Image.asset(
                                      'assets/head_${crewModel.agents[index].headAsset}.png',
                                      fit: BoxFit.contain,
                                      height: 45,
                                    ),
                                  ),
                                  ...crewModel.agents[index].tools.asMap().entries.map((entry) {
                                    int toolIndex = entry.key;
                                    return Positioned(
                                      right: toolIndex * 20.0,
                                      bottom: 0,
                                      child: Image.asset(
                                        'assets/tool_${toolIndex + 1}.png',
                                        fit: BoxFit.contain,
                                        height: 30,
                                        errorBuilder: (context, error, stackTrace) {
                                          print('Error loading tool image: tool_${toolIndex + 1}.png');
                                          return Icon(Icons.build, size: 30, color: Colors.red);
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
  padding: EdgeInsets.all(16),
  child: ElevatedButton(
    child: Text(
      '협업 시작',
      style: TextStyle(fontSize: 18),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    onPressed: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '협업이 시작되었습니다!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '에이전트들이 작업을 수행하고 있습니다...',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    child: Text('결과물 확인'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  ),
),
    );
  }
}