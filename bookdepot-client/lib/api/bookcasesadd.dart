import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BookcasesAdd(),
    );
  }
}

class BookcasesAdd extends StatefulWidget {
  const BookcasesAdd({super.key});

  @override
  State<BookcasesAdd> createState() => _BookcasesAddState();
}

class _BookcasesAddState extends State<BookcasesAdd> {
  // Store the future in a state variable so it doesn't refetch on every rebuild
  late final Future<Map<String, dynamic>> _dataFuture;

  Future<void> bookcasesPost() async {
  final url = Uri.parse('http://192.168.1.41:8000/bookcase/add');
  final Map<String, dynamic> payload = {
    'case_name': 'New Case',
  };



  final response = await http.put(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(payload),
  );

  if (response.statusCode == 200) {
    print('Successfully updated item.');
    
    if (response.body.isNotEmpty) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print('Response data: $responseData');
    }
  } else {
    print('Failed with status code: ${response.statusCode}');
    print('Response body: ${response.body}');
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
