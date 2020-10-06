import 'package:equatable/equatable.dart';
import 'package:movies_lists_repo/movies_lists_repo.dart';
import 'package:user_repo/user_repo.dart';

abstract class MovieListState extends Equatable{

  const MovieListState();

  @override
  List<Object> get props => [];
}

class ListsLoading extends MovieListState {}
class AddingList extends MovieListState {}
class AddedList extends MovieListState {}
class AddListFailed extends MovieListState {
  final String error;
  const AddListFailed({this.error});
  @override
  List<Object> get props => [error];
}
class GettingContacts extends ListsInit {}
class GotContacts extends ListsInit {
  final List<User> contacts;
  GotContacts({this.contacts});
  @override
  List<Object> get props => [contacts];
}
class GotContactsFailed extends ListsInit {
  final String error;
  GotContactsFailed({this.error});
  @override
  List<Object> get props => [error];
}

class SharingList extends ListsInit {}
class SharedList extends ListsInit {}
class SharedListFailed extends ListsInit {
  final String error;
  SharedListFailed({this.error});
  @override
  List<Object> get props => [error];
}
class ListsInit extends MovieListState {}
class ListsLoadFailed extends MovieListState {
  final String error;
  const ListsLoadFailed({this.error});
  @override
  // TODO: implement props
  List<Object> get props => [error];
}
class ListsLoaded extends MovieListState {
  final List lists;
  const ListsLoaded({this.lists});

  @override
  List<Object> get props => [lists];

}