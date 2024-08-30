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

    String agentName = predefinedAgentNames[index];
    Map<String, String> agentDetails = predefinedAgentDetails[agentName] ?? {};
    String taskName = predefinedTaskNames[index];
    Map<String, String> taskDetails = predefinedTaskDetails[taskName] ?? {};

    agents[index] = AgentModel(
      name: agentName,
      role: agentDetails['role'] ?? '',
      goal: agentDetails['goal'] ?? '',
      backstory: agentDetails['backstory'] ?? '',
      taskName: taskName,
      taskDescription: taskDetails['description'] ?? '',
      taskExpectedOutput: taskDetails['expectedOutput'] ?? '',
      taskOutputFiles: [],
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

  Future<String> executeCrew() async {
    try {
      final result = await apiService.executeCrew(this);
      return result['result'] as String;
    } catch (e) {
      print('Error executing crew: $e');
      return 'Error: $e';
    }
  }
}

class AgentModel {
  String name;
  String role;
  String goal;
  String backstory;
  Task task;
  List<String> tools;
  String headAsset;
  String bodyAsset;
  String toolAsset;

  AgentModel({
    required this.name,
    required this.role,
    required this.goal,
    required this.backstory,
    required String taskName,
    required String taskDescription,
    required String taskExpectedOutput,
    List<String>? taskOutputFiles,
    required this.tools,
    required this.headAsset,
    required this.bodyAsset,
    required this.toolAsset,
  }) : this.task = Task(
          name: taskName,
          description: taskDescription,
          expectedOutput: taskExpectedOutput,
          outputFiles: taskOutputFiles ?? [],
        );
}

class Task {
  String name;
  String description;
  String expectedOutput;
  List<String> outputFiles;

  Task({
    required this.name,
    required this.description,
    required this.expectedOutput,
    required this.outputFiles,
  });
}
// import 'package:flutter/foundation.dart';
// import '../services/api_service.dart';

// class CrewModel extends ChangeNotifier {
//   List<AgentModel> agents = [];
//   late ApiService apiService;
//   List<Map<String, String>> availableTools = [];

//   CrewModel() {
//     apiService = ApiService();
//     loadAvailableTools();
//   }

//   // 사전 정의된 이름 목록 추가
//   static const List<String> predefinedAgentNames = [
//     '마켓분석가',
//     '마케팅 전략가',
//     '콘텐츠 창작자',
//     '포토그래퍼',
//     '크리에이티브 디렉터',
//     '리서처',
//     '테크니컬 분석가',
//     '재무분석가',
//     '투자추천 전문가',
//     '커스텀 에이전트'
//   ];

//   static const List<String> predefinedTaskNames = [
//     '정보수집',
//     '데이터 분석',
//     '콘텐츠 생성',
//     '이미지 생성',
//     '코드생성',
//     '문서요약',
//     '금융분석',
//     '고객서비스지원',
//     '학술연구검색',
//     '커스텀태스크'
//   ];

//   static List<String> predefinedToolNames = [
//     'Search internet',
//     'Search instagram',
//     'Read file',
//     'Write file',
//     'Analyze image', // 사전 정의된 시나리오 tool 이름 추가
//     '디렉토리읽기도구',
//     '코드분석도구',
//     'TXT검색도구',
//     '디렉토리검색도구',
//     '브라우저베이스로드도구',
//     'CSV검색도구',
//     '파일읽기도구',
//     'Dall-E도구',
//     '커스텀도구'
//   ];

//   Future<void> loadAvailableTools() async {
//     try {
//       availableTools = await apiService.getAvailableTools();
//       List<String> loadedToolNames =
//           availableTools.map((tool) => tool['name']!).toList();
//       Set<String> uniqueToolNames = Set.from(predefinedToolNames)
//         ..addAll(loadedToolNames);
//       predefinedToolNames = uniqueToolNames.toList();
//       notifyListeners();
//     } catch (e) {
//       print('사용 가능한 도구 로딩 중 오류 발생: $e');
//       // 에러가 발생해도 기존의 predefinedToolNames를 계속 사용
//     }
//   }

//   static const Map<String, Map<String, String>> predefinedAgentDetails = {
//     '마켓분석가': {
//       'role': '수석 마케팅 분석가',
//       'goal': '제품과 경쟁자에 대한 놀라운 분석을 실시하고, 마케팅 전략을 안내하는 심층적인 통찰력을 제공합니다.',
//       'backstory':
//           '일류 디지털 마케팅 회사의 수석 시장 분석가로서 귀하는 온라인 비즈니스 환경을 분석하는 데 전문성을 갖추고 있습니다.',
//     },
//     '마케팅 전략가': {
//       'role': '수석 마케팅 전략가',
//       'goal': '제품 분석에서 놀라운 통찰력을 종합하여 놀라운 마케팅 전략을 수립하세요.',
//       'backstory':
//           '귀하는 성공을 이끄는 맞춤형 전략을 수립하는 것으로 알려진 선도적인 디지털 마케팅 기관의 최고 마케팅 전략가입니다.',
//     },
//     '콘텐츠 창작자': {
//       'role': '창의적인 콘텐츠 창작자',
//       'goal':
//           '효과적인 Instagram 광고 카피를 만드는 데 중점을 두고, 소셜 미디어 캠페인을 위한 매력적이고 혁신적인 콘텐츠를 개발합니다.',
//       'backstory':
//           '최고 수준의 디지털 마케팅 기관에서 크리에이티브 콘텐츠 제작자로서 귀하는 소셜 미디어에서 청중의 공감을 얻는 이야기를 만드는 데 능숙합니다. 귀하의 전문성은 마케팅 전략을 관심을 끌고 행동을 유발하는 매력적인 스토리와 시각적 콘텐츠로 전환하는 데 있습니다.',
//     },
//     '포토그래퍼': {
//       'role': '시니어 포토그래퍼',
//       'goal': '감정을 포착하고 설득력 있는 메시지를 전달하는 Instagram 광고를 위해 가장 놀라운 사진을 촬영하세요.',
//       'backstory':
//           '선도적인 디지털 마케팅 기관의 수석 사진작가로서, 당신은 영감을 주고 참여를 유도하는 놀라운 사진을 찍는 전문가입니다. 당신은 지금 매우 중요한 고객을 위한 새로운 캠페인을 진행하고 있으며 가장 놀라운 사진을 찍어야 합니다.',
//     },
//     '크리에이티브 디렉터': {
//       'role': '수석 크리에이티브 디렉터',
//       'goal':
//           '팀의 작업을 감독하여 최상의 결과를 얻고 제품 목표에 부합하는지 확인하고, 필요한 경우 검토, 승인, 명확한 질문 또는 후속 작업 위임을 통해 의사 결정을 내립니다.',
//       'backstory':
//           '당신은 제품 브랜딩을 전문으로 하는 선도적인 디지털 마케팅의 최고 콘텐츠 책임자입니다. 당신은 새로운 고객을 대상으로 작업하고 있으며, 당신의 팀이 고객을 위해 가능한 최상의 콘텐츠를 만들고 있는지 확인하려고 노력하고 있습니다.',
//     },
//     '리서처': {
//       'role': '수석 리서처',
//       'goal': '주식에 대한 심리와 뉴스에 대한 포괄적인 개요를 제공하기 위해 방대한 양의 데이터를 수집, 해석하고 요약합니다.',
//       'backstory':
//           '당신은 다양한 출처에서 데이터를 수집하고 해석하여 주식의 감정과 뉴스에 대한 완전한 그림을 제공하는 데 능숙합니다. 당신은 각 데이터 출처를 주의 깊게 읽고 가장 중요한 정보를 추출합니다. 당신의 통찰력은 정보에 입각한 투자 결정을 내리는 데 중요합니다.',
//     },
//     '테크니컬 분석가': {
//       'role': '수석 테크니컬 분석가',
//       'goal': '주식의 움직임을 분석하고 추세, 진입 시점, 저항선 및 지지선에 대한 통찰력을 제공합니다.',
//       'backstory':
//           '기술 분석 전문가로서, 과거 데이터를 기반으로 주식 움직임과 추세를 예측하는 능력으로 유명합니다. 고객에게 귀중한 통찰력을 제공합니다.',
//     },
//     '재무분석가': {
//       'role': '수석 재무분석가',
//       'goal': '재무제표, 내부자 거래 데이터, 기타 재무 지표를 사용하여 주식의 재무 건전성과 실적을 평가합니다.',
//       'backstory':
//           '당신은 기술적 분석과 기본적 분석을 결합하여 고객에게 전략적 투자 조언을 제공하는 매우 경험이 풍부한 투자 자문가입니다. 당신은 회사의 재무 건전성, 시장 심리, 정성적 데이터를 살펴보고 정보에 입각한 권장 사항을 내립니다.',
//     },
//     '투자추천 전문가': {
//       'role': '수석 투자추천 전문가',
//       'goal':
//           '주식 포트폴리오를 관리하고 재무 분석가, 기술 분석가 및 연구자의 통찰력을 활용하여 수익을 극대화하기 위한 전략적 투자 결정을 내립니다.',
//       'backstory':
//           '당신은 수익성 있는 투자 결정을 내린 입증된 실적을 가진 노련한 헤지 펀드 매니저입니다. 당신은 고객을 위해 위험을 관리하고 수익을 극대화하는 능력으로 유명합니다.',
//     },
//     '커스텀 에이전트': {
//       'role': '',
//       'goal': '',
//       'backstory': '',
//     },
//   };
//   static const Map<String, Map<String, String>> predefinedTaskDetails = {
//     '정보수집': {
//       'description': '다양한 소스에서 관련 정보를 수집하고 정리합니다.',
//       'expectedOutput': '수집된 정보의 구조화된 요약',
//     },
//     '데이터 분석': {
//       'description': '수집된 데이터를 분석하여 의미 있는 인사이트를 도출합니다.',
//       'expectedOutput': '데이터 분석 보고서와 주요 발견 사항',
//     },
//     // ... 다른 태스크에 대한 상세 정보 추가 ...
//   };

//   static const Map<String, String> predefinedToolDetails = {};

//   Future<String> executeCrew() async {
//     try {
//       final result = await apiService.executeCrew(this);
//       return result['result'] as String; // 백엔드에서 반환한 결과
//     } catch (e) {
//       print('Error executing crew: $e');
//       return 'Error: $e';
//     }
//   }

//   void addAgent(AgentModel agent) {
//     agents.add(agent);
//     notifyListeners();
//   }

//   void addDefaultAgent() {
//     String defaultAgentName =
//         predefinedAgentNames[agents.length % predefinedAgentNames.length];
//     Map<String, String> details =
//         predefinedAgentDetails[defaultAgentName] ?? {};

//     addAgent(AgentModel(
//       name: defaultAgentName,
//       role: details['role'] ?? "새로운 역할",
//       goal: details['goal'] ?? "새로운 목표",
//       backstory: details['backstory'] ?? "새로운 배경 이야기",
//       headAsset: _getAssetName(defaultAgentName),
//       bodyAsset: 'default',
//       toolAsset: 'default',
//       task: Task(
//         name: _getDefaultTaskName(defaultAgentName),
//         description: "기본 태스크 설명",
//         expectedOutput: "기본 예상 출력",
//       ),
//       tools: [_getDefaultToolName(defaultAgentName)], // 문자열 리스트로 변경
//     ));
//   }

//   String _getAssetName(String agentName) {
//     int index = predefinedAgentNames.indexOf(agentName) + 1;
//     return index.toString();
//   }

//   String _getDefaultTaskName(String agentName) {
//     switch (agentName) {
//       case '마켓분석가':
//         return '정보수집';
//       case '포토그래퍼':
//         return '이미지 생성';
//       default:
//         return '기본 태스크';
//     }
//   }

//   String _getDefaultToolName(String agentName) {
//     switch (agentName) {
//       case '마켓분석가':
//         return 'Search internet';
//       case '포토그래퍼':
//         return 'Analyze image';
//       default:
//         return predefinedToolNames.first; // 첫 번째 도구를 기본값으로 사용
//     }
//   }

// //
//   void updateAgent(AgentModel updatedAgent) {
//     int index = agents.indexWhere((agent) => agent.name == updatedAgent.name);
//     if (index != -1) {
//       agents[index] = updatedAgent;
//       notifyListeners();
//     }
//   }
// }

// class AgentModel {
//   String name;
//   String role;
//   String goal;
//   String backstory;
//   String headAsset;
//   String bodyAsset;
//   String toolAsset;
//   Task task;
//   List<String> tools; // 도구 이름 목록으로 변경

//   AgentModel({
//     required this.name,
//     required this.role,
//     required this.goal,
//     required this.backstory,
//     required this.headAsset,
//     required this.bodyAsset,
//     required this.toolAsset,
//     required this.task,
//     required this.tools,
//   });
// }

// class Task {
//   String name;
//   String description;
//   String expectedOutput;
//   List<String> outputFiles;

//   Task({
//     required this.name,
//     this.description = '',
//     this.expectedOutput = '',
//     List<String>? outputFiles,
//   }) : this.outputFiles = outputFiles ?? [];
// }

// class Tool {
//   String name;
//   String description;

//   Tool({required this.name, this.description = ''});
// }
