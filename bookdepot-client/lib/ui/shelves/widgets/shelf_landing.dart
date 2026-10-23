import 'package:bookdepot_client/ui/authors/widgets/authors_widget.dart';
import 'package:bookdepot_client/ui/books/widgets/books_widget.dart';
import 'package:bookdepot_client/ui/shelves/models/shelf.dart';
import 'package:flutter/material.dart';

class ShelfLandingPage extends StatelessWidget {
  const ShelfLandingPage({super.key, required this.shelf});

  final Shelf shelf;

  @override
  Widget build(BuildContext context) {
    String title;
    if (shelf.caseName != null && shelf.caseName!.isNotEmpty) {
      title = shelf.id!;
    } else {
      title = 'Shelf ${shelf.id ?? ''}';
    }

 
    return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous screen
              },
            ),
            title: GestureDetector(
              onTap: () {
                // Pops all screens off the stack until it reaches the root screen
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Book Depot'),
            ),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 84, 47, 126),
            foregroundColor: Colors.white,
          ),
          // 3. Place the TabBarView in the body of the Scaffold
          body: Center(child: BooksGet(endpoint: '/books', payload: {'id': shelf},
              ),
          ),
    );
  }
}