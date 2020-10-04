
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:movie_lists/blocs/contacts_bloc/contacts_events.dart';
import 'package:movie_lists/blocs/contacts_bloc/contacts_states.dart';
import 'package:user_repo/user_repo.dart';

class ContactsBloc extends Bloc<ContactsEvent , ContactsState>{

  final UserRepo userRepo;
  Rx<ContactsState> adUcontactController = InitContactState().obs;
  final EMAIL_FLAG = "email";
  final PHONE_FLAG = "phoneNumber";
  final FALSE_ENTRY_FLAG = "error";


  ContactsBloc({this.userRepo}) : super(InitContactState());

  @override
  Stream<ContactsState> mapEventToState(ContactsEvent event) async*{
    if (event is LoadContacts){
      yield* loadContactsStream(event);
    } else if (event is AddContact){
      yield* addContact(event);
    } else if (event is DeleteContact){
      yield* deleteContact(event);
    }
  }

  Stream<ContactsState> loadContactsStream(LoadContacts event) async* {
    try{
      yield ContactsLoading();
      final List<User> contacts = (await userRepo.getContacts()).docs.map((doc){
        return User.fromSnapshot(doc);
      }).toList();
      yield ContactsLoaded(contacts: contacts);
    } catch (e){
      yield ContactsLoadFailed(error: e.toString());
    }
  }

  Stream<ContactsState> addContact(AddContact event)async* {
    adUcontactController.value = ContactAdding();
    try{
      final checkField = checkIsEmailOrPhoneNumber(event.query);
      print("koko from bloc > " + checkField);
      print("koko from bloc > " + event.query);
      if (checkField == FALSE_ENTRY_FLAG){ throw Exception("You must enter weather contact email or phone number ."); }
      final snapshots = await userRepo.findContact(event.query, checkField);
      if (snapshots.docs.length == 0) {
        throw Exception("not found user !");
      }
      final userDoc = snapshots.docs[0];
      User user = User.fromSnapshot(userDoc);

      print("koko from bloc > " + User.currentUser.id);
      //val
      if (user.addedBy.contains(User.currentUser.id)){
        throw Exception("You added this contact already");
      }

      if (User.currentUser.addedBy.contains(user.id)){
        user = user.copyWith(
            addedBy: user.addedBy+[User.currentUser.id],
            approvedBy: user.approvedBy+[User.currentUser.id]
        );
        User.currentUser = User.currentUser.copyWith(approvedBy: User.currentUser.approvedBy+[user.id]);
        // update my list of approved people
        await userRepo.addOrDeleteContact(User.currentUser);
      } else {
        user = user.copyWith(
            addedBy: user.addedBy+[User.currentUser.id]
        );
      }

      await userRepo.addOrDeleteContact(user);
      adUcontactController.value = ContactAdded();
      add(LoadContacts());
    }catch (e){
      print(e.toString());
      adUcontactController.value = ContactAddFailed(error: e.toString());
    }
  }
  Stream<ContactsState> deleteContact(DeleteContact event)async* {
    adUcontactController.value = ContactDeleting();
    try{
      event.user.addedBy.remove(User.currentUser.id);

      if (event.user.approvedBy.contains(User.currentUser.id)){
        event.user.approvedBy.remove(User.currentUser.id);
        User.currentUser.approvedBy.remove(event.user.id);
        await userRepo.addOrDeleteContact(User.currentUser);
      }else {
        await userRepo.addOrDeleteContact(event.user);
      }

      adUcontactController.value = ContactDeleted();
    }catch (e){
      print(e.toString());
      adUcontactController.value = ContactDeleteFailed(error: e.toString());
    }
  }
  String checkIsEmailOrPhoneNumber(String query){
    final _emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    );
    final _phoneRegex = RegExp(r'^[0-9]+$');
    if (_emailRegex.hasMatch(query.trim())){
      return EMAIL_FLAG;
    }
    if (_phoneRegex.hasMatch(query.trim())){
      return PHONE_FLAG;
    }

    return FALSE_ENTRY_FLAG;
  }

  @override
  Future<void> close() {
    adUcontactController.close();
    return super.close();
  }

}
//
// class ADUcontactController extends GetxController{
//   Rx<ContactsState> state;
//
// }