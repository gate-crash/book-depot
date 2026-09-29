import 'dart:ui';
import '../apicall.dart';
import 'package:flutter/material.dart';

void setup() {
  runApp(const LocalDataScreen());
}
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});


dynamic get bookcases => ['Bookcase 1', 'Bookcase 2', 'Bookcase 3', 'Bookcase 4', 'Bookcase 5'];

  @override
Widget build(BuildContext context) {
  const title = 'Bookcases';

  return MaterialApp(
    title: title,
    home: Scaffold(
      appBar: AppBar(title: const Text(title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Your existing horizontal list
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            height: 400,
            width: double.infinity,
            child: ScrollConfiguration(
              behavior: const MaterialScrollBehavior().copyWith(
                dragDevices: {...PointerDeviceKind.values},
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final bookcase in bookcases)
                    Container(
                      width: 160,
                      margin: const EdgeInsets.all(8),
                      color: Colors.blue,
                      child: Center(child: Text(bookcase)),
                    ),
                ],
              ),
            ),
          ),

          // 2. Your new widget(s) below
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Widget below the horizontal list',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

        ],
      ),
    ),
  );
}
}