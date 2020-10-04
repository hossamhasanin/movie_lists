
import 'package:equatable/equatable.dart';
import 'package:user_repo/user_repo.dart';

abstract class ContactsState extends Equatable{
  const ContactsState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class InitContactState extends ContactsState {}
class ContactsLoading extends ContactsState {}
class ContactsLoadFailed extends ContactsState {
  final String error;
  const ContactsLoadFailed({this.error});
  @override
  // TODO: implement props
  List<Object> get props => [error];
}
class ContactsLoaded extends ContactsState {
  final List<User> contacts;
  const ContactsLoaded({this.contacts});
  @override
  // TODO: implement props
  List<Object> get props => [contacts];
}

class ContactAdded extends InitContactState{}
class ContactAdding extends InitContactState{}
class ContactAddFailed extends InitContactState{
  final String error;
  ContactAddFailed({this.error});
  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class ContactDeleted extends InitContactState{}
class ContactDeleting extends InitContactState{}
class ContactDeleteFailed extends InitContactState{
  final String error;
  ContactDeleteFailed({this.error});
  @override
  // TODO: implement props
  List<Object> get props => [error];
}