import 'package:bookdepot_client/data/models/server_api_model.dart';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/bookcases/widgets/bookcases_widget_add_book.dart';
import 'package:bookdepot_client/ui/books/widgets/book_add_widget.dart';
import 'package:bookdepot_client/ui/books/widgets/books_grid.dart';

class BooksGet extends StatefulWidget {
  BooksGet({super.key, this.endpoint, this.payload});
  final String? endpoint;
  final Map<String, dynamic>? payload;
  @override
  State<BooksGet> createState() {
    return _BooksGetState();
  }
}


class _BooksGetState extends State<BooksGet> {
  // Store the future in a state variable so it doesn't refetch on every rebuild
  late Future<List<Map<String, dynamic>>> _dataFuture;

  final ServerApiGet _serverApiService = ServerApiGet();
  final ServerApiGet _serverApiServerAuthor = ServerApiGet();
  
  @override
  void initState() {
    super.initState();
    final bookGetCall = _serverApiService.serverDataGet(widget.endpoint!, widget.payload!);
    final authorGetCall = _serverApiServerAuthor.serverDataGet('/authors', {});
    _dataFuture = Future.wait([bookGetCall, authorGetCall]);
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
  onPressed: () async {
    if (widget.payload == null || widget.payload!.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => BookcasesGetAddFlow(),
        ),
      );
    } else {
      final added = await Navigator.push<bool>(
        context,
        MaterialPageRoute<bool>(
          builder: (context) => BookAdd(shelfId: widget.payload?['shelf']),
        ),
      );
      if (!mounted) return;

        if (added == true) {
          setState(() {
    final bookGetCall = _serverApiService.serverDataGet(widget.endpoint!, widget.payload!);
    final authorGetCall = _serverApiServerAuthor.serverDataGet('/authors', {});
    _dataFuture = Future.wait([bookGetCall, authorGetCall]);
          });
        }
    }
  },
  child: const Icon(Icons.add),
),
      body: FutureBuilder<List<Map<String, dynamic>>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }
        
        final books = snapshot.data![0]['books'] as List<dynamic>? ?? const [];
        final authors = snapshot.data![1]['authors'] as List<dynamic>? ?? const [];
        final alphabeticalBooksList = [...books]
          ..sort((a, b) => (a['title'] as String? ?? '')
              .toLowerCase()
              .compareTo((b['title'] as String? ?? '').toLowerCase()));
        return BooksGrid(books: alphabeticalBooksList, authors: authors);
      },
      ),
    );
  }
}