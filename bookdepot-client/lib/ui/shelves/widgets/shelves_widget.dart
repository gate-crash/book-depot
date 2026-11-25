import 'package:bookdepot_client/data/models/server_api_model.dart';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/shelves/widgets/shelves_grid.dart';

class ShelvesGet extends StatefulWidget {
  const ShelvesGet({super.key, required this.bookcaseId});

  final String bookcaseId;

  @override
  State<ShelvesGet> createState() {
    return _ShelvesGetState();
  }
}

class _ShelvesGetState extends State<ShelvesGet> {
  final TextEditingController _shelfNameInput = TextEditingController();
  @override
  void dispose() {
    _shelfNameInput.dispose();
    super.dispose();
  }
  late Future<Map<String, dynamic>> _dataFuture;

  final ServerApiGet _serverApiService = ServerApiGet();
  
  @override
  void initState() {
    super.initState();
    _dataFuture = _serverApiService.serverDataGet('/shelves', {"bookcase": widget.bookcaseId});
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton.large(onPressed: () async {final bool? wasAdded = await showModalBottomSheet<bool>(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext modalContext) {
                      return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(modalContext).viewInsets.bottom),
                      child: Container(
                        height: 200,
                        color: Colors.amber,
                        child: Center(
                          child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Add a new Shelf',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  autofocus: true,
                  controller: _shelfNameInput,
                  decoration: InputDecoration(
                    hintText: 'Enter Shelf name...',
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
                  final caseName = _shelfNameInput.text.trim();
                  final api = ServerApiPost();
                  await api('/shelf/add', {'bookcase': widget.bookcaseId,
                  });
                  if (modalContext.mounted) {
                                  ScaffoldMessenger.of(modalContext).showSnackBar(
                                    SnackBar(content: Text('Added "$caseName" - successfully!')),
                                  );
                                  _shelfNameInput.clear();
                                  // Passes `true` back to `wasAdded`
                                  Navigator.pop(modalContext, true);
                  _shelfNameInput.clear();
                }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
                        ),
                      )
                      );
                    },
                  );
                  if (wasAdded == true && mounted) {
            setState(() {
      _dataFuture = _serverApiService.serverDataGet('/shelves', {"bookcase": widget.bookcaseId});
    });
          }
                },
                
                  child: const Icon(Icons.add)
                  ),
      body:FutureBuilder<Map<String, dynamic>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!['shelves'] == null) {
          return const Center(child: Text('No data available'));
        }

        final shelves = snapshot.data!['shelves'] as List<dynamic>;

        return ShelvesGrid(shelves: shelves);     },
      )
    );
  }
}
