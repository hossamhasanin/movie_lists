
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies_lists_repo/src/models/movie_list.dart';

import '../movies_lists_repo.dart';
import '../movies_lists_repo.dart';


const LISTS_LIMIT = 5;

class FirebaseMovieList implements MovieListRepo{

  final listsCollection = FirebaseFirestore.instance.collection('lists');

  @override
  Future<void> addNewList(MovieList list) {
    return listsCollection.doc(list.id).set(list.toEntity().toDocument());
  }

  @override
  Future<void> deleteList(MovieList list) {
    return listsCollection.doc(list.id).delete();
  }

  @override
  Stream<QuerySnapshot> lists(String userId) {
    return listsCollection.where("members" , arrayContains: userId).orderBy("createdAt" , descending: true).snapshots();
  }

  @override
  Future<void> updateList(MovieList list) {
    return listsCollection.doc(list.id).update(list.toEntity().toDocument());
  }

}