import 'package:flutter/foundation.dart';

class CrewModel extends ChangeNotifier {
  List<AgentModel> agents = [];

   // 사전 정의된 이름 목록 추가
  static const List<String> predefinedAgentNames = [
    '연구원', '데이터 분석가', '스크립트라이터', '일러스트레이터', '개발자', '작가', '금융전문가', '고객서비스', '학자', '커스텀에이전트'
  ];

  static const List<String> predefinedTaskNames = [
    '정보수집', '데이터 분석', '콘텐츠 생성', '이미지 생성', '코드생성', '문서요약', '금융분석', '고객서비스지원', '학술연구검색', '커스텀태스크'
  ];

  static const List<String> predefinedToolNames = [
    '디렉토리읽기도구', '코드분석도구', 'TXT검색도구', '디렉토리검색도구', '브라우저베이스로드도구', 'CSV검색도구', '파일읽기도구', 'Dall-E도구', '커스텀도구'
  ];

  void addAgent(AgentModel agent) {
    agents.add(agent);
    notifyListeners();
  }

  void addDefaultAgent() {
    addAgent(AgentModel(
      name: predefinedAgentNames[agents.length % predefinedAgentNames.length],
      role: "New Role",
      goal: "New Goal",
      backstory: "New Backstory",
      headAsset: 'default',
      bodyAsset: 'default',
      toolAsset: 'default',
      task: Task(name: predefinedTaskNames[0]),
      tools: [],
    ));
  }

  void updateAgent(AgentModel updatedAgent) {
  int index = agents.indexWhere((agent) => agent.name == updatedAgent.name);
  if (index != -1) {
    agents[index] = updatedAgent;
    notifyListeners();
  }
}

  void addDummyData() {
    addAgent(AgentModel(
      name: predefinedAgentNames[0],
      role: "Role 1",
      goal: "Goal 1",
      backstory: "Backstory 1",
      headAsset: "1",
      bodyAsset: "1",
      toolAsset: "1",
      task: Task(name: predefinedTaskNames[0]),
      tools: [Tool(name: predefinedToolNames[0])],
    ));
    // 필요하다면 더 많은 더미 데이터를 추가할 수 있습니다.
  }
}

class AgentModel {
  String name;
  String role;
  String goal;
  String backstory;
  String headAsset;
  String bodyAsset;
  String toolAsset;
  Task task;
  List<Tool> tools;

  AgentModel({
    required this.name,
    required this.role,
    required this.goal,
    required this.backstory,
    required this.headAsset,
    required this.bodyAsset,
    required this.toolAsset,
    required this.task,
    required this.tools,
  });
}

class Task {
  String name;
  String description;
  String expectedOutput;
  String outputFile;

  Task({
    required this.name,
    this.description = '',
    this.expectedOutput = '',
    this.outputFile = '',
  });
}

class Tool {
  String name;

  Tool({required this.name});
}