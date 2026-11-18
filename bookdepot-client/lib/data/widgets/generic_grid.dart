import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/data/models/themes.dart';

class GenericGrid extends StatelessWidget {
  const GenericGrid({
    super.key,
    required this.gridviewList,
    required this.landingPageBuilder,
  });

  final List<dynamic> gridviewList;
  final Widget Function(Map<String, dynamic> item) landingPageBuilder;
   @override
  Widget build(BuildContext context) {
    if (gridviewList.isEmpty) {
      return const Center(child: Text('No items available'));
    }
        return Padding(
          padding: EdgeInsetsGeometry.all(8.0),
          child: ScrollConfiguration(
          behavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {...PointerDeviceKind.values},
          ),
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10.0), 
            itemCount: gridviewList.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 375.0,
              crossAxisSpacing: 5.0,
              childAspectRatio: 0.7,// Set a fixed height for each grid item
              mainAxisSpacing: 5.0,
            ),
            itemBuilder: (context, index) {
              final gridviewItem = gridviewList[index];
              
              return ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(12),
                clipBehavior: Clip.antiAlias,
                child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => landingPageBuilder(gridviewItem),
                    ),
                  );
                },
                child: Container(
                  color: AppColors.gridBackground,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                            gridviewItem['case_name'] ??
                                'Bookcase ${gridviewItem['sequence_ordinal'] ?? ''}',
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