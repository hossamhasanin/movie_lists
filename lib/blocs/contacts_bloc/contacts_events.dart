import 'package:equatable/equatable.dart';
import 'package:user_repo/user_repo.dart';

abstract class ContactsEvent extends Equatable{

  const ContactsEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadContacts extends ContactsEvent {}
class DeleteContact extends ContactsEvent {
  final User user;
  const DeleteContact({this.user});
  @override
  List<Object> get props => [user];
}
class AddContact extends ContactsEvent {
  final String query;
  const AddContact({this.query});
  @override
  List<Object> get props => [query];
}