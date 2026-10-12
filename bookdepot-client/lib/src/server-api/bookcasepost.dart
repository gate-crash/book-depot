import 'dart:convert';
import 'package:http/http.dart' as http;

Future<http.Response> sendPostRequest(String url, Map<String, dynamic> data) async {
  return await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(data),
  );
}

// Example usage
void main() async {
  final response = await sendPostRequest(
    'http://192.168.1.41:8000/bookcase/add',
    {
      'case_name': 'Fiction',
      'genre': 'Science Fiction',
      'number': '1',
    },
  );

  print('Status code: ${response.statusCode}');
  print('Response: ${response.body}');
}