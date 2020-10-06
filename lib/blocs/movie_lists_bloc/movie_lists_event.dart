import 'package:equatable/equatable.dart';
import 'package:movies_lists_repo/movies_lists_repo.dart';

abstract class MovieListsEvent extends Equatable {
  const MovieListsEvent();
  @override
  List<Object> get props => [];
}

class FetchList extends MovieListsEvent{}
class UpdateList extends MovieListsEvent{
  final List<MovieList> list;
  UpdateList({this.list});
  @override
  // TODO: implement props
  List<Object> get props => [list];
}
class FetchMoreLists extends MovieListsEvent{

  final lastItem;
  const FetchMoreLists({this.lastItem});

  @override
  List<Object> get props => [lastItem];

}
class AddList extends MovieListsEvent{
  final String title;
  final String desc;

  const AddList({this.title , this.desc});
}
class DeleteList extends MovieListsEvent{}
class GetContacts extends MovieListsEvent{}
class ShareList extends MovieListsEvent{
  final List<String> contacts;
  final MovieList list;

  const ShareList({this.contacts , this.list});
}