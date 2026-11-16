import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/books/widgets/book_landing.dart';
import 'package:bookdepot_client/ui/books/models/book.dart';
import 'package:bookdepot_client/ui/authors/models/authors.dart';


class BooksGrid extends StatelessWidget {
  const BooksGrid({
    super.key,
    required this.books,
    required this.authors,
  });

  final List<dynamic> books;
  final List<dynamic> authors;
   @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const Center(child: Text('No books available'));
    }
    final authorsById = {
      for (final author in authors) author['id']: author,
    };
        return ScrollConfiguration(
          behavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {...PointerDeviceKind.values},
          ),
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10.0), 
            itemCount: books.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 375.0,
              crossAxisSpacing: 5.0,
              childAspectRatio: 0.7,
              mainAxisSpacing: 5.0,
            ),
            itemBuilder: (context, index) {
              final book = books[index];
              final author = authors.firstWhere(
                (author) => author['id'] == book['author'],
              );
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => BookLandingPage(
                        book: Book.fromJson(book),
                        author: Author.fromJson(author)
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
          ),
        );
  }
}