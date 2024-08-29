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

  void _toggleTool(String assetName) {
  setState(() {
    int index = agent.tools.indexWhere((tool) => tool.name == assetName);
    if (index != -1) {
      agent.tools.removeAt(index);
    } else if (agent.tools.length < 4) {
      agent.tools.add(Tool(name: assetName));
    }
    // agent 객체 업데이트
    Provider.of<CrewModel>(context, listen: false).updateAgent(agent);
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
  void _updateAgentAsset(String asset, String category) {
    setState(() {
      switch (category) {
        case '머리':
          agent.headAsset = asset;
          break;
        case '태스크':
          agent.bodyAsset = asset;
          break;
      }
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
              Expanded(
                flex: 1,
                child: Consumer<CrewModel>(
                  builder: (context, crewModel, child) {
                    return AssembledAgentView(agent: crewModel.agents[widget.agentIndex]);
                  },
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    CategorySelectionView(
                      onCategorySelected: (category) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                    ),
                    Expanded(
                      child: selectedCategory.isNotEmpty
                          ? ComponentSelectionView(
                              part: selectedCategory,
                              optionCount: selectedCategory == '머리' ? CrewModel.predefinedAgentNames.length : 
                                           (selectedCategory == '태스크' ? CrewModel.predefinedTaskNames.length : 
                                           CrewModel.predefinedToolNames.length),
                              selectedTools: agent.tools,
                              selectedHead: agent.name,
                              selectedTask: agent.task.name,
                              onAssetChanged: (asset) {
                                setState(() {
                                  switch (selectedCategory) {
                                    case '머리':
                                      agent.name = asset;
                                      _updateAgentAsset(_getAssetName(asset, '머리'), '머리');
                                      // 기본값 설정
                                      var details = CrewModel.predefinedAgentDetails[asset] ?? {};
                                      agent.role = details['role'] ?? '';
                                      agent.goal = details['goal'] ?? '';
                                      agent.backstory = details['backstory'] ?? '';
                                      break;
                                    case '태스크':
                                      agent.task.name = asset;
                                      _updateAgentAsset(_getAssetName(asset, '태스크'), '태스크');
                                      break;
                                    case '도구':
                                      _toggleTool(asset);
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
  String _getAssetName(String option, String part) {
    List<String> options = part == '머리' ? CrewModel.predefinedAgentNames : CrewModel.predefinedTaskNames;
    int index = options.indexOf(option) + 1;
    return index.toString();
  }
}



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
        Image.asset('assets/head_${agent.headAsset}.png', height: 150),
        Image.asset('assets/body_${agent.bodyAsset}.png', height: 150),
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
          ? _buildToolImage(tool!)
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imageAsset,
          height: 50,
          width: 50,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.build, size: 50); // 이미지 로드 실패 시 기본 아이콘
          },
        ),
        SizedBox(height: 4),
        Text(
          tool.name,
          style: TextStyle(fontSize: 10),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
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

class ComponentSelectionView extends StatelessWidget {
  final String part;
  final int optionCount;
  final List<Tool> selectedTools;
  final String selectedHead;
  final String selectedTask;
  final Function(String) onAssetChanged;

  ComponentSelectionView({
    required this.part,
    required this.optionCount,
    required this.selectedTools,
    required this.selectedHead,
    required this.selectedTask,
    required this.onAssetChanged,
  });

  String _getAssetName(String option, String part) {
    List<String> options = _getOptionsForPart();
    int index = options.indexOf(option) + 1;

    switch (part) {
      case '머리':
      case '도구':
        return index.toString();
      case '태스크':
        return index <= 2 ? index.toString() : (index + 1).toString();
      default:
        return '1';
    }
  }

  List<String> _getOptionsForPart() {
    switch (part) {
      case '머리':
        return CrewModel.predefinedAgentNames;
      case '태스크':
        return CrewModel.predefinedTaskNames;
      case '도구':
        return CrewModel.predefinedToolNames;
      default:
        return [];
    }
  }

  String _getAssetPath(String option, String part) {
    String assetNumber = _getAssetName(option, part);
    String assetPrefix = part.toLowerCase();
    if (part == '머리') assetPrefix = 'head';
    if (part == '태스크') assetPrefix = 'body';
    if (part == '도구') assetPrefix = 'tool';

    return 'assets/${assetPrefix}_$assetNumber.png';
  }

  bool _isSelected(String option) {
    switch (part) {
      case '머리':
        return option == selectedHead;
      case '태스크':
        return option == selectedTask;
      case '도구':
        return selectedTools.any((tool) => tool.name == option);
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = _getOptionsForPart();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1, // 정사각형 유지
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        String option = options[index];
        bool isSelected = _isSelected(option);
        String assetPath = _getAssetPath(option, part);

        return GestureDetector(
          onTap: () => onAssetChanged(option),
          child: Card(
            color: isSelected ? Colors.yellow[100] : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Image.asset(
                      assetPath,
                      height: 100, // 이미지 크기 조정
                      width: 100,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading image: $assetPath');
                        return Icon(Icons.error, size: 60, color: Colors.red);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0), // 하단 여백 추가
                  child: Text(
                    option,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isSelected) 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Icon(Icons.check, color: Colors.green, size: 16),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}




class ParameterSettingsView extends StatefulWidget {
  final AgentModel agent;
  final String selectedPart;

  ParameterSettingsView({required this.agent, required this.selectedPart});

  @override
  _ParameterSettingsViewState createState() => _ParameterSettingsViewState();
}

class _ParameterSettingsViewState extends State<ParameterSettingsView> {
  late TextEditingController _roleController;
  late TextEditingController _goalController;
  late TextEditingController _backstoryController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    var details = CrewModel.predefinedAgentDetails[widget.agent.name] ?? {};
    _roleController = TextEditingController(text: widget.agent.role.isEmpty ? details['role'] ?? '' : widget.agent.role);
    _goalController = TextEditingController(text: widget.agent.goal.isEmpty ? details['goal'] ?? '' : widget.agent.goal);
    _backstoryController = TextEditingController(text: widget.agent.backstory.isEmpty ? details['backstory'] ?? '' : widget.agent.backstory);
  }

  @override
  void didUpdateWidget(ParameterSettingsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.agent.name != widget.agent.name) {
      _initializeControllers();
    }
  }

  @override
  void dispose() {
    _roleController.dispose();
    _goalController.dispose();
    _backstoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = '${widget.selectedPart.isNotEmpty ? widget.selectedPart : "컴포넌트"} 세부사항 설정';
    String selectedName = '';

    switch (widget.selectedPart) {
      case '머리':
        selectedName = widget.agent.name;
        break;
      case '태스크':
        selectedName = widget.agent.task.name;
        break;
      case '도구':
        selectedName = widget.agent.tools.isNotEmpty ? widget.agent.tools.last.name : '선택된 도구 없음';
        break;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 20),
            Text('선택된 ${widget.selectedPart}: $selectedName', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 20),
            if (widget.selectedPart == '머리') ...[
              TextField(
                controller: _roleController,
                decoration: InputDecoration(labelText: '역할'),
                onChanged: (value) {
                  widget.agent.role = value;
                  Provider.of<CrewModel>(context, listen: false).updateAgent(widget.agent);
                },
              ),
              TextField(
                controller: _goalController,
                decoration: InputDecoration(labelText: '목표'),
                onChanged: (value) {
                  widget.agent.goal = value;
                  Provider.of<CrewModel>(context, listen: false).updateAgent(widget.agent);
                },
              ),
              TextField(
                controller: _backstoryController,
                decoration: InputDecoration(labelText: '배경 이야기'),
                maxLines: 3,
                onChanged: (value) {
                  widget.agent.backstory = value;
                  Provider.of<CrewModel>(context, listen: false).updateAgent(widget.agent);
                },
              ),
            ] else if (widget.selectedPart == '태스크') ...[
              TextField(
                controller: TextEditingController(text: widget.agent.task.description),
                decoration: InputDecoration(labelText: '태스크 설명'),
                maxLines: 3,
                onChanged: (value) => widget.agent.task.description = value,
              ),
              TextField(
                controller: TextEditingController(text: widget.agent.task.expectedOutput),
                decoration: InputDecoration(labelText: '예상 결과'),
                onChanged: (value) => widget.agent.task.expectedOutput = value,
              ),
              SizedBox(height: 20),
              Text('아웃풋 파일:', style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['PNG', 'TXT', 'CSV'].map((fileType) {
                  bool isSelected = widget.agent.task.outputFiles.contains(fileType);
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Color(0xFF6050DC) : Colors.grey[300],
                      foregroundColor: isSelected ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: Text(fileType),
                    onPressed: () {
                      setState(() {
                        if (isSelected) {
                          widget.agent.task.outputFiles.remove(fileType);
                        } else {
                          widget.agent.task.outputFiles.add(fileType);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ] else if (widget.selectedPart == '도구') ...[
              Text('선택된 도구 목록:', style: Theme.of(context).textTheme.titleMedium),
              ...widget.agent.tools.map((tool) => ListTile(
                title: Text(tool.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      widget.agent.tools.remove(tool);
                    });
                    // 여기서 상태 업데이트 로직 추가 (예: Provider 사용)
                  },
                ),
              )).toList(),
            ],
          ],
        ),
      ),
    );
  }
}
class CollaborationChatScreen extends StatelessWidget {
  final CrewModel crew;

  CollaborationChatScreen({required this.crew});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('협업 진행 중'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: crew.agents.length * 2, // 각 에이전트마다 2개의 메시지를 표시
              itemBuilder: (context, index) {
                final agentIndex = index ~/ 2;
                final isEven = index % 2 == 0;
                final agent = crew.agents[agentIndex];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/head_${agent.headAsset}.png'),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isEven ? Colors.blue[100] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam non felis vel augue tincidunt faucibus.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              child: Text('결과물 확인'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ResultViewScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class ResultViewScreen extends StatefulWidget {
  @override
  _ResultViewScreenState createState() => _ResultViewScreenState();
}

class _ResultViewScreenState extends State<ResultViewScreen> {
  String? selectedFile;
  List<String> resultFiles = ['output.png', 'output.txt', 'output.csv'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('결과물 확인'),
      ),
      body: Row(
        children: [
          // 왼쪽: 파일 목록 및 다운로드 버튼
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('결과물 파일 목록', style: Theme.of(context).textTheme.titleLarge),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: resultFiles.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(resultFiles[index]),
                        trailing: ElevatedButton(
                          child: Text('다운로드'),
                          onPressed: () {
                            // TODO: 개별 파일 다운로드 로직 구현
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${resultFiles[index]} 다운로드 시작')),
                            );
                          },
                        ),
                        onTap: () {
                          setState(() {
                            selectedFile = resultFiles[index];
                          });
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text('전체 다운로드'),
                    onPressed: () {
                      // TODO: 전체 파일 다운로드 로직 구현
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('전체 파일 다운로드 시작')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // 오른쪽: 미리보기 화면
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: selectedFile != null
                  ? Center(child: Text('$selectedFile 미리보기\n(실제 미리보기 구현 필요)'))
                  : Center(child: Text('파일을 선택하여 미리보기')),
            ),
          ),
        ],
      ),
    );
  }
}