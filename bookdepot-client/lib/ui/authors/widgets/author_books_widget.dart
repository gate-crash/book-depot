import 'dart:ui';

import 'package:bookdepot_client/data/models/server_api_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/books/widgets/book_landing.dart';
import 'package:bookdepot_client/ui/books/models/book.dart';
import 'package:bookdepot_client/ui/bookcases/widgets/bookcases_widget_add_book.dart';
import 'package:bookdepot_client/ui/authors/models/authors.dart';

class FilteredBooksGet extends StatefulWidget {
  final String? endpoint;
  final String? authorId;

  final Author author;
  const FilteredBooksGet({super.key, this.endpoint, this.authorId, required this.author});

  @override
  State<FilteredBooksGet> createState() {
    return _FilteredBooksGetState();
  }
}

class _FilteredBooksGetState extends State<FilteredBooksGet> {
  // Store the future in a state variable so it doesn't refetch on every rebuild
  late Future<List<Map<String, dynamic>>> _dataFuture;

final ServerApiGet _serverApiService = ServerApiGet();
  final ServerApiGet _serverApiServerAuthor = ServerApiGet();
  
  @override
  void initState() {
    super.initState();
    final bookGetCall = _serverApiService.serverDataGet(widget.endpoint!, {});
    final authorGetCall = _serverApiServerAuthor.serverDataGet('/authors', {});
    _dataFuture = Future.wait([bookGetCall, authorGetCall]);
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        onPressed: ()
        {Navigator.push(
            context,
              MaterialPageRoute<void>(
                      builder: (context) => BookcasesGetAddFlow(
                      ),
              )
                  );
                  },
                  child: const Icon(Icons.add)
                  ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data![0]['books'] == null) {
          return const Center(child: Text('No data available'));
        }
        final books = snapshot.data![0]['books'] as List<dynamic>;
        final authors = snapshot.data![1]['authors'] as List<dynamic>;
        final authorId = widget.authorId;
        final filteredBooks = books.where((book) {
        final filteredBookMap = book as Map<String, dynamic>;
        return filteredBookMap['author'] == authorId;
      }).toList();

        return ScrollConfiguration(
          behavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {...PointerDeviceKind.values},
          ),
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10.0), 
            itemCount: filteredBooks.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 375.0,
              crossAxisSpacing: 5.0,
              childAspectRatio: 0.7,
              mainAxisSpacing: 5.0,
            ),
            itemBuilder: (context, index) {
              final book = filteredBooks[index];
               final author = authors[index];

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => BookLandingPage(
                        book: Book.fromJson(book),
                        author: Author.fromJson(author),
                      ),
                    ),
                  );
                },
                child: Container(
                  color: const Color.fromARGB(255, 69, 140, 199),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: CachedNetworkImage(
                                  imageUrl: book['thumbnail_filename'] ?? '',
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/images/bookcase.png',
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                  ),
                                )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          book['title'],
                        ),
                      ),
                      
                    ],
                  ),
                )
                              );
            },
          )
        );
      },
      ),
    );
  }
}