import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:kiwi/kiwi.dart';
import 'package:movie_lists/blocs/auth_blocs/auth_bloc.dart';
import 'package:movie_lists/blocs/auth_blocs/auth_events.dart';
import 'package:movie_lists/dependencies.dart';
import 'package:movie_lists/screens/TappedModel.dart';
import 'package:movie_lists/screens/auth/login.dart';
import 'package:user_repo/user_repo.dart';

import 'screens/widgets/main_widgets.dart';

void main() {
  injectDependencies();
  User.currentUser = null;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: redTheme(),
      home: Container(
        child: FutureBuilder(
          future: _initialization,
          builder: (context , snapshot){
            if (snapshot.hasError){
              return Center(child: Text(snapshot.error),);
            }

            if (snapshot.connectionState == ConnectionState.done){
              //injectDependencies();
              return LoginPage();
            }

            return Center(
              child: CircularProgressIndicator(),
            );

          },
        ),
      ),
    );
  }
}
