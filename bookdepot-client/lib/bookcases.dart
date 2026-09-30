import 'package:flutter/material.dart';

void main() => runApp(const BookcaseLandingPage());
class BookcaseLandingPage extends StatelessWidget {
  const BookcaseLandingPage({super.key, bookcase});

  @override
  Widget build(BuildContext context) {
  const title = 'Bookcases';

  return Scaffold(
      appBar: AppBar(title: const Text(title)),
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