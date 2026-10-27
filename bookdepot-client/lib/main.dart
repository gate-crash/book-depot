import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/bookcases/widgets/bookcases_widget.dart';
import 'package:bookdepot_client/ui/books/widgets/books_widget.dart';
import 'package:bookdepot_client/ui/books/widgets/all_books_widget.dart';
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
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Book Depot'),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 84, 47, 126),
            foregroundColor: Colors.white,
          ),
          // 3. Place the TabBarView in the body of the Scaffold
          body: TabBarView(
            children: [
              Center(child: BookcasesGet(),),
              Center(child: AllBooksGet(
                  endpoint: '/books', 
                  payload: {},
                ),),
              Center(child: AuthorsGet()),
            ],
          ),
          bottomNavigationBar: const Material(
              color: Color.fromARGB(255, 84, 47, 126),
              child: SafeArea(
                bottom: true,
                child: TabBar(
              labelColor: Color.fromARGB(255, 170, 255, 66),
              unselectedLabelColor: Color.fromARGB(255, 236, 241, 237),
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(icon: Icon(Icons.shelves), text: 'Bookcases'),
                Tab(icon: Icon(Icons.book), text: 'Books'),
                Tab(icon: Icon(Icons.book), text: 'Authors'),
              ],
            ),
             )  
        ),
      ),
      )
    );
  }
}
