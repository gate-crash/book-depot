import 'dart:convert';
import 'package:http/http.dart' as http;
final String api_host = '192.168.1.41:8000';
final String api_endpoint = 'bookcases';
class ServerApiGet {
  // Moved the function here and renamed it to be more descriptive
  Future<Map<String, dynamic>> fetchBookcases() async {
    final url = Uri.parse('http://$api_host/$api_endpoint');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load data (${response.statusCode})');
    }
  }
}