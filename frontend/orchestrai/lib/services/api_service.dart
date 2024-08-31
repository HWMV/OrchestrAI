import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = 'http://localhost:8000'; // 백엔드 서버 주소

  // 사용 가능한 도구 목록을 반환하는 엔드포인트
  Future<List<Map<String, String>>> getAvailableTools() async {
    try {
      print('Requesting available tools from: $baseUrl/available_tools');
      final response = await http.get(Uri.parse('$baseUrl/available_tools'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final toolsList = data['tools'] as List;
        return toolsList
            .map((tool) => {
                  'name': tool['name'] as String,
                  'description': tool['description'] as String,
                })
            .toList();
      } else {
        throw Exception(
            'Failed to load available tools. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAvailableTools: $e');
      throw Exception('Failed to load available tools: $e');
    }
  }

  Future<Map<String, dynamic>> executeCrew(
      Map<String, dynamic> crewData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/execute_crew'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(crewData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to execute crew: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error executing crew: $e');
    }
  }
}
