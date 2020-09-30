
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/movie_model.dart';
import 'repo.dart';

const LISTS_LIMIT = 5;

class FirebaseMovieRepo implements MovieRepo{

  final listsCollection = FirebaseFirestore.instance.collection('lists');


  @override
  Future<void> addNewMovie(Movie movie , String listId) {
    return listsCollection.doc(listId).collection("movies").doc(movie.id).set(movie.toEntity().toDocument());
  }

  @override
  Future<void> deleteMovie(Movie movie , String listId) {
    return listsCollection.doc(listId).collection("movies").doc(movie.id).delete();
  }

  @override
  Future<QuerySnapshot> movies(String listId) {
    return listsCollection.doc(listId).collection("movies").orderBy("createdAt" , descending: true).get();
  }

  @override
  Future<void> updateMovie(Movie movie , String listId) {
    return listsCollection.doc(listId).collection("movies").doc(movie.id).update(movie.toEntity().toDocument());
  }

}