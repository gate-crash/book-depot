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
  
  @override
  void dispose() {
    _bookNameInput.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Add a new book',
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Text('Or lookup book by ISBN',
                style: TextStyle(fontSize: 20),
                )
              ),
              const SizedBox(width: 10),
              IconButton.filled(
                icon: const Icon(Icons.add),
                onPressed: () async {
                // Open the scanner screen and wait for a result
                final result = await Navigator.push<String>(
                  context,
                 MaterialPageRoute(
                    builder: (context) => const QRScannerScreen(),
                  ),
                );
                }
              ),
              Spacer(
                flex: 7
              )
            ],

          ),
        ),
      ],
      )
    );
  }
}