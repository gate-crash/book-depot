import 'package:bookdepot_client/dataModels/shelves_widget.dart';
import 'package:flutter/material.dart';

import 'package:bookdepot_client/dataModels/bookcase.dart';
import 'package:bookdepot_client/dataModels/shelf_add_widget.dart';

class BookcaseLandingPage extends StatelessWidget {
  const BookcaseLandingPage({super.key, required this.bookcase});

  final Bookcase bookcase;

  @override
  Widget build(BuildContext context) {
    String title;
    if (bookcase.caseName != null && bookcase.caseName!.isNotEmpty) {
      title = bookcase.caseName!;
    } else {
      title = 'Bookcase ${bookcase.sequenceOrdinal ?? ''}';
    }

  return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ShelfAdd(bookcaseId: bookcase.id!),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ShelvesGet(bookcaseId: bookcase.id!),
          ),
        ],
      ),
    );
  }
}