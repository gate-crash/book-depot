import 'package:flutter/material.dart';
import 'package:bookdepot_client/data/models/server_api_model.dart';

class AuthorAdd extends StatefulWidget {
  const AuthorAdd({super.key});

  // Removed the unused 'bookcase' map parameter for cleaner embedding


  // 2. Add it to the constructor as a required parameter
  
  @override
  State<AuthorAdd> createState() => _AuthorAddState();
}

class _AuthorAddState extends State<AuthorAdd> {
  final TextEditingController _authorNameInput = TextEditingController();
  final TextEditingController _authorIdInput = TextEditingController();
  
  @override
  void dispose() {
    _authorNameInput.dispose();
    _authorIdInput.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // Return a Column directly, omitting the Scaffold and AppBar
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Author'),
      ),
      body:Column(        
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Add a new author',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _authorNameInput,
                  decoration: InputDecoration(
                    hintText: 'Name..',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _authorIdInput,
                  decoration: InputDecoration(
                    hintText: 'ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filled(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final authorName = _authorNameInput.text.trim();
                  final authorId = _authorIdInput.text.trim();
                  final api = ServerApiPost();
                  // ignore: unused_local_variable
                  final response1 = await api('/author/add', {'name': authorName, 'id': authorId});
                  if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added author successfully!')),
                  );
                  if (!mounted) return;
Navigator.pop(context, true);
                  _authorNameInput.clear();
                  _authorIdInput.clear();
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