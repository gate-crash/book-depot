import 'package:bookdepot_client/ui/books/widgets/books_widget.dart';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/shelves/models/shelf.dart';


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
      appBar: AppBar(title: Text(title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(
            child: BooksGet(shelfId: shelf.id!),
          ),
        ],
      ),
    );
  }
}