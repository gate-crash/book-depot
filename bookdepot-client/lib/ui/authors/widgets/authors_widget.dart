import 'dart:ui';
import 'package:bookdepot_client/data/models/server_api_model.dart';
import 'package:bookdepot_client/ui/authors/models/authors.dart';
import 'package:bookdepot_client/ui/authors/widgets/author_add_widget.dart';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/authors/widgets/author_landing.dart';


class AuthorsGet extends StatefulWidget {
  const AuthorsGet({super.key});

  @override
  State<AuthorsGet> createState() {
    return _AuthorsGetState();
  }
}

class _AuthorsGetState extends State<AuthorsGet> {
  // Store the future in a state variable so it doesn't refetch on every rebuild
  late Future<Map<String, dynamic>> _dataFuture;

  final ServerApiGet _serverApiService = ServerApiGet();
  
  @override
  void initState() {
    super.initState();
    _dataFuture = _serverApiService.serverDataGet('/authors', {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(onPressed: () {Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => AuthorAdd(
                      ),
                    ),
                  );},
                  child: const Icon(Icons.add)
                  ),
      body:FutureBuilder<Map<String, dynamic>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!['authors'] == null) {
          return const Center(child: Text('No data available'));
        }

        final authors = snapshot.data!['authors'] as List<dynamic>;

        return ScrollConfiguration(
          behavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {...PointerDeviceKind.values},
          ),
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10.0), 
            itemCount: authors.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 375.0,
              crossAxisSpacing: 5.0,
              childAspectRatio: 0.7,// Set a fixed height for each grid item
              mainAxisSpacing: 5.0,
            ),
            itemBuilder: (context, index) {
              final author = authors[index];
              final authorId = author['id'];
              final firstName = author['first_name']?.toString() ?? '';
              final lastName = author['last_name']?.toString() ?? '';
              final fullName = '$firstName $lastName'.trim();
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => AuthorLandingPage(
                        author: Author.fromJson(author),
                        authorId: authorId,
                      ),
                    ),
                  );
                },
                child: Container(
                  color: const Color.fromARGB(255, 69, 140, 199),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Image.asset(
                          'assets/images/bookcase.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(fullName.isEmpty ? 'Unknown Author': fullName,
                        textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(authorId,
                        textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
                              );
            },
          )
        );
      },
      )
    );
  }
}
