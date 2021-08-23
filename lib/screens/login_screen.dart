import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      // loading animation
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                // hero widget to show a nice animation
                child: Hero(
                  tag: "logo",
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              // email text field
              TextField(
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: "Enter your email"),
              ),
              // some vertical space
              SizedBox(
                height: 8.0,
              ),
              // password text field
              TextField(
                style: TextStyle(color: Colors.white),
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: "Enter your password"),
              ),
              SizedBox(
                height: 24.0,
              ),
              // login button
              RoundedButton(Colors.redAccent, 'Log In', () async {
                setState(() {
                  showSpinner = true;
                });
                try {
                  // tru to get the user
                  final user = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  if (user != null) {
                    Navigator.pushNamed(context, "/chat");
                  }
                  // stop sppiner
                  setState(() {
                    showSpinner = false;
                  });
                } catch (e) {
                  setState(() {
                    showSpinner = false;
                  });
                  // show alert if user failed to login
                  Alert(
                      context: context,
                      title: "ERROR",
                      desc: "username or password are invalid. please try again!"
                  ).show();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
