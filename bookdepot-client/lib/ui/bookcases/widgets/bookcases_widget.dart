import 'package:bookdepot_client/data/models/server_api_model.dart';
import 'package:bookdepot_client/ui/bookcases/widgets/bookcase_landing.dart';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/bookcases/widgets/bookcase_add_widget.dart';
import 'package:bookdepot_client/ui/bookcases/widgets/bookcases_grid.dart';
import 'package:bookdepot_client/ui/bookcases/models/bookcase.dart';
import 'package:bookdepot_client/data/widgets/generic_grid.dart';

class BookcasesGet extends StatefulWidget {
  const BookcasesGet({super.key});

  @override
  State<BookcasesGet> createState() {
    return _BookcasesGetState();
  }
}

class _BookcasesGetState extends State<BookcasesGet> {
  // Store the future in a state variable so it doesn't refetch on every rebuild
  late Future<Map<String, dynamic>> _dataFuture;

  final ServerApiGet _serverApiService = ServerApiGet();
  
  @override
  void initState() {
    super.initState();
    _dataFuture = _serverApiService.serverDataGet('/bookcases', {});
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(onPressed: () async {
        final added = await Navigator.push<bool>(
        context,
        MaterialPageRoute<bool>(
          builder: (context) => BookcaseAdd(),
        ),
      );
      if (!mounted) return;

        if (added == true) {
          setState(() {
    _dataFuture = _serverApiService.serverDataGet('/bookcases', {});
          });
        }
      },
                  child: const Icon(Icons.add)
                  ),
      body: FutureBuilder<Map<String, dynamic>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!['bookcases'] == null) {
          return const Center(child: Text('No data available'));
        }

        final bookcases = snapshot.data!['bookcases'] as List<dynamic>;
        return GenericGrid(
          landingPageBuilder: (item) => BookcaseLandingPage(
            bookcase: BookCase.fromJson(item),
          ), gridviewList: bookcases,
        );
      },
      )
    );
  }
}
