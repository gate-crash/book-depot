import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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

class AuthorCoverLookup {
  final String apiHost = 'https://covers.openlibrary.org/a/olid/';
  Future<void> downloadAndSaveImage(String id) async {
  try {
    print('Starting download...');
    final response = await http.get(Uri.parse(apiHost + id + '-M.jpg'));

    if (response.statusCode == 200) {
      final Directory documentDirectory = await getApplicationDocumentsDirectory();
      String filePath = '${documentDirectory.path}/$id-cover.jpg';
      final File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);


      print('Image saved successfully at: $filePath');
    } else {
      print('Failed to fetch image. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error saving image: $e');
  }
}
}