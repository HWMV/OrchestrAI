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
    agent = Provider.of<CrewModel>(context, listen: false)
        .agents[widget.agentIndex]!;
  }

  void _updateAgentAsset(String asset, String category) {
    setState(() {
      switch (category) {
        case '머리':
          agent.headAsset = asset;
          int index = int.parse(asset.split('_').last.split('.').first) - 1;
          String agentName = CrewModel.predefinedAgentNames[index];
          agent.name = agentName;
          var details = CrewModel.predefinedAgentDetails[agentName] ?? {};
          agent.role = details['role'] ?? '';
          agent.goal = details['goal'] ?? '';
          agent.backstory = details['backstory'] ?? '';
          break;
        case '태스크':
          agent.bodyAsset = asset;
          int index = int.parse(asset.split('_').last.split('.').first) - 1;
          String taskName = CrewModel.predefinedTaskNames[index];
          var taskDetails = CrewModel.predefinedTaskDetails[taskName] ?? {};
          agent.task.name = taskName;
          agent.task.description = taskDetails['description'] ?? '';
          agent.task.expectedOutput = taskDetails['expectedOutput'] ?? '';
          break;
      }
    });
    Provider.of<CrewModel>(context, listen: false)
        .updateAgent(agent, widget.agentIndex);
  }

  void _toggleTool(String toolName) {
    setState(() {
      if (agent.tools.contains(toolName)) {
        agent.tools.remove(toolName);
      } else if (agent.tools.length < 4) {
        agent.tools.add(toolName);
      }
    });
    Provider.of<CrewModel>(context, listen: false)
        .updateAgent(agent, widget.agentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI에이전트를 만들어보세요'),
        actions: [
          TextButton(
            onPressed: _completeAgentCreation,
            child: Text('완료', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: AssembledAgentView(agent: agent),
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
                          optionCount: selectedCategory == '머리'
                              ? CrewModel.predefinedAgentNames.length
                              : (selectedCategory == '태스크'
                                  ? CrewModel.predefinedTaskNames.length
                                  : Provider.of<CrewModel>(context,
                                          listen: false)
                                      .availableTools
                                      .length),
                          selectedTools: agent.tools,
                          selectedHead: agent.headAsset,
                          selectedTask: agent.bodyAsset,
                          onAssetChanged: (asset) {
                            setState(() {
                              switch (selectedCategory) {
                                case '머리':
                                  _updateAgentAsset(asset, '머리');
                                  break;
                                case '태스크':
                                  _updateAgentAsset(asset, '태스크');
                                  break;
                                case '도구':
                                  _toggleTool(asset);
                                  break;
                              }
                            });
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
              key: ValueKey('${agent.name}_${agent.task.name}'),
              agent: agent,
              selectedPart: selectedCategory,
              onParameterChanged: (role, goal, backstory) {
                setState(() {
                  agent.role = role;
                  agent.goal = goal;
                  agent.backstory = backstory;
                });
                Provider.of<CrewModel>(context, listen: false)
                    .updateAgent(agent, widget.agentIndex);
              },
              onTaskParameterChanged:
                  (description, expectedOutput, outputFiles) {
                setState(() {
                  agent.task.description = description;
                  agent.task.expectedOutput = expectedOutput;
                  agent.task.outputFiles = outputFiles;
                });
                Provider.of<CrewModel>(context, listen: false)
                    .updateAgent(agent, widget.agentIndex);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _completeAgentCreation() {
    // 에이전트 생성 완료 로직
    Provider.of<CrewModel>(context, listen: false)
        .updateAgent(agent, widget.agentIndex);
    Navigator.pop(context); // crew_screen으로 돌아가기
  }
}

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
        SizedBox(height: 20),
        Text('선택된 도구:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: agent.tools
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

class CategorySelectionView extends StatelessWidget {
  final Function(String) onCategorySelected;

  CategorySelectionView({required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['머리', '태스크', '도구'].map((category) {
        return ElevatedButton(
          child: Text(category),
          onPressed: () => onCategorySelected(category),
        );
      }).toList(),
    );
  }
}

class ComponentSelectionView extends StatelessWidget {
  final String part;
  final int optionCount;
  final List<String> selectedTools;
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

  @override
  Widget build(BuildContext context) {
    if (part == '머리' || part == '태스크') {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
        ),
        itemCount: optionCount,
        itemBuilder: (context, index) {
          String asset = '${part == '머리' ? 'head' : 'body'}_${index + 1}.png';
          bool isSelected =
              part == '머리' ? asset == selectedHead : asset == selectedTask;
          return GestureDetector(
            onTap: () => onAssetChanged(asset),
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset('assets/$asset'),
            ),
          );
        },
      );
    } else if (part == '도구') {
      return Consumer<CrewModel>(
        builder: (context, crewModel, child) {
          return ListView.builder(
            itemCount: crewModel.availableTools.length,
            itemBuilder: (context, index) {
              String toolName = crewModel.availableTools[index]['name']!;
              bool isSelected = selectedTools.contains(toolName);
              return ListTile(
                title: Text(toolName),
                trailing: isSelected
                    ? Icon(Icons.check_box, color: Colors.blue)
                    : Icon(Icons.check_box_outline_blank),
                onTap: () => onAssetChanged(toolName),
              );
            },
          );
        },
      );
    }
    return Container();
  }
}

class ParameterSettingsView extends StatefulWidget {
  final AgentModel agent;
  final String selectedPart;
  final Function(String, String, String) onParameterChanged;
  final Function(String, String, List<String>) onTaskParameterChanged;

  ParameterSettingsView({
    Key? key,
    required this.agent,
    required this.selectedPart,
    required this.onParameterChanged,
    required this.onTaskParameterChanged,
  }) : super(key: key);

  @override
  _ParameterSettingsViewState createState() => _ParameterSettingsViewState();
}

class _ParameterSettingsViewState extends State<ParameterSettingsView> {
  late TextEditingController _roleController;
  late TextEditingController _goalController;
  late TextEditingController _backstoryController;
  late TextEditingController _taskDescriptionController;
  late TextEditingController _taskExpectedOutputController;
  List<String> _outputFiles = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _roleController = TextEditingController(text: widget.agent.role);
    _goalController = TextEditingController(text: widget.agent.goal);
    _backstoryController = TextEditingController(text: widget.agent.backstory);
    _taskDescriptionController =
        TextEditingController(text: widget.agent.task.description);
    _taskExpectedOutputController =
        TextEditingController(text: widget.agent.task.expectedOutput);
    _outputFiles = List.from(widget.agent.task.outputFiles);
  }

  @override
  void didUpdateWidget(ParameterSettingsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.agent != widget.agent) {
      _initializeControllers();
    }
  }

  @override
  void dispose() {
    _roleController.dispose();
    _goalController.dispose();
    _backstoryController.dispose();
    _taskDescriptionController.dispose();
    _taskExpectedOutputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.agent.name}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            if (widget.selectedPart == '머리') ...[
              TextField(
                controller: _roleController,
                decoration: InputDecoration(labelText: '역할'),
                onChanged: (value) => widget.onParameterChanged(
                    value, _goalController.text, _backstoryController.text),
              ),
              TextField(
                controller: _goalController,
                decoration: InputDecoration(labelText: '목표'),
                onChanged: (value) => widget.onParameterChanged(
                    _roleController.text, value, _backstoryController.text),
              ),
              TextField(
                controller: _backstoryController,
                decoration: InputDecoration(labelText: '배경 이야기'),
                maxLines: 3,
                onChanged: (value) => widget.onParameterChanged(
                    _roleController.text, _goalController.text, value),
              ),
            ] else if (widget.selectedPart == '태스크') ...[
              Text('태스크 이름: ${widget.agent.task.name}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextField(
                controller: _taskDescriptionController,
                decoration: InputDecoration(labelText: '태스크 설명'),
                maxLines: 3,
                onChanged: (value) => widget.onTaskParameterChanged(
                    value, _taskExpectedOutputController.text, _outputFiles),
              ),
              TextField(
                controller: _taskExpectedOutputController,
                decoration: InputDecoration(labelText: '예상 결과'),
                onChanged: (value) => widget.onTaskParameterChanged(
                    _taskDescriptionController.text, value, _outputFiles),
              ),
              SizedBox(height: 20),
              Text('출력 파일', style: Theme.of(context).textTheme.titleMedium),
              ..._outputFiles.asMap().entries.map((entry) {
                int index = entry.key;
                String file = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: '파일 이름'),
                        controller: TextEditingController(text: file),
                        onChanged: (value) => _updateOutputFile(index, value),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => _removeOutputFile(index),
                    ),
                  ],
                );
              }).toList(),
              ElevatedButton(
                onPressed: _addOutputFile,
                child: Text('출력 파일 추가'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _updateOutputFile(int index, String value) {
    setState(() {
      _outputFiles[index] = value;
    });
    widget.onTaskParameterChanged(_taskDescriptionController.text,
        _taskExpectedOutputController.text, _outputFiles);
  }

  void _removeOutputFile(int index) {
    setState(() {
      _outputFiles.removeAt(index);
    });
    widget.onTaskParameterChanged(_taskDescriptionController.text,
        _taskExpectedOutputController.text, _outputFiles);
  }

  void _addOutputFile() {
    setState(() {
      _outputFiles.add('');
    });
    widget.onTaskParameterChanged(_taskDescriptionController.text,
        _taskExpectedOutputController.text, _outputFiles);
  }
}
