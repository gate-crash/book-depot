import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/data/models/themes.dart';

class GenericGrid extends StatelessWidget {
  const GenericGrid({
    super.key,
    required this.gridviewList,
    required this.landingPageBuilder,
    required this.itemType,
  });

  final List<dynamic> gridviewList;
  final Widget Function(Map<String, dynamic> item, String itemId,) landingPageBuilder;
  final dynamic itemType;
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
              final itemId = gridviewItem['id'];
              return ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(12),
                clipBehavior: Clip.antiAlias,
                child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => landingPageBuilder(gridviewItem, itemId),
                    ),
                  );
                },
                child: Container(
                  color: AppColors.gridBackground,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        if (itemType == 'Bookcase') ...[
                          Expanded(
                            child: Image.asset(
                              'assets/images/bookcase.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Text(
                            gridviewItem['name']?.toString() ??
                                '$itemType ${gridviewItem['case_name'] ?? ''}'.trim(),
                            textAlign: TextAlign.center,
                          ),
                          if (itemType == 'Shelf') ...[
                          Expanded(
                            child: Icon(
                              Icons.collections_bookmark,
                              size: 200,
                              color: const Color.fromARGB(255, 74, 243, 102),
                            ),
                          ),
                          Text(
                          gridviewItem['name'] ??
                              'Shelf ${gridviewItem['id'] ?? ''}',
                        )
                        ],
                        if (itemType == 'Book') ...[
                          Expanded(
                        child: CachedNetworkImage(
                                  imageUrl: gridviewItem['thumbnail_filename'] ?? '',
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/images/bookcase.png',
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                  ),
                                )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          gridviewItem['title'],
                        ),
                      ),
                        ]
                      ],
                      ]
                    )
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