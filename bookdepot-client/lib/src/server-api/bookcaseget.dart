import 'dart:convert';
import 'package:http/http.dart' as http;

Future<http.Response> sendGetRequest(String url, Map<String, dynamic> data) async {
  return await http.get
  (
    Uri.parse(url),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
  );
}

// Example usage
void main() async {
  final response = await sendGetRequest('http://192.168.1.41:8000/bookcases', {'case_name': 'Unshelved'});

  dynamic jsonData = jsonDecode(response.body);
  
  String caseName = jsonData['bookcases'][0]['case_name'] ?? '';
  print('Bookcase name: $caseName');
}