
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:movie_lists/models/email_form.dart';
import 'package:movie_lists/models/pass_form.dart';
import 'package:movie_lists/models/username_form.dart';

class AuthState extends Equatable {

  final Email email;
  final Username username;
  final Password pass;
  final FormzStatus status;

  const AuthState({
    this.email = const Email.pure() , this.pass = const Password.pure(), this.username = const Username.pure(), this.status = FormzStatus.pure});

  @override
  List<Object> get props => [email , pass , username];

  AuthState copyWith({email , pass , username , status}){
    return AuthState(
        email: email ?? this.email,
        pass: pass ?? this.pass,
        username: username ?? this.username,
        status: status ?? this.status
    );
  }
}

class InitState extends AuthState{}

class Authenticating extends AuthState{}

class Authenticated extends AuthState{}

class AuthFailed extends AuthState {
  String error;
  AuthFailed({this.error});
}



