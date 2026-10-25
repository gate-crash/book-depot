import 'package:bookdepot_client/ui/shelves/widgets/shelves_widget.dart';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/bookcases/models/bookcase.dart';


class BookcaseLandingPage extends StatelessWidget {
  const BookcaseLandingPage({super.key, required this.bookcase});

  final BookCase bookcase;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: GestureDetector(
          onTap: () {
            // Pops all screens off the stack until it reaches the root screen
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: const Text('Book Depot'),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 84, 47, 126),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ShelvesGet(bookcaseId: bookcase.id!),
      ),
    );
  }
}