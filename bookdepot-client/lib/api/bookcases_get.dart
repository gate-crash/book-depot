import 'dart:convert';
import 'dart:ui';

import 'package:bookdepot_client/bookcases.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchLocalJson();
  }

  Future<Map<String, dynamic>> fetchLocalJson() async {
    // Note: Use 'http://localhost:8000/bookcases' for Android Emulator
    final url = Uri.parse('http://localhost:8000/bookcases');
    var response = await http.get(url);
    print(response.toString());

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load data (${response.statusCode})');
    }
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
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final bookcase in bookcases)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) =>
                            BookcaseLandingPage(bookcase: bookcase),
                      ),
                    );
                  },
                  child: Container(
                    width: 400,
                    margin: const EdgeInsets.all(10),
                    color: Colors.blue,
                    child: Image.asset(
                      'assets/images/bookcase.png',
                      width: 180,
                      height: 200,
                      fit: BoxFit.cover,
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
