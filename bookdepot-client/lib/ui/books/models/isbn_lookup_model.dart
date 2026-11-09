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


class BookLookupService {
  final IsbnLookupModel _api = IsbnLookupModel();

  Future<BookDetails?> fetchByIsbn(String isbn) async {
    try {
      final Map<String, dynamic>? bookData = await _api.serverDataGet(isbn);
      
      if (bookData == null) return null;
      
      return BookDetails.fromJson(bookData);
    } catch (e) {
      print('Error fetching book: $e');
      return null;
    }
  }
}

class BookDetails {
  final String title;
  final String publishDate;
  final String format;
  final String author;

  BookDetails({
    this.title = '',
    this.publishDate = '',
    this.format = '',
    this.author = '',
  });

  factory BookDetails.fromJson(Map<String, dynamic> json) {
    String authorId = '';
    final authorsList = json['authors'] as List?;
    if (authorsList != null && authorsList.isNotEmpty) {
      authorId = authorsList[0]['key']?.split('/').last ?? '';
    }

    return BookDetails(
      title: json['title'] ?? '',
      publishDate: json['publish_date'] ?? '',
      format: json['physical_format'] ?? '',
      author: authorId,
    );
  }
}