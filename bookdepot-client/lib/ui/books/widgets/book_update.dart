import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/books/models/book.dart';
import 'package:bookdepot_client/ui/authors/models/authors.dart';
import 'package:bookdepot_client/ui/authors/widgets/author_landing.dart';
import 'package:bookdepot_client/data/models/themes.dart';
import 'package:bookdepot_client/data/models/server_api_model.dart';

class BookUpdatePage extends StatefulWidget {
  const BookUpdatePage({super.key, required this.book, required this.author});
  final Book book;
  final Author author;
 
  @override
  State<BookUpdatePage> createState() => _BookUpdateState();
}

class _BookUpdateState extends State<BookUpdatePage> {
  final TextEditingController _bookNameInput = TextEditingController();
  final TextEditingController _bookAuthorInput = TextEditingController();
  final TextEditingController _bookFormatInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bookNameInput.text = widget.book.title ?? '';
    _bookAuthorInput.text = widget.author.name ?? '';
    _bookFormatInput.text = widget.book.format ?? '';
  }

  @override
  void dispose() {
    _bookNameInput.dispose();
    _bookAuthorInput.dispose();
    _bookFormatInput.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final author = widget.author;
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
            foregroundColor: AppColors.childPageHeader,
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
                ),
                
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: 
                  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _bookNameInput,
                  decoration: const InputDecoration(
                    hintText: 'Book Title',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _bookAuthorInput,
                  decoration: const InputDecoration(
                    hintText: 'Author ID...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _bookFormatInput,
                  decoration: const InputDecoration(
                    hintText: 'Physical Format',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filled(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final bookName = _bookNameInput.text.trim();
                  final bookAuthor = _bookAuthorInput.text.trim();
                  final bookPhysicalFormat = _bookFormatInput.text.trim();
                  final api = ServerApiPost();
                  final response1 = await api('/book/update', {'id': book.id, 'title': bookName, 'author': book.author, 'format': bookPhysicalFormat});
                  if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added "$bookName" - successfully!')),
                  );
                  if (!mounted) return;
Navigator.pop(context, true);
                  _bookNameInput.clear();
                  _bookAuthorInput.clear();
                  _bookFormatInput.clear();
                }
                },
              ),
            ],

          ),
        ),
        )
      ],
                  ),
                );
      }
}