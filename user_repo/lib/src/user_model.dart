
import 'package:equatable/equatable.dart';

class User extends Equatable {

  final String email;
  final String username;
  final String id;
  final String phone;

  User({this.id , this.email , this.username , this.phone});

  @override
  // TODO: implement props
  List<Object> get props => [id , username , email , phone];

  Map<String , dynamic> toMap(){
    return {
      "email": email,
      "username": username,
      "id": id,
      "phone": phone
    };
  }

  User copyWith({String id, String username, String email , String phone}) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone
    );
  }

}