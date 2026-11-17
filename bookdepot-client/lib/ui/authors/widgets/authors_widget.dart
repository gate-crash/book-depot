import 'dart:ui';
import 'package:bookdepot_client/data/models/server_api_model.dart';
import 'package:bookdepot_client/ui/authors/models/authors.dart';
import 'package:bookdepot_client/ui/authors/widgets/author_add_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/authors/widgets/author_landing.dart';
import 'package:bookdepot_client/ui/authors/widgets/authors_grid.dart';

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
      floatingActionButton: FloatingActionButton.large(onPressed: () async {
        final added = await Navigator.push<bool>(
        context,
        MaterialPageRoute<bool>(
          builder: (context) => AuthorAdd(),
        ),
      );
      if (!mounted) return;
        if (added == true) {
          setState(() {
    _dataFuture = _serverApiService.serverDataGet('/authors', {});
          });
        }
      },
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
        final alphabeticalAuthorsList = [...authors]
          ..sort((a, b) => (a['first_name'] as String? ?? '')
              .toLowerCase()
              .compareTo((b['first_name'] as String? ?? '').toLowerCase()));
                return AuthorsGrid(authors: authors, sortedList: alphabeticalAuthorsList,);
      },
      )
    );
  }
}
