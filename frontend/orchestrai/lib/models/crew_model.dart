import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class CrewModel extends ChangeNotifier {
  List<AgentModel?> agents = List.filled(5, null);
  late ApiService apiService;
  List<Map<String, String>> availableTools = [];

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

  // 커스텀 에이전트 이름 매핑
  static const Map<String, String> customAgentDisplayNames = {
    'Lead Market Analyst': '선두 시장 분석가',
    'Chief Marketing Strategist': '수석 마케팅 전략가',
    'Creative Content Creator': '창의적 콘텐츠 제작자',
    'Senior Photographer': '수석 사진작가',
    'Chief Creative Director': '수석 크리에이티브 디렉터',
  };

  // 커스텀 태스크 이름 매핑
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
    'Chief Marketing Strategist': {
      'role': 'Chief Marketing Strategist',
      'goal':
          'Synthesize amazing insights from product analysis to formulate incredible marketing strategies.',
      'backstory':
          'You are the Chief Marketing Strategist at a leading digital marketing agency, known for crafting bespoke strategies that drive success.',
    },
    'Creative Content Creator': {
      'role': 'Creative Content Creator',
      'goal':
          'Develop compelling and innovative content for social media campaigns, with a focus on creating high-impact Instagram ad copies.',
      'backstory':
          'As a Creative Content Creator at a top-tier digital marketing agency, you excel in crafting narratives that resonate with audiences on social media. Your expertise lies in turning marketing strategies into engaging stories and visual content that capture attention and inspire action.',
    },
    'Senior Photographer': {
      'role': 'Senior Photographer',
      'goal':
          'Take the most amazing photographs for instagram ads that capture emotions and convey a compelling message.',
      'backstory':
          'As a Senior Photographer at a leading digital marketing agency, you are an expert at taking amazing photographs that inspire and engage, you are now working on a new campaign for a super important customer and you need to take the most amazing photograph.',
    },
    'Chief Creative Director': {
      'role': 'Chief Creative Director',
      'goal':
          'Oversee the work done by your team to make sure it is the best possible and aligned with the product is goals, review, approve, ask clarifying question or delegate follow up work if necessary to make decisions',
      'backstory':
          'You are the Chief Content Officer of leading digital marketing specialized in product branding. You are working on a new customer, trying to make sure your team is crafting the best possible content for the customer.',
    },
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
    'Strategy Development': {
      'description':
          'Develop a marketing strategy based on the market analysis.',
      'expectedOutput': 'Detailed marketing strategy document',
    },
    'Content Creation': {
      'description': 'Create engaging content for the marketing campaign.',
      'expectedOutput': 'Set of content pieces for various platforms',
    },
    'Photo Shooting': {
      'description': 'Capture high-quality photos for the marketing materials.',
      'expectedOutput': 'Collection of professional photographs',
    },
    'Creative Direction': {
      'description': 'Oversee and guide the creative process of the campaign.',
      'expectedOutput': 'Creative brief and direction document',
    },
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
      displayName:
          customAgentDisplayNames[agentRole] ?? agentRole, // 사용자 정의 이름 사용
      role: agentDetails['role'] ?? '',
      goal: agentDetails['goal'] ?? '',
      backstory: agentDetails['backstory'] ?? '',
      task: Task(
        displayName:
            customTaskDisplayNames[taskName] ?? taskName, // 사용자 정의 이름 사용
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

  String _getAssetName(String agentName) {
    // 기존 에셋 매핑 로직을 유지
    switch (agentName) {
      case 'Lead Market Analyst':
        return 'market_analyst';
      case 'Chief Marketing Strategist':
        return 'marketing_strategist';
      case 'Creative Content Creator':
        return 'content_creator';
      case 'Senior Photographer':
        return 'photographer';
      case 'Chief Creative Director':
        return 'creative_director';
      default:
        return 'default';
    }
  }

  void addAgent(AgentModel agent) {
    agents.add(agent);
    notifyListeners();
  }

  // Task를 Agent에 할당하는 메서드
  void assignTaskToAgent(String agentRole, Task task) {
    final agent =
        agents.firstWhere((a) => a?.role == agentRole, orElse: () => null);
    if (agent != null) {
      agent.task = task;
      notifyListeners();
    }
  }

  // executeCrew 메서드 수정 : name 대신 role 사용, task 대신 description 사용
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
                      'task_description': agent
                          .task?.description, // Task가 할당되었다면 description 전송
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
