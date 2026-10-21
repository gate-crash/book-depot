import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/books/models/book.dart';


class BookLandingPage extends StatelessWidget {
  const BookLandingPage({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Center(
      child:  Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.book),
                  title: Text(book.title!),
                  subtitle: Text(book.author!),
                ),
                Image.asset('assets/images/odyssey.jpg'),
              ],
            ),
          ),
    );
  }
}