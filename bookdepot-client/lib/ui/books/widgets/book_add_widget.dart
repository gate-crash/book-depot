import 'package:bookdepot_client/data/models/mobile_scanner.dart';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/data/models/server_api_model.dart';
import 'package:bookdepot_client/data/models/isbn_lookup_model.dart';

class BookAdd extends StatefulWidget {
  // Removed the unused 'bookcase' map parameter for cleaner embedding
  final String shelfId;

  // 2. Add it to the constructor as a required parameter
  const BookAdd({super.key, required this.shelfId});

  @override
  State<BookAdd> createState() => _BookAddState();
}

class _BookAddState extends State<BookAdd> {
  final TextEditingController _bookNameInput = TextEditingController();
  final TextEditingController _bookAuthorIdInput = TextEditingController();
  final TextEditingController _isbnInput = TextEditingController();
  String _publishDate = '';
  String _physicalFormat = '';
  
  @override
  void dispose() {
    _bookNameInput.dispose();
    _bookAuthorIdInput.dispose();
    _isbnInput.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Book'),
      ),
      body:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _isbnInput,
                  decoration: const InputDecoration(
                    hintText: 'Enter ISBN...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              FloatingActionButton.extended(
                onPressed: () async {
                final api = IsbnLookupModel();
                final bookData = await api.serverDataGet(_isbnInput.text);
                _bookNameInput.text = bookData['title'] ?? '';
                _publishDate = bookData['publish_date'] ?? '';
                _physicalFormat = bookData['physical_format'] ?? '';
                _bookAuthorIdInput.text = bookData['authors'][0]['key'].split('/').last ?? '';
                  if (!context.mounted) return; 
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Looked up: $bookData'),
                      duration: const Duration(seconds: 15), 
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                label: Text('Lookup ISBN'),
                icon: const Icon(Icons.search_sharp),
              ),
              FloatingActionButton.extended(
                onPressed: () async {
                final result = await Navigator.push<String>(
                  context,
                 MaterialPageRoute(
                    builder: (context) => const QRScannerScreen(),
                  ),
                );

                if (result != null) {
          if (!context.mounted) return; 
          _isbnInput.text= result;
          final api = IsbnLookupModel();
          final bookData = await api.serverDataGet(result);
          _bookNameInput.text = bookData['title'] ?? '';
          _publishDate = bookData['publish_date'] ?? '';
          _physicalFormat = bookData['physical_format'] ?? '';
          _bookAuthorIdInput.text = bookData['authors'][0]['key'].split('/').last ?? '';
         
                  if (!context.mounted) return; 
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Scanned: $result'),
                      duration: const Duration(seconds: 1), 
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Looked up: $bookData'),
                      duration: const Duration(seconds: 15), 
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
                },
                label: Text('Scan Bar Code'),
                icon: const Icon(Icons.qr_code_scanner_outlined),
              ),
            ],

          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _bookNameInput,
                  decoration: const InputDecoration(
                    hintText: 'Book Title',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _bookAuthorIdInput,
                  decoration: const InputDecoration(
                    hintText: 'Author ID...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filled(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final bookName = _bookNameInput.text.trim();
                  final isbn = _isbnInput.text.trim();
                  final bookAuthor = _bookAuthorIdInput.text.trim();
                  final api = ServerApiPost();
                  // ignore: unused_local_variable
                  final response1 = await api('/book/add', {'title': bookName, 'author': bookAuthor, 'shelf': widget.shelfId, 'isbn': isbn, 'publish_date': _publishDate, 'format': _physicalFormat});
                  if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added "$bookName" - successfully!')),
                  );
                  _bookNameInput.clear();
                }
                },
              ),
            ],

          ),
        ),
      ],
      )
    );
  }
}