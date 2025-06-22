// import 'package:flutter/material.dart';
// import '../models/movie.dart';

// class MovieCard extends StatelessWidget {
//   final Movie movie;
//   final int maxTitleLength;

//   const MovieCard({
//     super.key,
//     required this.movie,
//     this.maxTitleLength = 16,
//   });

//   String _truncateTitle(String title) {
//     if (title.length <= maxTitleLength) return title;
//     return '${title.substring(0, maxTitleLength)}...';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final cardWidth = (screenWidth - 55) / 2;

//     return SizedBox(
//       width: cardWidth,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           AspectRatio(
//             aspectRatio: 0.7,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.asset(
//                 movie.imagePath,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Tooltip( // Add tooltip to show full title on long press
//                   message: movie.title,
//                   child: Text(
//                     _truncateTitle(movie.title),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       fontFamily: "Quicksand",
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   movie.year,
//                   style: TextStyle(
//                     color: Colors.grey[400],
//                     fontSize: 14,
//                     fontFamily: "Quicksand",
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../screens/movie_overview.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final int maxTitleLength;

  const MovieCard({super.key, required this.movie, this.maxTitleLength = 16});

  String _truncateTitle(String title) {
    if (title.length <= maxTitleLength) return title;
    return '${title.substring(0, maxTitleLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 55) / 2;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MovieOverview(movie: movie)),
        );
      },
      child: SizedBox(
        width: cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 0.7,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: movie.movieImgPath,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Tooltip(
                    message: movie.title,
                    child: Text(
                      _truncateTitle(movie.title),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Quicksand",
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    movie.year,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                      fontFamily: "Quicksand",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
