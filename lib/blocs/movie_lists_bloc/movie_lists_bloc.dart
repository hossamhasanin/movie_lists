
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:movie_lists/blocs/movie_lists_bloc/movie_lists_event.dart';
import 'package:movie_lists/blocs/movie_lists_bloc/movie_lists_state.dart';
import 'package:movies_lists_repo/movies_lists_repo.dart';
import 'package:rxdart/transformers.dart';
import 'package:user_repo/user_repo.dart' as Us;

class MovieListBloc extends Bloc<MovieListsEvent , MovieListState>{

  MovieListRepo _repo;
  Us.UserRepo userRepo;
  final mAuth = FirebaseAuth.instance;
  RxList<Us.User> contacts = List<Us.User>().obs;
  Rx<ListsInit> shareStateController = ListsInit().obs;
  StreamSubscription listsSub;

  MovieListBloc({MovieListRepo repo , this.userRepo}) :
        _repo = repo,
        super(ListsInit());

  @override
  Stream<MovieListState> mapEventToState(MovieListsEvent event) async* {
    try{
      if (event is FetchList){
        if (listsSub != null){
          listsSub.cancel();
        }
        listsSub = _repo.lists(mAuth.currentUser.uid).listen((snapshot) {
          var movieLists = snapshot.docs.map((value) {
            return MovieList.fromEntity(MovieListEntity.fromSnapshot(value));
          }).toList();
          add(UpdateList(list: movieLists));
        });
      }else if (event is UpdateList){
        yield ListsLoaded(lists: event.list);
      }
    } catch (e){
      yield ListsLoadFailed(error: e.toString());
    }

    try{
      if (event is AddList){
        yield AddingList();
        yield* validateAddFields(event.title, event.desc);
        final list = MovieList(id : DateTime.now().millisecondsSinceEpoch.toString(),title: event.title , members: [mAuth.currentUser.uid] , desc: event.desc);
        await _repo.addNewList(list);
        yield AddedList();
      }
    } catch (e){
      yield AddListFailed(error: e.toString());
    }

    if (event is GetContacts){
      yield* getContacts(event);
    }

    if (event is ShareList){
      yield* shareList(event);
    }

  }

  Stream<MovieListState> getContacts(MovieListsEvent event)async*{
    try{
      shareStateController.value = GettingContacts();
      if (contacts.isEmpty){
        contacts.value = (await userRepo.getContacts()).docs.map((doc) {
          return Us.User.fromSnapshot(doc);
        }).toList();
        shareStateController.value = GotContacts(contacts: contacts);
      } else {
        shareStateController.value = GotContacts(contacts: contacts);
      }
    }catch(e){
      shareStateController.value = GotContactsFailed(error: e.toString());
    }
  }

  Stream<MovieListState> shareList(ShareList event) async* {
    try{
      shareStateController.value = SharingList();
      event.list.members.addAll(event.contacts);
      await _repo.updateList(event.list);
      shareStateController.value = SharedList();
    }catch(e){
      shareStateController.value = SharedListFailed(error: e.toString());

    }
  }

  Stream<MovieListState> validateAddFields(String title , String desc) async*{
    if (title == null || desc == null
        || title.isEmpty || desc.isEmpty || title.length < 3 || desc.length < 5){
      yield AddListFailed(error: "What the heck just try write title and description little bigger bro !");
    }
  }


  @override
  Future<void> close() {
    shareStateController.close();
    listsSub.cancel();
    return super.close();
  }

}