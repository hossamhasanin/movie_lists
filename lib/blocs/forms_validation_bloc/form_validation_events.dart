import 'package:equatable/equatable.dart';

abstract class FormEvent extends Equatable{
  const FormEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends FormEvent{
  final String email;

  const EmailChanged({this.email});

  @override
  List<Object> get props => [email];

}

class PasswordChanged extends FormEvent{
  final String pass;

  const PasswordChanged({this.pass});

  @override
  List<Object> get props => [pass];

}

class UserNameChanged extends FormEvent{
  final String username;

  const UserNameChanged({this.username});

  @override
  List<Object> get props => [username];

}

class FormSubmitted extends FormEvent {}
