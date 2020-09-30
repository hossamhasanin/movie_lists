
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MovieEntity extends Equatable{
  final String id;
  final String title;
  final String img;
  final String story;
  final Timestamp createdAt;

  const MovieEntity({this.id , this.title , this.img , this.story , this.createdAt});

  @override
  // TODO: implement props
  List<Object> get props => [id , title , img , story , createdAt];

  static MovieEntity fromJson(Map<String, Object> json) {
    return MovieEntity(
        title: json["title"] as String,
        id : json["id"] as String,
        story: json["story"] as String,
        img: json["img"] as String,
        createdAt: json["createdAt"] as Timestamp
    );
  }

  static MovieEntity fromSnapshot(DocumentSnapshot snap) {
    return MovieEntity(
        title: snap.data()['title'],
        id: snap.id,
        story: snap.data()["story"],
        img: snap.data()["img"],
        createdAt: snap.data()["createdAt"]
    );
  }

  Map<String, Object> toDocument() {
    return {
      "id": id,
      "title": title,
      "story": story,
      "img": img,
      "createdAt" : FieldValue.serverTimestamp()
    };
  }

}