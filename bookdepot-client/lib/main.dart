import 'package:flutter/material.dart';
import 'package:bookdepot_client/dataModels/bookcase_add_widget.dart';
import 'package:bookdepot_client/dataModels/bookcases_widget.dart';


void main() {
  runApp(const MaterialApp(title: 'Book Depot', home: BookDepot()));
}

class BookDepot extends StatelessWidget {
  const BookDepot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 110, 160, 248),
            foregroundColor: Colors.white,
            bottom: const TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              tabs: [
                Tab(icon: Icon(Icons.book), text: 'Bookcases'),
                Tab(icon: Icon(Icons.add_box_outlined), text: 'Add Bookcase'),
              ],
            ),
          ),
          // 3. Place the TabBarView in the body of the Scaffold
          body: const TabBarView(
            children: [
              Center(child: BookcasesGet(),),
              Center(child: BookcaseAdd(),),
            ],
          ),
        ),
      ),
    );
  }
}