
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_lists/screens/auth/login.dart';

AppBar appBar(String title , BuildContext context){
  return AppBar(
    title: Text(title , style: TextStyle(color: Colors.white),),
    centerTitle: true,
    actions: [
      IconButton(
        icon: Icon(Icons.logout , color: Colors.white,),
        onPressed: (){
          FirebaseAuth.instance.signOut();
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
            return LoginPage();
          }));
        },
      )
    ],
  );
}

ThemeData redTheme(){
  return ThemeData(
    primaryColorDark: Color(0xffD32F2F),
    primaryColor: Color(0xffF44336),
    primaryColorLight: Color(0xffFFCDD2),
    accentColor: Color(0xffFF4081),
  );
}

ThemeData orangeTheme(){
  return ThemeData(
    primaryColor: Colors.orange,
    primaryColorLight: Color(0xFFf09817),
    accentColor: Colors.deepOrange,
  );
}

