import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/bookcases/widgets/bookcase_landing.dart';
import 'package:bookdepot_client/ui/bookcases/models/bookcase.dart';
import 'package:bookdepot_client/data/models/themes.dart';

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
        return Padding(
          padding: EdgeInsetsGeometry.directional(
            top: 8.0,
            bottom: 8.0),
          child: ScrollConfiguration(
          behavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {...PointerDeviceKind.values},
          ),
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8.0), 
            itemCount: bookcases.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 375.0,
              crossAxisSpacing: 5.0,
              childAspectRatio: 0.7,// Set a fixed height for each grid item
              mainAxisSpacing: 5.0,
            ),
            itemBuilder: (context, index) {
              final bookcase = bookcases[index];
              
              return ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(12),
                clipBehavior: Clip.antiAlias,
                child: GestureDetector(
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
                  color: AppColors.gridBackground,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Image.asset(
                            'assets/images/bookcase.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        Text(
                            bookcase['case_name'] ??
                                'Bookcase ${bookcase['sequence_ordinal'] ?? ''}',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  )
                )
              );
            },
          )
        )
      );
    }
  }