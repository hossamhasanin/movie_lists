import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:movies_repo/movies_repo.dart';

abstract class MoviesEvent extends Equatable{
  const MoviesEvent();

  @override
  List<Object> get props => [];
}

class AddMovie extends MoviesEvent{
  final String url;
  final String listId;
  const AddMovie({this.url , this.listId});
  @override
  // TODO: implement props
  List<Object> get props => [url , listId];
}

class LoadMovies extends MoviesEvent{
  final String listId;
  const LoadMovies({this.listId});
  @override
  // TODO: implement props
  List<Object> get props => [listId];
}

class LoadMoreMovies extends MoviesEvent{
  final String listId;
  final Movie lastItem;
  const LoadMoreMovies({this.listId , this.lastItem});
  @override
  // TODO: implement props
  List<Object> get props => [listId , lastItem];
}