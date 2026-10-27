import 'dart:ui';
import 'package:bookdepot_client/ui/bookcases/widgets/bookcase_landing.dart';
import 'package:bookdepot_client/data/models/server_api_model.dart';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/bookcases/models/bookcase.dart';
import 'package:bookdepot_client/ui/bookcases/widgets/bookcase_add_widget.dart';

class BookcasesGetAddFlow extends StatefulWidget {
  const BookcasesGetAddFlow({super.key});

  @override
  State<BookcasesGetAddFlow> createState() {
    return _BookcasesGetAddFlowState();
  }
}

class _BookcasesGetAddFlowState extends State<BookcasesGetAddFlow> {
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the left
    mainAxisSize: MainAxisSize.min,               // Keeps the column compact
    children: [
          GestureDetector(
          onTap: () {
            // Pops all screens off the stack until it reaches the root screen
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: const Text('Book Depot'),
        ),
        Text(
        'Select a bookcase',
        style: TextStyle(fontSize: 14, color: Colors.white70),
      ),
        ]
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 84, 47, 126),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.large(onPressed: () {Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => BookcaseAdd(
                      ),
                    ),
                  );},
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

        return ScrollConfiguration(
          behavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {...PointerDeviceKind.values},
          ),
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10.0), 
            itemCount: bookcases.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 375.0,
              crossAxisSpacing: 5.0,
              childAspectRatio: 0.7,// Set a fixed height for each grid item
              mainAxisSpacing: 5.0,
            ),
            itemBuilder: (context, index) {
              final bookcase = bookcases[index];
              
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => BookcaseLandingPage(
                        bookcase: BookCase.fromJson(bookcase),
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
                        child: Text(
                          bookcase['case_name'] ??
                              'Bookcase ${bookcase['sequence_ordinal'] ?? ''}',
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
