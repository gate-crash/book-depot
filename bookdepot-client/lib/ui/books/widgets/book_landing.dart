import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/books/widgets/books_widget.dart';
import 'package:bookdepot_client/ui/books/widgets/book_add_widget.dart';
import 'package:bookdepot_client/ui/books/models/book.dart';


class BookLandingPage extends StatelessWidget {
  const BookLandingPage({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    String title;
    title = book.title!;
 
    return DefaultTabController(
        length: 2,
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
                Tab(icon: Icon(Icons.book), text: 'Book'),
                Tab(icon: Icon(Icons.book), text: 'All Books'),
              ],
            ),
          ),
          // 3. Place the TabBarView in the body of the Scaffold
          body: TabBarView(
            children: [
              Center(child: BooksGet(
              endpoint: '/books/find_by_title',
              payload: {'title': book.title!},
            ),),
              Center(child: BooksGet(
              endpoint: '/books',
              payload: {},
            ),),
            Center(child: BookAdd(
              shelfId: book.id!,
              ),
              )
            ],
          ),
        ),
    );
  }
}