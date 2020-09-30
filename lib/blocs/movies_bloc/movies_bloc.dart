
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_lists/blocs/movies_bloc/movies_enents.dart';
import 'package:movie_lists/blocs/movies_bloc/movies_states.dart';
import 'package:movie_lists/contants.dart';
import 'package:movies_repo/movies_repo.dart';
import 'package:web_scraper/web_scraper.dart';


class MovieBloc extends Bloc<MoviesEvent , MoviesState>{

  final WebScraper webScraper;
  final MovieRepo movieRepo;

  StreamController addWatcher = StreamController<AddState>();

  MovieBloc({this.webScraper , this.movieRepo}) : super(InitMoviesState());

  @override
  Stream<MoviesState> mapEventToState(MoviesEvent event) async* {
    if (event is AddMovie){
      yield* addMovie(event);
    } else if (event is LoadMovies){
      yield* loadMoviesEvents(event);
    }
  }


  Future<List<Movie>> loadMovies(String listId) async {
    final query = await movieRepo.movies(listId);
    final movies = query.docs.map((doc) {
      return Movie.fromEntity(MovieEntity.fromSnapshot(doc));
    }).toList();

    return Future.value(movies);
  }

  Stream<MoviesState> loadMoviesEvents(LoadMovies event) async*{
    try{
      yield LoadingMovies();
      final movies = await loadMovies(event.listId);
      print("movies $movies");
      yield LoadedMovies(movies: movies);
    }catch (e){
      yield LoadMoviesFailed(error: e.toString());
    }
  }

  Stream<MoviesState> addMovie(AddMovie event) async* {
    try{
      addWatcher.add(AddingMovie());
      final prepUrl = event.url.replaceAll(IMDB_URL, "");
      if (await webScraper.loadWebPage(prepUrl)) {
        final movieTitle = webScraper.getElement(
            "head > meta[name='title']"
            , ["content"]);
        print("title is > $movieTitle");
        final moviePoster = webScraper.getElement(
            "head > link[rel='image_src']", ["href"]);
        print("poster is > $moviePoster");
        final movieStory = webScraper.getElement(
            "head > meta[name='description']"
            ,["content"]);
        print("story is > $movieStory");
        final movie = Movie(title: movieTitle[0]["attributes"]["content"],
            img: moviePoster[0]["attributes"]["href"],
            story: movieStory[0]["attributes"]["content"],
            id: DateTime
                .now()
                .millisecondsSinceEpoch
                .toString());
        await movieRepo.addNewMovie(movie, event.listId);
        addWatcher.add(AddedMovie());

        final movies = await loadMovies(event.listId);
        yield LoadedMovies(movies: movies);
      } else {
        addWatcher.add(AddMovieFailed(error: "Can not load url !!"));
      }
    } catch(e){
      addWatcher.add(AddMovieFailed(error: e.toString()));
    }
  }

}