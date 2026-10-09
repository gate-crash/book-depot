import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/bookcases.dart';

void main() {
  runApp(const MaterialApp(title: 'Navigation Basics', home: BookDepot()));
}

class BookDepot extends StatelessWidget {
  const BookDepot({super.key});

dynamic get bookcases => ['Bookcase 1', 'Bookcase 2', 'Bookcase 3', 'Bookcase 4', 'Bookcase 5', 'Bookcase 6', 'Bookcase 7', 'Bookcase 8', 'Bookcase 9', 'Bookcase 10'];

@override
Widget build(BuildContext context) {
  const title = 'Bookcases';

  return Scaffold(
      appBar: AppBar(title: const Text(title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Your existing horizontal list
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            height: 400,
            child: ScrollConfiguration(
              behavior: const MaterialScrollBehavior().copyWith(
                dragDevices: {...PointerDeviceKind.values},
              ),
              child: ListView(
  scrollDirection: Axis.horizontal,
  children: [
    for (final bookcase in bookcases)
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => BookcaseLandingPage(bookcase: bookcase),
            ),
          );
        },
        child: Container(
          width: 400,
          margin: const EdgeInsets.all(10),
          color: Colors.blue,
          child: Image.asset(
            'assets/images/bookcase.png',
            width: 180,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
      ),
  ],
),    ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Widget below the horizontal list',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
  );
}
}