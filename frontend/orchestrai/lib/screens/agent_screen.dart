import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/crew_model.dart';


class AgentScreen extends StatefulWidget {
  final int agentIndex;

  AgentScreen({required this.agentIndex});

  @override
  _AgentScreenState createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen> {
  String selectedCategory = '';
  late AgentModel agent;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      agent = Provider.of<CrewModel>(context, listen: false)
          .agents[widget.agentIndex];
      setState(() {});
    });
  }

  @override
Widget build(BuildContext context) {
  return Consumer<CrewModel>(
    builder: (context, crewModel, child) {
      agent = crewModel.agents[widget.agentIndex];
      return Scaffold(
        appBar: AppBar(
          title: Text('AI에이전트를 만들어보세요'),
        ),
        body: Row(
          children: [
            // 왼쪽 사이드바: 조립된 에이전트 표시
            Expanded(
              flex: 1,
              child: AssembledAgentView(agent: agent),
            ),
            // 중앙 및 오른쪽: 카테고리 선택 및 옵션 표시
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  // 카테고리 선택 영역
                  CategorySelectionView(
                    onCategorySelected: (category) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                  // 선택된 카테고리의 옵션 표시 영역
                  Expanded(
                    child: selectedCategory.isNotEmpty
                        ? ComponentSelectionView(
                            part: selectedCategory,
                            optionCount: selectedCategory == '머리' ? 4 : 8,
                            selectedTools: agent.tools,  // 여기에 agent.tools를 전달
                            onAssetChanged: (asset) {
                              setState(() {
                                switch (selectedCategory) {
                                  case '머리':
                                    agent.headAsset = asset;
                                    break;
                                  case '태스크':
                                    agent.bodyAsset = asset;
                                    break;
                                  case '도구':
                                    _toggleTool(asset);  // 도구 선택 시 _toggleTool 호출
                                    break;
                                }
                              });
                              crewModel.updateAgent(agent);
                            },
                          )
                        : Center(child: Text('카테고리를 선택해주세요')),
                  ),
                ],
              ),
            ),
            // 오른쪽 사이드바: 파라미터 설정
            Expanded(
              flex: 1,
              child: ParameterSettingsView(
                agent: agent,
                selectedPart: selectedCategory,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            if (_validateAgent()) {
              _completeAgentCreation(crewModel);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('모든 필수 필드를 채워주세요')),
              );
            }
          },
        ),
      );
    },
  );
}

  //이부분 새로 추가함
  void _toggleTool(String assetName) {
  setState(() {
    int index = agent.tools.indexWhere((tool) => tool.name == assetName);
    if (index != -1) {
      // 이미 선택된 도구라면 제거
      agent.tools.removeAt(index);
    } else if (agent.tools.length < 4) {
      // 새로운 도구이고 4개 미만이라면 추가
      agent.tools.add(Tool(name: assetName));
    }
  });
}

  bool _validateAgent() {
    return agent.name.isNotEmpty &&
        agent.role.isNotEmpty &&
        agent.goal.isNotEmpty &&
        agent.task.name.isNotEmpty &&
        agent.tools.isNotEmpty;
  }

  void _completeAgentCreation(CrewModel crewModel) {
    crewModel.updateAgent(agent);
    // 추가적인 완료 로직 구현 가능
  }
}

class CategorySelectionView extends StatelessWidget {
  final Function(String) onCategorySelected;

  CategorySelectionView({required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15, // 화면 높이의 15%로 설정
      child: Row(
        children: [
          _buildCategoryButton(context, '머리', 'assets/head_default.png'),
          _buildCategoryButton(context, '태스크', 'assets/body_default.png'),
          _buildCategoryButton(context, '도구', 'assets/tool_default.png'),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, String category, String assetPath) {
    return Expanded(
      child: InkWell(
        onTap: () => onCategorySelected(category),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.contain, // 이미지가 공간에 맞게 조정되도록 설정
                ),
              ),
              SizedBox(height: 4),
              Text(category, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

// class AssembledAgentView extends StatelessWidget {
//   final AgentModel agent;

//   AssembledAgentView({required this.agent});

//   String _getAssetPrefix(String part) {
//     switch (part) {
//       case '머리':
//         return 'head';
//       case '태스크':
//         return 'body';
//       case '도구':
//         return 'tool';
//       default:
//         return part.toLowerCase();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Image.asset('assets/${_getAssetPrefix("머리")}_${agent.headAsset}.png', height: 200),
//         Image.asset('assets/${_getAssetPrefix("태스크")}_${agent.bodyAsset}.png', height: 200),
//         Image.asset('assets/${_getAssetPrefix("도구")}_${agent.toolAsset}.png', height: 200),
//       ],
//     );
//   }
// }


class AssembledAgentView extends StatelessWidget {
  final AgentModel agent;

  AssembledAgentView({required this.agent});

  String _getAssetPrefix(String part) {
    switch (part) {
      case '머리':
        return 'head';
      case '태스크':
        return 'body';
      case '도구':
        return 'tool';
      default:
        return part.toLowerCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/${_getAssetPrefix("머리")}_${agent.headAsset}.png', height: 150),
        Image.asset('assets/${_getAssetPrefix("태스크")}_${agent.bodyAsset}.png', height: 150),
        SizedBox(height: 20),
        Text('선택된 도구 (1-4):', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildToolBox(context, 0),
            SizedBox(width: 10),
            _buildToolBox(context, 1),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildToolBox(context, 2),
            SizedBox(width: 10),
            _buildToolBox(context, 3),
          ],
        ),
      ],
    );
  }

  Widget _buildToolBox(BuildContext context, int index) {
    bool hasToolAtIndex = agent.tools.length > index;
    Tool? tool = hasToolAtIndex ? agent.tools[index] : null;

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: hasToolAtIndex ? Colors.yellow[100] : Colors.grey[200],
      ),
      child: hasToolAtIndex
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildToolImage(tool!),
                Text(
                  tool.name,
                  style: TextStyle(fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
          : Center(
              child: Text(
                index == 0 && agent.tools.isEmpty ? 'Required' : 'Optional',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  Widget _buildToolImage(Tool tool) {
    String imageAsset = 'assets/tool_${tool.name}.png';

    return Image.asset(
      imageAsset,
      height: 50,
      width: 50,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.build, size: 50); // 이미지 로드 실패 시 기본 아이콘
      },
    );
  }
}


class ComponentSelectionView extends StatelessWidget {
  final String part;
  final int optionCount;
  final List<Tool> selectedTools;
  final Function(String) onAssetChanged;

  ComponentSelectionView({
    required this.part,
    required this.optionCount,
    required this.selectedTools,
    required this.onAssetChanged,
  });

  String _getAssetPrefix(String part) {
    switch (part) {
      case '머리':
        return 'head';
      case '태스크':
        return 'body';
      case '도구':
        return 'tool';
      default:
        return part.toLowerCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
      ),
      itemCount: optionCount,
      itemBuilder: (context, index) {
        String assetPrefix = _getAssetPrefix(part);
        String assetName = '${index + 1}';
        bool isSelected = part == '도구' && selectedTools.any((tool) => tool.name == assetName);
        
        return GestureDetector(
          onTap: () => onAssetChanged(assetName),
          child: Card(
            color: isSelected ? Colors.yellow[100] : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/${assetPrefix}_${index + 1}.png', height: 100),
                Text('옵션 ${index + 1}'),
                if (isSelected) Icon(Icons.check, color: Colors.green),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ParameterSettingsView extends StatelessWidget {
  final AgentModel agent;
  final String selectedPart;

  ParameterSettingsView({required this.agent, required this.selectedPart});

  @override
  Widget build(BuildContext context) {
    String title = '${selectedPart.isNotEmpty ? selectedPart : "컴포넌트"} 세부사항 설정';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        TextField(
          decoration: InputDecoration(labelText: '${selectedPart.isNotEmpty ? selectedPart : "컴포넌트"} 설명'),
          onChanged: (value) {
            // 여기에 선택된 부분에 대한 설명 업데이트 로직 추가
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: '예상결과'),
          onChanged: (value) {
            // 여기에 예상 결과 업데이트 로직 추가
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: '아웃풋파일'),
          onChanged: (value) {
            // 여기에 이후풋파일 업데이트 로직 추가
          },
        ),
      ],
    );
  }
}