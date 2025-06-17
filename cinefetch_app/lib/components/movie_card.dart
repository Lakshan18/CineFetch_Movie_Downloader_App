import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final int maxTitleLength;

  const MovieCard({
    super.key, 
    required this.movie,
    this.maxTitleLength = 16,
  });

  String _truncateTitle(String title) {
    if (title.length <= maxTitleLength) return title;
    return '${title.substring(0, maxTitleLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 55) / 2;

    return Container(
      width: cardWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 0.7,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                movie.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Tooltip( // Add tooltip to show full title on long press
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
    );
  }
}