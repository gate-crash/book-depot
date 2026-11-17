import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/bookcases/widgets/bookcases_widget.dart';
import 'package:bookdepot_client/ui/books/widgets/books_widget.dart';
import 'package:bookdepot_client/ui/authors/widgets/authors_widget.dart';
import 'package:bookdepot_client/data/models/themes.dart';

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
            backgroundColor: AppColors.navigationBar,
            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
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
            ],
          ),
          bottomNavigationBar: const Material(
              color:  AppColors.navigationBar,
              child: SafeArea(
                bottom: true,
                child: TabBar(
              labelColor: Color.fromARGB(221, 37, 15, 15),
              unselectedLabelColor: Color.fromARGB(255, 80, 82, 78),
              indicatorColor: Color.fromARGB(255, 0, 0, 0),
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
