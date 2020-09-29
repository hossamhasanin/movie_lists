
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_lists/blocs/movie_lists_bloc/movie_lists_event.dart';
import 'package:movie_lists/blocs/movie_lists_bloc/movie_lists_state.dart';
import 'package:movies_lists_repo/movies_lists_repo.dart';
import 'package:rxdart/transformers.dart';

class MovieListBloc extends Bloc<MovieListsEvent , MovieListState>{

  MovieListRepo _repo;
  final mAuth = FirebaseAuth.instance;
  MovieListBloc({MovieListRepo repo}) :
        _repo = repo,
        super(ListsInit());

  @override
  Stream<MovieListState> mapEventToState(MovieListsEvent event) async* {
    try{
      if (event is FetchList){
        yield ListsLoading();
        yield* fetchLists(null);
      } else if (event is FetchMoreLists){
        yield* fetchLists(event.lastItem);
      }
    } catch (e){
      yield ListsLoadFailed(error: e.toString());
    }

    try{
      if (event is AddList){
        yield AddingList();
        yield* validateAddFields(event.title, event.desc);
        final list = MovieList(id : DateTime.now().millisecond.toString(),title: event.title , members: [mAuth.currentUser.uid] , desc: event.desc);
        await _repo.addNewList(list);
        yield AddedList();
        yield* fetchLists(null);
      }
    } catch (e){
      yield AddListFailed(error: e.toString());
    }
  }

  Stream<MovieListState> validateAddFields(String title , String desc) async*{
    if (title == null || desc == null
        || title.isEmpty || desc.isEmpty || title.length < 3 || desc.length < 5){
      yield AddListFailed(error: "What the heck just try write title and description little bigger bro !");
    }
  }

  Stream<MovieListState> fetchLists(lastItem) async* {
    List<MovieList> lists = await loadLists(lastItem);
    yield ListsLoaded(lists: lists);
  }

  Future<List> loadLists(lastItem) async{
    var lists = await _repo.lists(lastItem , mAuth.currentUser.uid);
    var movieLists = lists.docs.map((value) {
      return MovieList.fromEntity(MovieListEntity.fromSnapshot(value));
    }).toList();

    return Future.value(movieLists);
  }

}