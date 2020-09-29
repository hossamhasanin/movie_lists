import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:movie_lists/blocs/auth_blocs/auth_bloc.dart';
import 'package:movie_lists/blocs/auth_blocs/auth_events.dart';
import 'package:movie_lists/blocs/auth_blocs/auth_states.dart';
import 'package:user_repo/user_repo.dart';

import '../../main.dart';
import '../main_page.dart';
import 'login.dart';

class SignupPage extends StatefulWidget {

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _controller;
  // TextEditingController emailController;
  // TextEditingController usernameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = TextEditingController();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: BlocProvider<AuthBloc>(
          create: (_) => KiwiContainer().resolve<AuthBloc>(),
          child: BlocListener<AuthBloc , AuthState>(
              listener: (BuildContext context , AuthState state) => blocLiistenerAction(context, state),
              child: BlocBuilder<AuthBloc , AuthState>(
                builder: (context , state){
                  return SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      Container(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                              child: Text(
                                'Signup',
                                style:
                                TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(260.0, 125.0, 0.0, 0.0),
                              child: Text(
                                '.',
                                style: TextStyle(
                                    fontSize: 80.0,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).accentColor),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _controller,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value){
                                  context.bloc<AuthBloc>().add(EmailChanged(email: value , login: false));
                                },
                                decoration: InputDecoration(
                                    labelText: 'EMAIL',
                                    errorText: state.email.invalid ? "Invalid Email" : null,
                                    labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                    // hintText: 'EMAIL',
                                    // hintStyle: ,
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.green))),
                              ),
                              SizedBox(height: 10.0),
                              TextFormField(
                                controller: _controller,
                                onChanged: (value){
                                  context.bloc<AuthBloc>().add(PasswordChanged(pass: value , login: false));
                                },
                                decoration: InputDecoration(
                                    labelText: 'PASSWORD ',
                                    errorText: state.pass.invalid ? "Try write stronger password":null,
                                    labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.green))),
                                obscureText: true,
                              ),
                              SizedBox(height: 10.0),
                              TextFormField(
                                controller: _controller,
                                onChanged: (value){
                                  context.bloc<AuthBloc>().add(UserNameChanged(username: value));
                                },
                                decoration: InputDecoration(
                                    labelText: 'UserName',
                                    errorText: state.username.invalid ? "Try write different username":null,
                                    labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.green))),
                              ),
                              SizedBox(height: 50.0),
                              Container(
                                  height: 40.0,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (state is! Authenticating){
                                        _controller.clear();
                                        context.bloc<AuthBloc>().add(SignUp());
                                      }
                                    },
                                    child: Material(
                                      borderRadius: BorderRadius.circular(20.0),
                                      shadowColor: Theme.of(context).accentColor,
                                      color: Theme.of(context).primaryColor,
                                      elevation: 7.0,
                                      child: Center(
                                        child: Text(
                                          'SIGNUP',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat'),
                                        ),
                                      ),
                                    ),
                                  )),
                              SizedBox(height: 20.0),
                              Container(
                                height: 40.0,
                                color: Colors.transparent,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black,
                                          style: BorderStyle.solid,
                                          width: 1.0),
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(20.0)),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Center(
                                      child: Text('Go Back',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat')),
                                    ),


                                  ),
                                ),
                              ),
                            ],
                          )),
                    ]),
                  );
                },
              )
          ),
        )
    );
  }
}