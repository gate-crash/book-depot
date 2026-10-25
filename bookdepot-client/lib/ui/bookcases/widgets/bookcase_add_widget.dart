import 'package:flutter/material.dart';
import 'package:bookdepot_client/data/models/server_api_model.dart';

class BookcaseAdd extends StatefulWidget {
  const BookcaseAdd({super.key});

  @override
  State<BookcaseAdd> createState() => _BookcaseAddState();
}

class _BookcaseAddState extends State<BookcaseAdd> {
  final TextEditingController _bookCaseNameInput = TextEditingController();
  
  @override
  void dispose() {
    _bookCaseNameInput.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bookcase'),
      ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Add a new bookcase',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _bookCaseNameInput,
                  decoration: const InputDecoration(
                    hintText: 'Enter bookcase name...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filled(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final caseName = _bookCaseNameInput.text.trim();
                  final api = ServerApiPost();
                  // ignore: unused_local_variable
                  final response1 = await api('/bookcase/add', {'case_name': caseName});
                  if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added "$caseName" - successfully!')),
                  );
                  _bookCaseNameInput.clear();
                }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}