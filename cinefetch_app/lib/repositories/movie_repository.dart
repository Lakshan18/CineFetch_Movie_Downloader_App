import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';

class MovieRepository {
  final CollectionReference _moviesCollection = FirebaseFirestore.instance
      .collection('movies');

  Stream<List<Movie>> getMovies() {
    return _moviesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Movie.fromFirestore(doc)).toList();
    });
  }

  Future<Movie> getMovieById(String id) async {
    final doc = await _moviesCollection.doc(id).get();
    return Movie.fromFirestore(doc);
  }

  Future<List<Movie>> getAllMovies() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('movies')
        .get();
    return snapshot.docs.map((doc) => Movie.fromFirestore(doc)).toList();
  }

  Future<void> addMovie(Movie movie) {
    return _moviesCollection.add(movie.toMap());
  }

  Future<void> updateMovie(String id, Movie movie) {
    return _moviesCollection.doc(id).update(movie.toMap());
  }

  Future<void> deleteMovie(String id) {
    return _moviesCollection.doc(id).delete();
  }
}
