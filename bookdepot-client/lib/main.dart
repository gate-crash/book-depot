import 'package:flutter/material.dart';
import 'package:bookdepot_client/dataModels/bookcase_add_widget.dart';
import 'package:bookdepot_client/dataModels/bookcases_widget.dart';

void main() {
  runApp(const MaterialApp(title: 'Book Depot', home: BookDepot()));
}

class BookDepot extends StatelessWidget {
  const BookDepot({super.key});

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
            child: BookcasesGet(),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: BookcaseAdd(),
          ),
        ],
      ),
    );
  }
}
