import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/books/models/book.dart';
import 'package:bookdepot_client/ui/authors/models/authors.dart';
import 'package:bookdepot_client/ui/authors/widgets/author_landing.dart';
import 'package:bookdepot_client/data/models/themes.dart';

class BookLandingPage extends StatelessWidget {
  const BookLandingPage({super.key, required this.book, required this.author});
  
  final Book book;
  final Author author;
 

  @override
  Widget build(BuildContext context) {
    final authorName = author.name as String;
    
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
            backgroundColor: AppColors.navigationBar,
            foregroundColor: Colors.white,
          ),
          // 3. Place the TabBarView in the body of the Scaffold
          body: Column(
              mainAxisSize: .min,
              children: [
                ListTile(
                  leading: Icon(Icons.book),
                  title: Text(book.title!,),
                  subtitle: GestureDetector(
          onTap: () {
            // Pops all screens off the stack until it reaches the root screen
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => AuthorLandingPage(
                    author: author,
                    authorId: author.id,
                  ),
                ),
              );
          },
          child: Text(authorName),
                ),
                      ),
                Flexible(
                child: CachedNetworkImage(
                                  imageUrl: book.thumbnailFilename ?? '',
                                  fit: BoxFit.contain,
                                  width: 250,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/images/bookcase.png',
                                    fit: BoxFit.contain,
                                  ),
                                )
                )
                
              ],
          )
    );
      }
}