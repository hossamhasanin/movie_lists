
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies_lists_repo/src/models/movie_list.dart';

abstract class MovieListRepo{
  Future<void> addNewList(MovieList list);

  Future<void> deleteList(MovieList list);

  Future<QuerySnapshot> lists(MovieList lastItem , String userId);

  Future<void> updateList(MovieList list);
}