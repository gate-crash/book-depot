import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthorLookupModel {
  final String apiHost = 'https://openlibrary.org/authors/';
  Future<Map<String, dynamic>> serverDataGet(String authorId, ) async {
    final url = Uri.parse('$apiHost$authorId.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load data (${response.body})');
    }
  }
}

