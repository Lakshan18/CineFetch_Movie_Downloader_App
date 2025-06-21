import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TMDBApiService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> fetchMovie(int tmdbId) async {
    try {
      final apiKey = dotenv.get('TMDB_API_KEY');
      final response = await _dio.get(
        'https://api.themoviedb.org/3/movie/$tmdbId',
        queryParameters: {'api_key': apiKey, 'append_to_response': 'credits'},
      );

      final data = response.data;
      final credits = data['credits'] ?? {};

      return {
        'title': data['title'] ?? 'Unknown',
        'year': data['release_date']?.split('-')[0] ?? 'N/A',
        'imdb_rating': data['vote_average']?.toString() ?? '0.0',
        'rotten_rating': 'N/A',
        'audience_rating': 'N/A',
        'overview': data['overview'] ?? 'No description',
        'movie_img_path': data['poster_path'] != null
            ? 'https://image.tmdb.org/t/p/w500${data['poster_path']}'
            : null,
        'cast': (credits['cast'] as List?)?.take(5).map((actor) => {
              'actor': actor['name'] ?? 'Unknown',
              'character': actor['character'] ?? 'Unknown',
              'cast_img_path': actor['profile_path'] != null
                  ? 'https://image.tmdb.org/t/p/w200${actor['profile_path']}'
                  : null,
            }).toList() ?? [],
      };
    } catch (e) {
      throw Exception('Failed to fetch movie: $e');
    }
  }
}