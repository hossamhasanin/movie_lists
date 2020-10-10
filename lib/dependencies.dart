import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kiwi/kiwi.dart';
import 'package:movie_lists/blocs/auth_blocs/auth_bloc.dart';
import 'package:movie_lists/blocs/contacts_bloc/contacts_bloc.dart';
import 'package:movie_lists/blocs/main_page_bloc/main_page_bloc.dart';
import 'package:movie_lists/blocs/movie_lists_bloc/movie_lists_bloc.dart';
import 'package:movie_lists/contants.dart';
import 'package:movies_lists_repo/movies_lists_repo.dart';
import 'package:movies_repo/movies_repo.dart';
import 'package:user_repo/user_repo.dart';
import 'package:web_scraper/web_scraper.dart';
import 'blocs/movies_bloc/movies_bloc.dart';

injectDependencies(){
  KiwiContainer()
  ..registerFactory<UserRepo>((container) => FirebaseUserRepo(firebaseAuth: FirebaseAuth.instance))
  ..registerFactory<MovieListRepo>((container) => FirebaseMovieList())
  ..registerFactory<MovieRepo>((container) => FirebaseMovieRepo())
  ..registerFactory((container) => WebScraper(IMDB_URL))
  ..registerFactory((container) => MovieListBloc(repo: container.resolve() , userRepo: container.resolve()))
  ..registerFactory((container) => MovieBloc(movieRepo: container.resolve() , webScraper: container.resolve()))
  ..registerFactory((container) => ContactsBloc(userRepo: container.resolve()))
  ..registerFactory((container) => AuthBloc(userRepo: container.resolve()))
  ..registerFactory((container) => MainPageBloc(userRepo: container.resolve() , fcm: FirebaseMessaging()));
}