
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {

  final String email;
  final String username;
  final String id;
  final String phone;
  final List addedBy;
  final List approvedBy;
  final List enteredLists;

  static User currentUser;

  User({this.id , this.email , this.username , this.phone , this.addedBy , this.approvedBy , this.enteredLists});

  @override
  // TODO: implement props
  List<Object> get props => [id , username , email , phone , addedBy , approvedBy , enteredLists];

  Map<String , dynamic> toMap(){
    return {
      "email": email,
      "username": username,
      "id": id,
      "phone": phone,
      "addedBy": addedBy,
      "approvedBy": approvedBy,
      "enteredLists": enteredLists
    };
  }

  User copyWith({String id, String username, String email , String phone , List addedBy, List approvedBy, List enteredLists}) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      addedBy: addedBy ?? this.addedBy,
      approvedBy: approvedBy?? this.approvedBy,
      enteredLists: enteredLists ?? this.enteredLists
    );
  }

  static User fromSnapshot(DocumentSnapshot userDoc){
    return User(id: userDoc.data()["id"] ?? "",
        username: userDoc.data()["username"] ?? "",
        email: userDoc.data()["email"] ?? "",
        phone: userDoc.data()["phone"] ?? "",
        addedBy: userDoc.data()["addedBy"] == null ? List<String>() : userDoc.data()["addedBy"],
        approvedBy: userDoc.data()["approvedBy"] == null ? List<String>() : userDoc.data()["approvedBy"],
        enteredLists: userDoc.data()["enteredLists"] == null ? List<String>() : userDoc.data()["enteredLists"]);
  }

}