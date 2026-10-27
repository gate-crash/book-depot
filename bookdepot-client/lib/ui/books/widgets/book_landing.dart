import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/books/models/book.dart';


class BookLandingPage extends StatelessWidget {
  const BookLandingPage({super.key, required this.book});

  final Book book;

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
          // 3. Place the TabBarView in the body of the Scaffold
          body: Column(
              mainAxisSize: .min,
              children: [
                ListTile(
                  leading: Icon(Icons.book),
                  title: Text(book.title!,),
                  subtitle: Text(book.author!),
                ),
                Flexible(
                child: Image.asset('assets/images/bookcase.png',
                fit: BoxFit.contain,
                ),
                )
              ],
          )
    );
      }
}