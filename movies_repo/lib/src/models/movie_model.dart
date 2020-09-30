
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:movies_repo/src/entities/entities.dart';

class Movie extends Equatable{
  final String id;
  final String title;
  final String img;
  final String story;
  final Timestamp createdAt;

  const Movie({this.id , this.title , this.img , this.story , this.createdAt});

  @override
  // TODO: implement props
  List<Object> get props => [id , title , img , story , createdAt];

  Movie copyWith({String id, String title, String img , String story}) {
    return Movie(
        story: story ?? this.story,
        id: id ?? this.id,
        title: title ?? this.title,
        img: img ?? this.img
    );
  }


  MovieEntity toEntity() {
    return MovieEntity(story: story, id: id, title: title , img: img , createdAt: null);
  }

  static Movie fromEntity(MovieEntity entity) {
    return Movie(
        story: entity.story,
        title: entity.title,
        id: entity.id,
        img: entity.img,
        createdAt: entity.createdAt
    );
  }

}