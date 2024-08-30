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
      appBar: AppBar(
        title: Text('OrchestrAI'),
        centerTitle: true,
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
                  top: MediaQuery.of(context).size.height * 0.35, // 책상 위치에 맞게 조정
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
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ...List.generate(5, (index) {
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
                        crewModel.addDefaultAgent(); 
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CollaborationPopup(agents: crewModel.agents);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class CollaborationPopup extends StatefulWidget {
  final List<AgentModel> agents;

  CollaborationPopup({required this.agents});

  @override
  _CollaborationPopupState createState() => _CollaborationPopupState();
}

class _CollaborationPopupState extends State<CollaborationPopup> {
  late List<AgentModel> _agents;

  @override
  void initState() {
    super.initState();
    _agents = List.from(widget.agents);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text('실행 순서 설정', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Expanded(
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final AgentModel item = _agents.removeAt(oldIndex);
                    _agents.insert(newIndex, item);
                  });
                },
                children: _agents.map((agent) => AgentListItem(
                  key: ValueKey(agent),
                  agent: agent,
                )).toList(),
              ),
            ),
            Text('드래그하여 순서를 변경할 수 있습니다.', style: TextStyle(fontStyle: FontStyle.italic)),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('협업 실행'),
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CollaborationChatScreen(
                      crew: Provider.of<CrewModel>(context, listen: false),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AgentListItem extends StatelessWidget {
  final AgentModel agent;

  AgentListItem({required Key key, required this.agent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Icon(Icons.drag_handle),
        title: Text(agent.name),
        subtitle: Text('태스크: ${agent.task.name}'),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}