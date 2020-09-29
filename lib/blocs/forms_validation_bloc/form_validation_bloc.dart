import 'dart:async';
import 'package:formz/formz.dart';
import 'package:movie_lists/models/email_form.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:movie_lists/blocs/forms_validation_bloc/form_states.dart';
import 'package:movie_lists/blocs/forms_validation_bloc/form_validation_events.dart';



class FormValidationBloc extends Bloc<FormEvent , FormStates>{
  FormValidationBloc() : super(const FormStates());

  @override
  Stream<Transition<FormEvent, FormStates>> transformEvents(
      Stream<FormEvent> events,
      TransitionFunction<FormEvent, FormStates> transitionFn,
      ) {
    final debounced = events
        .where((event) => event is! FormSubmitted)
        .debounceTime(const Duration(milliseconds: 300));
    return events
        .where((event) => event is FormSubmitted)
        .mergeWith([debounced]).switchMap(transitionFn);
  }

  @override
  Stream<FormStates> mapEventToState(FormEvent event) async* {
    if (event is EmailChanged){
      final email = Email.dirty(event.email);
      yield state.copyWith(email: email , status: Formz.validate([email , state.pass , state.username]));
    } else if (event is PasswordChanged){
      final pass = Email.dirty(event.pass);
      yield state.copyWith(pass: pass , status: Formz.validate([state.email , pass , state.username]));
    } else if (event is UserNameChanged){
      final username = Email.dirty(event.username);
      yield state.copyWith(username: username , status: Formz.validate([state.email , state.pass , username]));
    } else if (event is FormSubmitted){
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      // doing the login or sign up thing

      yield state.copyWith(status: FormzStatus.submissionSuccess);
    }
  }

}