// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ApiService {
//   final String baseUrl = 'https://your-backend-url.com/api';

//   Future> createWorkflow(Map data) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/create-workflow'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(data),
//     );

//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to create workflow');
//     }
//   }
// }