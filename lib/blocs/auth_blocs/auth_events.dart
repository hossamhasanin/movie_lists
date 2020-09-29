
import 'package:equatable/equatable.dart';
import 'package:user_repo/user_repo.dart';

abstract class AuthEvent extends Equatable{
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class Login extends AuthEvent{}

class SignUp extends AuthEvent {}

class IsAuthenticated extends AuthEvent{}

class EmailChanged extends AuthEvent{
  final String email;
  final bool login;

  const EmailChanged({this.email , this.login = true});

  @override
  List<Object> get props => [email , login];

}

class PasswordChanged extends AuthEvent{
  final String pass;
  final bool login;

  const PasswordChanged({this.pass , this.login = true});

  @override
  List<Object> get props => [pass , login];

}

class UserNameChanged extends AuthEvent{
  final String username;

  const UserNameChanged({this.username});

  @override
  List<Object> get props => [username];

}

// class FormSubmitted extends AuthEvent {}
