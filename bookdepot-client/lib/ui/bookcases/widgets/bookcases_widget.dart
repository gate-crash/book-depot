import 'package:bookdepot_client/data/models/server_api_model.dart';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/bookcases/widgets/bookcases_grid.dart';
class BookcasesGet extends StatefulWidget {
  const BookcasesGet({super.key});

  @override
  State<BookcasesGet> createState() {
    return _BookcasesGetState();
  }
}

class _BookcasesGetState extends State<BookcasesGet> {
  final TextEditingController _bookCaseNameInput = TextEditingController();
  @override
  void dispose() {
    _bookCaseNameInput.dispose();
    super.dispose();
  }
  late Future<Map<String, dynamic>> _dataFuture;

  final ServerApiGet _serverApiService = ServerApiGet();
  
  @override
  void initState() {
    super.initState();
    _dataFuture = _serverApiService.serverDataGet('/bookcases', {});
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
                  autofocus: true,
                  controller: _bookCaseNameInput,
                  decoration: InputDecoration(
                    hintText: 'Enter bookcase name...',
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
                  final caseName = _bookCaseNameInput.text.trim();
                  final api = ServerApiPost();
                  await api('/bookcase/add', {'case_name': caseName});
                  if (modalContext.mounted) {
                                  ScaffoldMessenger.of(modalContext).showSnackBar(
                                    SnackBar(content: Text('Added "$caseName" - successfully!')),
                                  );
                                  _bookCaseNameInput.clear();
                                  // Passes `true` back to `wasAdded`
                                  Navigator.pop(modalContext, true);
                  _bookCaseNameInput.clear();
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
      _dataFuture = _serverApiService.serverDataGet('/bookcases', {});
    });
          }
                },
                
                  child: const Icon(Icons.add)
                  ),
      body: FutureBuilder<Map<String, dynamic>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!['bookcases'] == null) {
          return const Center(child: Text('No data available'));
        }

        final bookcases = snapshot.data!['bookcases'] as List<dynamic>;
        return BookcasesGrid(bookcases: bookcases);
      },
      )
    );
  }
}
