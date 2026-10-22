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
  final TextEditingController _authorFirstNameInput = TextEditingController();
  final TextEditingController _authorLastNameInput = TextEditingController();
  
  @override
  void dispose() {
    _authorFirstNameInput.dispose();
    _authorLastNameInput.dispose();
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
                  controller: _authorFirstNameInput,
                  decoration: const InputDecoration(
                    hintText: 'First Name..',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _authorLastNameInput,
                  decoration: const InputDecoration(
                    hintText: 'Last Name..',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filled(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final authorFirstName = _authorFirstNameInput.text.trim();
                  final authorLastName = _authorLastNameInput.text.trim();
                  final api = ServerApiPost();
                  // ignore: unused_local_variable
                  final response1 = await api('/author/add', {'first_name': authorFirstName, 'last_name': authorLastName});
                  if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added author successfully!')),
                  );
                  _authorFirstNameInput.clear();
                  _authorLastNameInput.clear();
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