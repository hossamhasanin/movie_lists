import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:movie_lists/blocs/auth_blocs/auth_bloc.dart';
import 'package:movie_lists/blocs/auth_blocs/auth_events.dart';
import 'package:movie_lists/dependencies.dart';
import 'package:movie_lists/screens/TappedModel.dart';
import 'file:///F:/Projects/Android_projects/flutter/projects/movie_lists/lib/screens/auth/login.dart';

void main() {
  injectDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.blueAccent,
      ),
      home: Container(
        child: FutureBuilder(
          future: _initialization,
          builder: (context , snapshot){
            if (snapshot.hasError){
              return Center(child: Text(snapshot.error),);
            }

            if (snapshot.connectionState == ConnectionState.done){
              //injectDependencies();
              return BlocProvider<AuthBloc>(
                  create: (context){
                    return KiwiContainer().resolve<AuthBloc>()..add(IsAuthenticated());
                  },
                  child: LoginPage(),
                  );
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
