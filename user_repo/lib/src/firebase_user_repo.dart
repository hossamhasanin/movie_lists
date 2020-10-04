
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repo/src/user_model.dart' as UserModel;
import 'user_repo.dart';

class FirebaseUserRepo implements UserRepo{

  final FirebaseAuth firebaseAuth;
  // UserModel.User cu = UserModel.User.currentUser;

  FirebaseUserRepo({this.firebaseAuth});
  final usersCollection = FirebaseFirestore.instance.collection("users");

  @override
  Future<void> authenticate(String email , String pass) async {
    return firebaseAuth.signInWithEmailAndPassword(email: email, password: pass);
  }

  @override
  String getUserId() {
    return this.firebaseAuth.currentUser.uid;
  }

  @override
  bool isAuthenticated() {
    final current = firebaseAuth.currentUser;
    return current != null;
  }

  @override
  Future<void> signup(UserModel.User user , String pass) async {
    final usersCollection = FirebaseFirestore.instance.collection("users");
    try{
      final l = await firebaseAuth.createUserWithEmailAndPassword(email: user.email, password: pass);
      UserModel.User u = user.copyWith(id: l.user.uid);
      return usersCollection.doc(l.user.uid).set(u.toMap());
    }catch (e){
      return Future.error(e);
    }
  }

  @override
  Future<QuerySnapshot> getContacts() {
    return usersCollection.where("addedBy" , arrayContains: firebaseAuth.currentUser.uid).get();
  }

  @override
  Future<QuerySnapshot> findContact(String query, String field) {
    return usersCollection.where(field , isEqualTo: query).get();
  }

  @override
  Future<void> addOrDeleteContact(UserModel.User user) {
    return usersCollection.doc(user.id).update(user.toMap());
  }

  @override
  Stream<DocumentSnapshot> getCurrentUser() {
    return usersCollection.doc(firebaseAuth.currentUser.uid).snapshots();
  }



}