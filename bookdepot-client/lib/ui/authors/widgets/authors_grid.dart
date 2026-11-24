import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bookdepot_client/ui/authors/widgets/author_landing.dart';
import 'package:bookdepot_client/ui/authors/models/authors.dart';
import 'package:bookdepot_client/data/models/themes.dart';

class AuthorsGrid extends StatelessWidget {
  const AuthorsGrid({
    super.key,
    required this.authors, required this.sortedList,
  });
  
  final List<dynamic> authors;
  final List<dynamic> sortedList;
   @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {...PointerDeviceKind.values},
      ),
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        itemCount: sortedList.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 375.0,
          crossAxisSpacing: 5.0,
          childAspectRatio: 0.65,
          mainAxisSpacing: 5.0,
        ),
        itemBuilder: (context, index) {
          final author = sortedList[index];
          final authorId = author['id'];
          final name = author['name']?.toString() ?? '';
          final authorThumbnailPath =
              'https://covers.openlibrary.org/a/olid/$authorId-M.jpg';

          return ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(12),
                clipBehavior: Clip.antiAlias,
                child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => AuthorLandingPage(
                    author: Author.fromJson(author),
                    authorId: authorId,
                  ),
                ),
              );
            },
            child: Container(
              color: AppColors.gridBackground,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CachedNetworkImage(
                    imageUrl: authorThumbnailPath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/bookcase.png',
                      fit: BoxFit.fill,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
                )
          );
        },
      ),
    );
  }
}
