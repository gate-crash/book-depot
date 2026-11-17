import 'package:bookdepot_client/data/models/server_api_model.dart';
import 'package:bookdepot_client/ui/shelves/widgets/shelf_add_widget.dart';
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
  // Store the future in a state variable so it doesn't refetch on every rebuild
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
      floatingActionButton: FloatingActionButton.large(
        onPressed: () async {
          final added = await Navigator.push<bool>(
            context,
            MaterialPageRoute<bool>(
              builder: (context) => ShelfAdd(bookcaseId: widget.bookcaseId),
            ),
          );
          if (!mounted) return;

          if (added == true) {
            setState(() {
              _dataFuture = _serverApiService.serverDataGet(
                '/shelves',
                {"bookcase": widget.bookcaseId},
              );
            });
          }
        },
        child: const Icon(Icons.add),
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
