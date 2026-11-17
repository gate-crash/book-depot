import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/shelves/widgets/shelf_landing.dart';
import 'package:bookdepot_client/ui/shelves/models/shelf.dart';


class ShelvesGrid extends StatelessWidget {
  const ShelvesGrid({
    super.key,
    required this.shelves,
  });

  final List<dynamic> shelves;
   @override
  Widget build(BuildContext context) {
    if (shelves.isEmpty) {
      return const Center(child: Text('No books available'));
    }
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
                  color: const Color.fromARGB(255, 235, 234, 214),
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

  }
}