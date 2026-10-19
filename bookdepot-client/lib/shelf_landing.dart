import 'package:bookdepot_client/dataModels/shelves_widget.dart';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/dataModels/books_widget.dart';
import 'package:bookdepot_client/dataModels/bookcase.dart';
import 'package:bookdepot_client/dataModels/shelf_add_widget.dart';

class ShelfLandingPage extends StatelessWidget {
  const ShelfLandingPage({super.key, required this.shelf});

  final Shelf shelf;

  @override
  Widget build(BuildContext context) {
    String title;
    if (shelf.caseName != null && shelf.caseName!.isNotEmpty) {
      title = shelf.caseName!;
    } else {
      title = 'Shelf ${shelf.sequenceOrdinal ?? ''}';
    }

  return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          shelf['caseName'] ??
                              'Shelf ${shelf['sequence_ordinal'] ?? ''}',
                          textAlign: TextAlign.center,
                        ),
                      ),
          Expanded(
            child: BooksGet(shelfId: shelf.id!),
          ),
        ],
      ),
    );
  }
}