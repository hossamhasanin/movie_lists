import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/movie_model.dart';
abstract class MovieRepo{
  Future<void> addNewMovie(Movie movie , String listId);

  Future<void> deleteMovie(Movie movie , String listId);

  Future<QuerySnapshot> movies(String listId);

  Future<void> updateMovie(Movie movie , String listId);
}