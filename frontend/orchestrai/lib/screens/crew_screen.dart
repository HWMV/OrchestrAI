import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/crew_model.dart';
import '../widgets/collaboration_popup.dart';
import '../widgets/hamburger_view.dart';
import 'agent_screen.dart';

class CrewScreen extends StatelessWidget {
  final List<Offset> chairPositions = [
    Offset(0.5, 0.2), // 상단 중앙
    Offset(0.25, 0.4), // 왼쪽 상단
    Offset(0.75, 0.4), // 오른쪽 상단
    Offset(0.35, 0.6), // 왼쪽 하단
    Offset(0.65, 0.6), // 오른쪽 하단
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
                  top:
                      MediaQuery.of(context).size.height * 0.35, // 책상 위치에 맞게 조정
                  left: MediaQuery.of(context).size.width * 0.5 - 100, // 중앙 정렬
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
              ...List.generate(5, (index) {
                return Positioned(
                  left: MediaQuery.of(context).size.width *
                          chairPositions[index].dx -
                      70,
                  top: MediaQuery.of(context).size.height *
                          chairPositions[index].dy -
                      70,
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
                      // 화면 갱신을 위해 setState 호출
                      (context as Element).markNeedsBuild();
                    },
                    child: SizedBox(
                      width: 140,
                      height: 140,
                      child: Stack(
                        children: [
                          Image.asset('assets/chair.png',
                              width: 140, height: 140),
                          if (crewModel.agents[index] != null)
                            Positioned(
                              bottom: 40,
                              left: 20,
                              right: 20,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/body_${crewModel.agents[index]!.bodyAsset}.png',
                                    fit: BoxFit.contain,
                                    height: 90,
                                  ),
                                  Positioned(
                                    top: -8,
                                    child: Image.asset(
                                      'assets/head_${crewModel.agents[index]!.headAsset}.png',
                                      fit: BoxFit.contain,
                                      height: 45,
                                    ),
                                  ),
                                  ...crewModel.agents[index]!.tools
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    int toolIndex = entry.key;
                                    return Positioned(
                                      right: toolIndex * 20.0,
                                      bottom: 0,
                                      child: Image.asset(
                                        'assets/tool_${toolIndex + 1}.png',
                                        fit: BoxFit.contain,
                                        height: 30,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          print(
                                              'Error loading tool image: tool_${toolIndex + 1}.png');
                                          return Icon(Icons.build,
                                              size: 30, color: Colors.red);
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
      bottomNavigationBar: Consumer<CrewModel>(
        builder: (context, crewModel, child) {
          List<AgentModel> activeAgents =
              crewModel.agents.whereType<AgentModel>().toList();

          if (activeAgents.isEmpty) {
            return SizedBox.shrink(); // 에이전트가 없으면 버튼을 표시하지 않음
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

