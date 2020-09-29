
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:movie_lists/blocs/auth_blocs/auth_events.dart';
import 'package:movie_lists/blocs/auth_blocs/auth_states.dart';
import 'package:movie_lists/models/email_form.dart';
import 'package:movie_lists/models/pass_form.dart';
import 'package:movie_lists/models/username_form.dart';
import 'package:user_repo/user_repo.dart';

class AuthBloc extends Bloc<AuthEvent , AuthState>{

  final UserRepo _userRepo;

  UserRepo get userRepo => _userRepo;

  AuthBloc({@required UserRepo userRepo}) :
        assert(userRepo != null),
        _userRepo = userRepo,
        super(InitState());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is EmailChanged) {
      final email = Email.dirty(event.email);
      final val = event.login ? Formz.validate([email, state.pass]) : Formz.validate([email, state.pass, state.username]);
      yield state.copyWith(email: email,
          status: val);
    } else if (event is PasswordChanged) {
      final pass = Password.dirty(event.pass);
      final val = event.login ? Formz.validate([state.email, pass]) : Formz.validate([state.email, pass, state.username]);
      yield state.copyWith(pass: pass,
          status: val);
    } else if (event is UserNameChanged) {
      final username = Username.dirty(event.username);
      print(username.value);
      yield state.copyWith(username: username,
          status: Formz.validate([state.email, state.pass, username]));
    } else if (event is IsAuthenticated) {
      if (_userRepo.isAuthenticated()){
        yield Authenticated();
      }
    }else {
      // doing the login or sign up thing
      print("auth_bloc ${state.toString()} = status : ${state.status} = username : ${state.username}");
      if (state.status != FormzStatus.invalid) {
        yield* mapEventsForAuth(event);
      } else {
        yield AuthFailed(error: "Not valid fields");
      }
    }
  }

  Stream<AuthState> mapEventsForAuth(AuthEvent event) async* {
    yield Authenticating();
    try{
      if (event is Login){
        await _userRepo.authenticate(state.email.value, state.pass.value);
        yield Authenticated();
      } else if (event is SignUp){
        User user = User(username: state.username.value , email: state.email.value);
        await _userRepo.signup(user, state.pass.value);
        yield Authenticated();
      }
    } catch(e){
      yield AuthFailed(error: e.toString());
    }
  }

}