import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LocalDataScreen(),
    );
  }
}

class LocalDataScreen extends StatefulWidget {
  const LocalDataScreen({super.key});

  @override
  State<LocalDataScreen> createState() => _LocalDataScreenState();
}

class _LocalDataScreenState extends State<LocalDataScreen> {
  // Store the future in a state variable so it doesn't refetch on every rebuild
  late final Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchLocalJson();
  }

  Future<Map<String, dynamic>> fetchLocalJson() async {
    // Note: Use 'http://192.168.1.41:8000/get-bookcases' for Android Emulator
    final url = Uri.parse('http://192.168.1.41:8000/get-bookcases');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load data (${response.statusCode})');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local API Response')),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _dataFuture,
          builder: (context, snapshot) {
            // 1. Loading State
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: Colors.blue
              );
            }            // 3. Success State
            if (snapshot.hasData) {
              final response = snapshot.data;
              if (response != null){
                return Text('Bookcases: ${response['bookcases']}');
              }
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            else{
              return Text('No data found');
            }

          },
        ),
      ),
    );
  }
}