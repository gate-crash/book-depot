import 'dart:convert';
import 'package:http/http.dart' as http;
final String api_host = 'http://192.168.1.41:8000';
class ServerApiGet {
  Future<Map<String, dynamic>> serverDataGet(String endpoint, Map<String, dynamic> data) async {
    final Map<String, String> queryBody = data.map((key, value) => MapEntry(key, value.toString()));
    final url = Uri.parse('$api_host$endpoint').replace(queryParameters: queryBody);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load data (${response.body})');
    }
  }
}

class ServerApiPost {
  Future<http.Response> call(String endpoint, Map<String, dynamic> data) async {
    return await http.post(
      Uri.parse('$api_host$endpoint'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(data),
    );
  }
}
