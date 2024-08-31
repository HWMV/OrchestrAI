import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class CrewModel extends ChangeNotifier {
  List<AgentModel?> agents = List.filled(5, null);
  late ApiService apiService;
  List<Map<String, String>> availableTools = [];

  String? teamName;

  CrewModel() {
    apiService = ApiService();
    loadAvailableTools();
  }

  static const List<String> predefinedAgentNames = [
    'Lead Market Analyst',
    'Chief Marketing Strategist',
    'Creative Content Creator',
    'Senior Photographer',
    'Chief Creative Director'
  ];

  static const Map<String, String> customAgentDisplayNames = {
    'Lead Market Analyst': '선두 시장 분석가',
    'Chief Marketing Strategist': '수석 마케팅 전략가',
    'Creative Content Creator': '창의적 콘텐츠 제작자',
    'Senior Photographer': '수석 사진작가',
    'Chief Creative Director': '수석 크리에이티브 디렉터',
  };

  static const Map<String, String> customTaskDisplayNames = {
    'Market Analysis': '시장 분석',
    'Strategy Development': '전략 수립',
    'Content Creation': '콘텐츠 제작',
    'Photo Shooting': '사진 촬영',
    'Creative Direction': '크리에이티브 방향 설정',
  };

  static Map<String, Map<String, String>> predefinedAgentDetails = {
    'Lead Market Analyst': {
      'role': 'Lead Market Analyst',
      'goal':
          'Conduct amazing analysis of the products and competitors, providing in-depth insights to guide marketing strategies.',
      'backstory':
          'As the Lead Market Analyst at a premier digital marketing firm, you specialize in dissecting online business landscapes.',
    },
    // ... 다른 에이전트들의 상세 정보
  };

  static const List<String> predefinedTaskNames = [
    'Market Analysis',
    'Strategy Development',
    'Content Creation',
    'Photo Shooting',
    'Creative Direction'
  ];

  static const Map<String, Map<String, String>> predefinedTaskDetails = {
    'Market Analysis': {
      'description':
          'Analyze the current market trends and competitor strategies.',
      'expectedOutput': 'Comprehensive market analysis report',
    },
    // ... 다른 태스크들의 상세 정보
  };

  Future<void> loadAvailableTools() async {
    try {
      availableTools = await apiService.getAvailableTools();
      notifyListeners();
    } catch (e) {
      print('사용 가능한 도구 로딩 중 오류 발생: $e');
    }
  }

  void addDefaultAgent(int index) {
    if (index < 0 || index >= agents.length) return;

    String agentRole = predefinedAgentNames[index];
    Map<String, String> agentDetails = predefinedAgentDetails[agentRole] ?? {};
    String taskName = predefinedTaskNames[index];
    Map<String, String> taskDetails = predefinedTaskDetails[taskName] ?? {};

    agents[index] = AgentModel(
      displayName: customAgentDisplayNames[agentRole] ?? agentRole,
      role: agentDetails['role'] ?? '',
      goal: agentDetails['goal'] ?? '',
      backstory: agentDetails['backstory'] ?? '',
      task: Task(
        displayName: customTaskDisplayNames[taskName] ?? taskName,
        description: taskDetails['description'] ?? '',
        expectedOutput: taskDetails['expectedOutput'] ??
            'Default expected output for $taskName',
        outputFiles: [],
      ),
      tools: [],
      headAsset: '${index + 1}',
      bodyAsset: '${index + 1}',
      toolAsset: 'default',
    );
    notifyListeners();
  }

  void updateAgent(AgentModel updatedAgent, int index) {
    if (index < 0 || index >= agents.length) return;
    agents[index] = updatedAgent;
    notifyListeners();
  }

  void setTeamName(String name) {
    teamName = name;
    notifyListeners();
  }

  Future<String> executeCrew() async {
    try {
      final crewData = {
        'crew_resources': {
          'agents': {
            'agent_list': agents
                .where((agent) => agent != null)
                .map((agent) => {
                      'role': agent!.role,
                      'goal': agent.goal,
                      'backstory': agent.backstory,
                      'tools': agent.tools,
                      'task_description': agent.task?.description,
                    })
                .toList(),
          },
          'tasks': {
            for (var agent in agents.where((a) => a != null && a.task != null))
              agent!.task!.description: {
                'description': agent.task!.description,
                'target_agent': agent.role,
                'expected_output': agent.task!.expectedOutput,
              }
          },
        }
      };

      print('Sending crew data: ${json.encode(crewData)}');

      final result = await apiService.executeCrew(crewData);
      return result['result'] as String;
    } catch (e) {
      print('Error executing crew: $e');
      return 'Error: $e';
    }
  }
}

class AgentModel {
  String displayName; // 사용자에게 보여지는 이름
  String role; // 백엔드와 통신할 때 사용되는 식별자
  String goal;
  String backstory;
  Task? task; // Task를 선택적으로 만듭니다
  List<String> tools;
  String headAsset;
  String bodyAsset;
  String toolAsset;

  AgentModel({
    required this.displayName,
    required this.role,
    required this.goal,
    required this.backstory,
    this.task,
    required this.tools,
    required this.headAsset,
    required this.bodyAsset,
    required this.toolAsset,
  });
}

class Task {
  String displayName; // 사용자에게 보여지는 이름
  String description; // 백엔드와 통신할 때 사용되는 식별자
  String expectedOutput;
  List<String> outputFiles;

  Task({
    required this.displayName,
    required this.description,
    required this.expectedOutput,
    required this.outputFiles,
  }) {
    // expectedOutput이 비어있으면 기본값 설정
    if (this.expectedOutput.isEmpty) {
      this.expectedOutput = "Task output";
    }
  }
}
