import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MovieListEntity extends Equatable {
  final String id;
  final String title;
  final String desc;
  final List members;
  final Timestamp createdAt;

  const MovieListEntity(this.desc, this.id, this.title , this.members ,  this.createdAt);

  // Map<String, Object> toJson() {
  //   return {
  //     "task": desc,
  //     "note": title,
  //     "id": id,
  //     "createdAt": FieldValue.serverTimestamp()
  //   };
  // }

  @override
  List<Object> get props => [id, title , members , desc , createdAt];

  @override
  String toString() {
    return 'TodoEntity { task: $desc, note: $title, id: $id }';
  }

  static MovieListEntity fromJson(Map<String, Object> json) {
    return MovieListEntity(
      json["desc"] as String,
      json["id"] as String,
      json["title"] as String,
      json["members"] as List<String>,
      json["createdAt"] as Timestamp
    );
  }

  static MovieListEntity fromSnapshot(DocumentSnapshot snap) {
    return MovieListEntity(
      snap.data()['desc'],
      snap.id,
      snap.data()["title"],
      snap.data()["members"],
      snap.data()["createdAt"]
    );
  }

  Map<String, Object> toDocument() {
    return {
      "id": id,
      "title": title,
      "desc": desc,
      "members": members,
      "createdAt" : FieldValue.serverTimestamp()
    };
  }
}