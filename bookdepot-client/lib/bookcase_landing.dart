import 'package:bookdepot_client/dataModels/shelves_widget.dart';
import 'package:flutter/material.dart';

import 'package:bookdepot_client/dataModels/bookcase.dart';
import 'package:bookdepot_client/dataModels/shelf_add_widget.dart';


class BookcaseLandingPage extends StatelessWidget {
  const BookcaseLandingPage({super.key, required this.bookcase});

  final Shelf bookcase;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
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
                Tab(icon: Icon(Icons.book), text: 'Shelves'),
                Tab(icon: Icon(Icons.add_box_outlined), text: 'Add Shelf'),
              ],
            ),
          ),
          // 3. Place the TabBarView in the body of the Scaffold
          body: TabBarView(
            children: [
              Center(child: ShelvesGet(bookcaseId: bookcase.id!),),
              Center(child: ShelfAdd(bookcaseId: bookcase.id!),),
            ],
          ),
        ),
      ),
    );
  }
}