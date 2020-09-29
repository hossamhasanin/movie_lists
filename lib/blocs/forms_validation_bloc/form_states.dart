import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:movie_lists/models/email_form.dart';
import 'package:movie_lists/models/pass_form.dart';
import 'package:movie_lists/models/username_form.dart';

class FormStates extends Equatable{

  final Email email;
  final Username username;
  final Password pass;
  final FormzStatus status;

  const FormStates({
    this.email , this.pass , this.username , this.status = FormzStatus.pure});

  @override
  List<Object> get props => [email , pass , username];

  FormStates copyWith({email , pass , username , status}){
    return FormStates(
      email: email ?? this.email,
      pass: pass ?? this.pass,
      username: username ?? this.username,
      status: status ?? this.status
    );
  }
}