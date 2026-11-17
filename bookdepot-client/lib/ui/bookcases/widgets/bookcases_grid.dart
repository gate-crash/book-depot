import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/bookcases/widgets/bookcase_landing.dart';
import 'package:bookdepot_client/ui/bookcases/models/bookcase.dart';


class BookcasesGrid extends StatelessWidget {
  const BookcasesGrid({
    super.key,
    required this.bookcases,
  });

  final List<dynamic> bookcases;
   @override
  Widget build(BuildContext context) {
    if (bookcases.isEmpty) {
      return const Center(child: Text('No bookcases available'));
    }
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
                  color: const Color.fromARGB(255, 235, 234, 214),
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
        ); }
}