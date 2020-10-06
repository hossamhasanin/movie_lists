import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:movie_lists/blocs/auth_blocs/auth_bloc.dart';
import 'package:movie_lists/blocs/auth_blocs/auth_events.dart';
import 'package:movie_lists/blocs/auth_blocs/auth_states.dart';
import '../main_page.dart';
import 'signup.dart';
class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  Animation animation , delayedAnimation , muchDelayedAnimation;
  AnimationController animationController;
  TextEditingController passController;
  TextEditingController emailController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    emailController = TextEditingController();
    passController = TextEditingController();

    animationController = AnimationController(duration: Duration(seconds: 3) , vsync: this);

    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        curve: Curves.fastOutSlowIn,
        parent: animationController
    ));

    delayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        curve: Interval(0.5 , 1.0 , curve: Curves.fastOutSlowIn),
        parent: animationController
    ));

    muchDelayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        curve: Interval(0.8 , 1.0 , curve: Curves.fastOutSlowIn),
        parent: animationController
    ));

  }

  @override
  void dispose() {
    animationController.dispose();
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    animationController.forward();


    return BlocProvider(
        create: (context){
          return KiwiContainer().resolve<AuthBloc>()..add(IsAuthenticated());
        } ,
      child: AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context , Widget child){
            return Scaffold(
              resizeToAvoidBottomPadding: false,
              body: BlocListener<AuthBloc , AuthState>(
                listener: (BuildContext context , AuthState state) => blocLiistenerAction(context, state),
                child: BlocBuilder<AuthBloc , AuthState>(
                  builder: (context , state){
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Transform(
                            transform: Matrix4.translationValues(animation.value * width, 0.0, 0.0),
                            child: Container(
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                                    child: Text(
                                      "Hello",
                                      style: TextStyle(
                                          fontSize: 80.0,fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(15.0, 175.0, 0.0, 0.0),
                                    child: Text(
                                      "There",
                                      style: TextStyle(
                                          fontSize: 80.0,fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(230.0, 175.0, 0.0, 0.0),
                                    child: Text(
                                      ".",
                                      style: TextStyle(
                                          fontSize: 80.0,fontWeight: FontWeight.bold,color: Theme.of(context).accentColor
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Transform(
                            transform: Matrix4.translationValues(delayedAnimation.value * width, 0.0, 0.0),
                            child: Container(
                              padding: EdgeInsets.only(top: 35.0 , left: 20.0 , right: 20.0),
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (value){
                                      context.bloc<AuthBloc>().add(EmailChanged(email: value));
                                    },
                                    decoration: InputDecoration(
                                        labelText: "Email",
                                        errorText: state.email.invalid ? "Invalid Email" : null,
                                        labelStyle: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.green)
                                        )
                                    ),
                                  ),
                                  SizedBox(height: 20.0,),
                                  TextFormField(
                                    controller: passController,
                                    onChanged: (value){
                                      context.bloc<AuthBloc>().add(PasswordChanged(pass: value));
                                    },
                                    decoration: InputDecoration(
                                        labelText: "Password",
                                        errorText: state.pass.invalid ? "Invalid Password" : null,
                                        labelStyle: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.green)
                                        )
                                    ),
                                    obscureText: true,
                                  ),
                                  SizedBox(height: 5.0),
                                  Container(
                                    alignment: Alignment(1.0 , 0),
                                    padding: EdgeInsets.only(top: 15.0 , left: 20.0),
                                    child: InkWell(
                                      child: Text(
                                        "Forgot Password",
                                        style: TextStyle(
                                            color: Theme.of(context).accentColor,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Montserrat",
                                            decoration: TextDecoration.underline
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30.0),
                                  Container(
                                    height: 40.0,
                                    child: GestureDetector(
                                      onTap: (){
                                        if (state is! Authenticating){
                                          passController.clear();
                                          emailController.clear();
                                          context.bloc<AuthBloc>().add(Login());
                                        }
                                      },
                                      child: Material(
                                        borderRadius: BorderRadius.circular(20.0),
                                        shadowColor: Theme.of(context).accentColor,
                                        color: Theme.of(context).primaryColor,
                                        child: Center(
                                          child: Text(
                                            "LOGIN",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Montserrat",
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Container(
                                    height: 40.0,
                                    color: Colors.transparent,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black,
                                              style: BorderStyle.solid,
                                              width: 1.0
                                          ),
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(20.0)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: ImageIcon(AssetImage("assets/facebook.png")),
                                          ),
                                          SizedBox(width: 10.0),
                                          Center(
                                            child: Text(
                                              "Login with facebook",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Montserrat"
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          Transform(
                            transform: Matrix4.translationValues(muchDelayedAnimation.value * width, 0.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "New ?",
                                  style: TextStyle(
                                      fontFamily: "Montserrat"
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return SignupPage();
                                        }));
                                  },
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          }
      ),
    );
  }
}

blocLiistenerAction(BuildContext context , AuthState state){
  print(state.toString());
  if (state is AuthFailed){
    print(state.error);
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(state.error),),
      );
  } else if (state is Authenticated) {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return MainPage();
        }));
  } else if (state is Authenticating){
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text("Wait ..."),),
      );
  }
}