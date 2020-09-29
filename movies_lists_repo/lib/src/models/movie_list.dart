import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../../movies_lists_repo.dart';
import '../entities/entities.dart';

@immutable
class MovieList {
  final String id;
  final String title;
  final String desc;
  final List<String> members;
  final Timestamp createdAt;

  MovieList({ this.desc , String title = '', List<String> members = const [] , String id , this.createdAt})
      : this.title = title ?? '',
        this.members = members ?? [],
        this.id = id;

  MovieList copyWith({String id, String title, List<String> members , String desc}) {
    return MovieList(
      desc: desc ?? this.desc,
      id: id ?? this.id,
      title: title ?? this.title,
      members: members ?? this.members
    );
  }

  @override
  int get hashCode => desc.hashCode ^ title.hashCode ^ members.hashCode ^ id.hashCode ^ createdAt.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MovieList &&
              runtimeType == other.runtimeType &&
              desc == other.desc &&
              title == other.title &&
              members == other.members &&
              createdAt == other.createdAt &&
              id == other.id;

  @override
  String toString() {
    return 'Todo { desc: $desc, title: $title, id: $id }';
  }

  MovieListEntity toEntity() {
    return MovieListEntity(desc, id, title , members , null);
  }

  static MovieList fromEntity(MovieListEntity entity) {
    return MovieList(
      desc: entity.desc,
      title: entity.title,
      id: entity.id,
      members: entity.members,
      createdAt: entity.createdAt
    );
  }
}