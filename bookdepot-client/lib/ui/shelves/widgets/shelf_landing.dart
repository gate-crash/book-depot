import 'package:bookdepot_client/ui/authors/widgets/authors_widget.dart';
import 'package:bookdepot_client/ui/shelves/models/shelf.dart';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/books/widgets/books_widget.dart';

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

 
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous screen
              },
            ),
            title: const Text('Book Depot'),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 16, 99, 30),
            foregroundColor: Colors.white,
            bottom: const TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              tabs: [
                Tab(icon: Icon(Icons.book), text: 'Books'),
                Tab(icon: Icon(Icons.book), text: 'All Books'),
                Tab(icon: Icon(Icons.plus_one), text: 'Authors'),
              ],
            ),
          ),
          // 3. Place the TabBarView in the body of the Scaffold
          body: TabBarView(
            children: [
              Center(child: BooksGet(
              endpoint: '/shelf/get-books',
              payload: {'shelf': shelf.id!},
            ),),
              Center(child: BooksGet(
              endpoint: '/books',
              payload: {},
            ),),
            Center(child: AuthorsGet(
              ),
              )
            ],
          ),
        ),
    );
  }
}