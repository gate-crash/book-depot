import 'package:flutter/material.dart';

import 'package:bookdepot_client/dataModels/bookcase.dart';

class BookcaseLandingPage extends StatelessWidget {
  const BookcaseLandingPage({super.key, required Bookcase bookcase}) : this.bookcase = bookcase;

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
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Welcome to the Bookcase Landing Page!')
          ),
        ],
      ),
  );
  }
}