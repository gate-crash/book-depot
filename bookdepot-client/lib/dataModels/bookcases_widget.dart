import 'dart:ui';

import 'package:bookdepot_client/bookcase_landing.dart';
import 'package:bookdepot_client/api/server_api_service.dart';
import 'package:flutter/material.dart';

import 'package:bookdepot_client/dataModels/bookcase.dart';

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
    return FutureBuilder<Map<String, dynamic>>(
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
            itemCount: bookcases.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, 
              crossAxisSpacing: 10.0,
              mainAxisExtent: 499,
              mainAxisSpacing: 10.0,
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
                        bookcase: Bookcase.fromJson(bookcase),
                      ),
                    ),
                  );
                },
                child: Container(
                  color: Colors.blue,
                  padding: const EdgeInsets.all(1.0),
                  child: Column(
                    // Stretches the children to fill the full width of the container
                    crossAxisAlignment: CrossAxisAlignment.stretch, 
                    children: [
                      Expanded(
                        child: Image.asset(
                          'assets/images/bookcase.png',
                          fit: BoxFit.contain,
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
    );
  }
}
