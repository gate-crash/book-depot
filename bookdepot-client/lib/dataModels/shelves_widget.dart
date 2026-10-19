import 'dart:ui';

import 'package:bookdepot_client/bookcase_landing.dart';
import 'package:bookdepot_client/api/server_api_service.dart';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/shelf_landing.dart';
import 'package:bookdepot_client/dataModels/bookcase.dart';

class ShelvesGet extends StatefulWidget {
  const ShelvesGet({super.key, required this.bookcaseId});

  final String bookcaseId;

  @override
  State<ShelvesGet> createState() {
    return _ShelvesGetState();
  }
}

class _ShelvesGetState extends State<ShelvesGet> {
  // Store the future in a state variable so it doesn't refetch on every rebuild
  late Future<Map<String, dynamic>> _dataFuture;

  final ServerApiGet _serverApiService = ServerApiGet();
  
  @override
  void initState() {
    super.initState();
    _dataFuture = _serverApiService.serverDataGet('/shelves', {"bookcase": widget.bookcaseId});
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
        } else if (!snapshot.hasData || snapshot.data!['shelves'] == null) {
          return const Center(child: Text('No data available'));
        }

        final shelves = snapshot.data!['shelves'] as List<dynamic>;

        return ScrollConfiguration(
          behavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {...PointerDeviceKind.values},
          ),
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10.0), 
            itemCount: shelves.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 375.0,
              crossAxisSpacing: 5.0,
              childAspectRatio: 0.7,// Set a fixed height for each grid item
              mainAxisSpacing: 5.0,
            ),
            itemBuilder: (context, index) {
              final shelf = shelves[index];

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => ShelfLandingPage(
                        shelf: Shelf.fromJson(shelf),
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
                        child: Icon(
                          Icons.collections_bookmark,
                          size: 200,
                          color: const Color.fromARGB(255, 74, 243, 102),
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          shelf['id'] ??
                              'Shelf ${shelf['sequence_ordinal'] ?? ''}',
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
