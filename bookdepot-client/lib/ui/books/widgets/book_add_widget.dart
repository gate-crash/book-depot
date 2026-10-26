import 'package:bookdepot_client/data/models/mobile_scanner.dart';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/data/models/server_api_model.dart';
import 'package:bookdepot_client/data/models/floating_action_button.dart';

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
  final TextEditingController _bookAuthorInput = TextEditingController();
  final TextEditingController _isbnInput = TextEditingController();
  
  @override
  void dispose() {
    _bookNameInput.dispose();
    _bookAuthorInput.dispose();
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
                final result = await Navigator.push<String>(
                  context,
                 MaterialPageRoute(
                    builder: (context) => const QRScannerScreen(),
                  ),
                );

                if (result != null) {
          if (!context.mounted) return; 
          _isbnInput.text= result;
                  if (!context.mounted) return; 
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Scanned: $result'),
                      duration: const Duration(seconds: 5), 
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
                },
                label: Text('Scan QR Code'),
                icon: const Icon(Icons.qr_code_scanner_outlined),
              ),
            ],

          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Or add a book manually',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _bookNameInput,
                  decoration: const InputDecoration(
                    hintText: 'Enter book name...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _bookAuthorInput,
                  decoration: const InputDecoration(
                    hintText: 'Enter Author Name...',
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
                  final bookAuthor = _bookAuthorInput.text.trim();
                  final api = ServerApiPost();
                  // ignore: unused_local_variable
                  final response1 = await api('/book/add', {'title': bookName, 'author': bookAuthor, 'shelf': widget.shelfId});
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