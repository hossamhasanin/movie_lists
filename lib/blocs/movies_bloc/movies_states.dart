
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:movies_repo/movies_repo.dart';

abstract class MoviesState extends Equatable{
  const MoviesState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class InitMoviesState extends MoviesState{}

abstract class AddState {

}
class AddingMovie extends AddState{
}
class AddedMovie extends AddState{
}
class AddMovieFailed extends AddState{
  final String error;
  AddMovieFailed({this.error });
}

class LoadingMovies extends MoviesState{}
class LoadedMovies extends MoviesState{
  final List<Movie> movies;
  const LoadedMovies({this.movies});
  @override
  // TODO: implement props
  List<Object> get props => [movies];
}
class LoadMoviesFailed extends MoviesState{
  final String error;
  const LoadMoviesFailed({this.error});
  @override
  // TODO: implement props
  List<Object> get props => [error];
}