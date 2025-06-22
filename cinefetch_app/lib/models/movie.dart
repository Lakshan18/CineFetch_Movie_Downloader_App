// models/movie.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  final String id;
  final String title;
  final String year;
  final String overview;
  final String genreType;
  final String duration;
  final String imdbRating;
  final String rottenRating;
  final String audienceRating;
  final String movieImgPath;
  final List<CastMember> cast;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.overview,
    required this.genreType,
    required this.duration,
    required this.imdbRating,
    required this.rottenRating,
    required this.audienceRating,
    required this.movieImgPath,
    required this.cast,
  });

  // Factory constructor to create a Movie from Firestore document
  factory Movie.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Movie(
      id: doc.id,
      title: data['title'] ?? '',
      year: data['year'] ?? '',
      overview: data['overview'] ?? '',
      genreType: data['genre_type'] ?? '',
      duration: data['duration'] ?? '',
      imdbRating: data['imdb_rating'] ?? '0.0',
      rottenRating: data['rotten_rating'] ?? '0%',
      audienceRating: data['audience_rating'] ?? '0%',
      movieImgPath: data['movie_img_path'] ?? '',
      cast: (data['cast'] as List<dynamic>? ?? [])
          .map((castData) => CastMember.fromMap(castData))
          .toList(),
    );
  }

  // Convert Movie to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'year': year,
      'overview': overview,
      'genre_type': genreType,
      'duration': duration,
      'imdb_rating': imdbRating,
      'rotten_rating': rottenRating,
      'audience_rating': audienceRating,
      'movie_img_path': movieImgPath,
      'cast': cast.map((member) => member.toMap()).toList(),
    };
  }
}

class CastMember {
  final String actor;
  final String character;
  final String? castImgPath;

  CastMember({
    required this.actor,
    required this.character,
    this.castImgPath,
  });

  factory CastMember.fromMap(Map<String, dynamic> map) {
    return CastMember(
      actor: map['actor'] ?? '',
      character: map['character'] ?? '',
      castImgPath: map['cast_img_path'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'actor': actor,
      'character': character,
      if (castImgPath != null) 'cast_img_path': castImgPath,
    };
  }
}