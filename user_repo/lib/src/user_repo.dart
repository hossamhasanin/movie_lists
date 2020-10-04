
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_repo/src/user_model.dart' as UserModel;

abstract class UserRepo{
  bool isAuthenticated();

  Future<void> authenticate(String email , String pass);

  Future<void> signup(UserModel.User user , String pass);

  Stream<DocumentSnapshot> getCurrentUser();

  Future<QuerySnapshot> getContacts();

  Future<QuerySnapshot> findContact(String query , String field);

  Future<void> addOrDeleteContact(UserModel.User user);
  // Future<void> cuAddApprovedContact();

  String getUserId();
}