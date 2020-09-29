import 'package:firebase_auth/firebase_auth.dart';
import 'package:kiwi/kiwi.dart';
import 'package:movie_lists/blocs/auth_blocs/auth_bloc.dart';
import 'package:movie_lists/blocs/movie_lists_bloc/movie_lists_bloc.dart';
import 'package:movies_lists_repo/movies_lists_repo.dart';
import 'package:user_repo/user_repo.dart';

injectDependencies(){
  KiwiContainer()
  ..registerFactory<UserRepo>((container) => FirebaseUserRepo(firebaseAuth: FirebaseAuth.instance))
  ..registerFactory<MovieListRepo>((container) => FirebaseMovieList())
  ..registerFactory((container) => MovieListBloc(repo: container.resolve()))
  ..registerFactory((container) => AuthBloc(userRepo: container.resolve()));
}