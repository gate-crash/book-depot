import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/authors/models/authors.dart';


class AuthorLandingPage extends StatelessWidget {
  const AuthorLandingPage({super.key, required this.author});

  final Author author;

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
                  leading: Icon(Icons.person_3_outlined),
                  title: Text(author.id!,),
                ),
                Flexible(
                child: Image.asset('assets/images/odyssey.jpg',
                fit: BoxFit.contain,
                ),
                )
              ],
          )
    );
      }
}