import 'dart:ui';

import 'package:bookdepot_client/bookcase_landing.dart';
import 'package:bookdepot_client/api/server_api_service.dart';
import 'package:flutter/material.dart';

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
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final shelf in shelves)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => BookcaseLandingPage(
                          bookcase: Bookcase.fromJson(shelf),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 400,
                    margin: const EdgeInsets.all(10),
                    color: Colors.blue,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/bookcase.png',
                          width: 180,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          shelf['case_name'] ??
                              'Shelf ${shelf['sequence_ordinal'] ?? ''}',
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
