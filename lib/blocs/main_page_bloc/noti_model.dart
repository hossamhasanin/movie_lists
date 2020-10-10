 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Notification extends Equatable{
  final String id;
  final String title;
  final String body;
  final String collection;
  final String document;
  final List to;
  final Timestamp createdAt;

  const Notification({this.id , this.title , this.body , this.collection , this.document , this.to , this.createdAt});

  @override
  // TODO: implement props
  List<Object> get props => [id , title , body, collection , document , to , createdAt];


  Notification copyWith({String id , String title , String body , String collection , String document , List<String> to}){
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      collection: collection ?? this.collection,
      document: document ?? this.document,
      to: to == null ? this.to : to,
    );
  }

  Map<String ,  dynamic> toJson(){
    return {
      "id": this.id,
      "title": this.title,
      "body": this.body,
      "collection": this.collection,
      "document": this.document,
      "to": this.to,
      "createdAt": FieldValue.serverTimestamp()
    };
  }

  static Notification fromMap(Map<String , dynamic> map){
    return Notification(
      id: map["id"],
      title: map["title"],
      body: map["body"],
      collection: map["collection"],
      document: map["document"],
      to: map["to"],
      createdAt: map["createdAt"] ?? "",
    );
  }

  static Notification fromSnapshot(DocumentSnapshot snapshot){
    return Notification(
      id: snapshot.data()["id"],
      title: snapshot.data()["title"],
      body: snapshot.data()["body"],
      collection: snapshot.data()["collection"],
      document: snapshot.data()["document"],
      to: snapshot.data()["to"],
      createdAt: snapshot.data()["createdAt"],
    );
  }



}