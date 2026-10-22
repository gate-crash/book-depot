import 'package:bookdepot_client/ui/authors/widgets/authors_widget.dart';
import 'package:bookdepot_client/ui/shelves/widgets/shelves_widget.dart';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/books/widgets/books_widget.dart';
import 'package:bookdepot_client/ui/bookcases/models/bookcase.dart';


class BookcaseLandingPage extends StatelessWidget {
  const BookcaseLandingPage({super.key, required this.bookcase});

  final BookCase bookcase;

  @override
  Widget build(BuildContext context) {
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
                Tab(icon: Icon(Icons.book), text: 'Shelves'),
                Tab(icon: Icon(Icons.book), text: 'Books'),
                Tab(icon: Icon(Icons.add_box_outlined), text: 'Authors'),
              ],
            ),
          ),
          // 3. Place the TabBarView in the body of the Scaffold
          body: TabBarView(
            children: [
              Center(child: ShelvesGet(bookcaseId: bookcase.id!),),
              Center(child: BooksGet(
              endpoint: '/books',
              payload: {},
            ),),
              Center(child: AuthorsGet(),),
            ],
          ),
        ),
    );
  }
}