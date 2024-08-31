import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/crew_model.dart';
import '../widgets/collaboration_popup.dart';
import '../widgets/hamburger_view.dart';
import 'agent_screen.dart';

class CrewScreen extends StatelessWidget {
  final List<Offset> chairPositions = [
    Offset(0.35, 0.34),
    Offset(0.35, 0.53),
    Offset(0.62, 0.34),
    Offset(0.62, 0.53),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OrchestrAI'),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          TextButton(
            child: Text('로그인', style: TextStyle(color: Colors.black)),
            onPressed: () {
              // TODO: Implement login functionality
            },
          ),
          TextButton(
            child: Text('회원가입', style: TextStyle(color: Colors.black)),
            onPressed: () {
              // TODO: Implement signup functionality
            },
          ),
        ],
      ),
      drawer: HamburgerView(),
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
              if (crewModel.teamName != null)
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.35,
                  left: MediaQuery.of(context).size.width * 0.5 - 100,
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFF6050DC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        crewModel.teamName!,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ...List.generate(4, (index) {
                return Positioned(
                  left: MediaQuery.of(context).size.width * chairPositions[index].dx,
                  top: MediaQuery.of(context).size.height * chairPositions[index].dy,
                  child: GestureDetector(
                    onTap: () async {
                      if (crewModel.agents[index] == null) {
                        crewModel.addDefaultAgent(index);
                      }
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgentScreen(agentIndex: index),
                        ),
                      );
                      (context as Element).markNeedsBuild();
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // 의자 이미지 또는 placeholder
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        // + 버튼 또는 에이전트 아이콘
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            crewModel.agents[index] == null ? Icons.add : Icons.edit,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        if (crewModel.agents[index] != null)
                          Positioned(
                            bottom: 50,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/body_${crewModel.agents[index]!.bodyAsset}.png',
                                  fit: BoxFit.contain,
                                  height: 80,
                                ),
                                Positioned(
                                  top: -10,
                                  child: Image.asset(
                                    'assets/head_${crewModel.agents[index]!.headAsset}.png',
                                    fit: BoxFit.contain,
                                    height: 40,
                                  ),
                                ),
                                ...crewModel.agents[index]!.tools
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  int toolIndex = entry.key;
                                  return Positioned(
                                    right: toolIndex * 15.0,
                                    bottom: 0,
                                    child: Image.asset(
                                      'assets/tool_${toolIndex + 1}.png',
                                      fit: BoxFit.contain,
                                      height: 25,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        print(
                                            'Error loading tool image: tool_${toolIndex + 1}.png');
                                        return Icon(Icons.build,
                                            size: 25, color: Colors.red);
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
                );
              }),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<CrewModel>(
        builder: (context, crewModel, child) {
          List<AgentModel> activeAgents =
              crewModel.agents.whereType<AgentModel>().toList();

          if (activeAgents.isEmpty) {
            return SizedBox.shrink();
          }

          return Container(
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
                List<AgentModel> activeAgents =
                    crewModel.agents.whereType<AgentModel>().toList();
                if (activeAgents.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CollaborationPopup(agents: activeAgents);
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('에이전트를 먼저 추가해주세요.')),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}