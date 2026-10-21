import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/bookcases/widgets/bookcase_add_widget.dart';
import 'package:bookdepot_client/ui/bookcases/widgets/bookcases_widget.dart';
import 'package:bookdepot_client/ui/books/widgets/books_widget.dart';
import 'package:bookdepot_client/ui/authors/widgets/authors_widget.dart';

void main() {
  runApp(const MaterialApp(title: 'Book Depot', home: BookDepot()));
}

class BookDepot extends StatelessWidget {
  const BookDepot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Book Depot'),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 16, 99, 30),
            foregroundColor: Colors.white,
            bottom: const TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              tabs: [
                Tab(icon: Icon(Icons.shelves), text: 'Bookcases'),
                Tab(icon: Icon(Icons.book), text: 'Books'),
                Tab(icon: Icon(Icons.book), text: 'Authors'),
                Tab(icon: Icon(Icons.add_box_outlined), text: 'Add Bookcase'),
              ],
            ),
          ),
          // 3. Place the TabBarView in the body of the Scaffold
          body: TabBarView(
            children: [
              Center(child: BookcasesGet(),),
              Center(child: BooksGet(
              endpoint: '/books',
              payload: {},
            ),),
              Center(child: AuthorsGet()),
              Center(child: BookcaseAdd(),),
            ],
          ),
        ),
      ),
    );
  }
}