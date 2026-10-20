import 'package:flutter/material.dart';
import 'package:bookdepot_client/data/models/server_api_model.dart';

class ShelfAdd extends StatefulWidget {
  // Removed the unused 'bookcase' map parameter for cleaner embedding
  final String bookcaseId;

  // 2. Add it to the constructor as a required parameter
  const ShelfAdd({super.key, required this.bookcaseId});
  

  @override
  State<ShelfAdd> createState() => _ShelfAddState();
}

class _ShelfAddState extends State<ShelfAdd> {
  final TextEditingController _bookCaseNameInput = TextEditingController();
  
  @override
  void dispose() {
    _bookCaseNameInput.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // Return a Column directly, omitting the Scaffold and AppBar
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Add a new shelf',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const SizedBox(width: 10, height: 10),
              IconButton.filled(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final api = ServerApiPost();
                  // ignore: unused_local_variable
                  final response1 = await api('/shelf/add', {'bookcase': widget.bookcaseId,
                  });
                  if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added shelf successfully!')),
                  );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}