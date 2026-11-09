import 'dart:convert';
import 'package:http/http.dart' as http;

class IsbnLookupModel {
  final String apiHost = 'https://openlibrary.org/isbn/';
  Future<Map<String, dynamic>> serverDataGet(String isbn, ) async {
    final url = Uri.parse('$apiHost$isbn.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load data (${response.body})');
    }
  }
}


