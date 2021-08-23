import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email = "";
  String password = "";

  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      // loading animation
      body: ModalProgressHUD(
        // ModalProgressHUD show loading spinner while registering
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // flexible rise up all the widgets when the keyboard is shown
              // so that no widgets go under the keyboard
              Flexible(
                // hero widget to show nice animation
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
              // email text fieled
              TextField(
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                // make keyboard specified to write an email
                // e.g: make @ and .com appears beside space button
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: "Enter your email"),
              ),
              // some horizontal space
              SizedBox(
                height: 8.0,
              ),
              // password text field
              TextField(
                style: TextStyle(color: Colors.white),
                // make password invisible
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
              // register button
              RoundedButton(Colors.red, 'Register', () async {
                setState(() {
                  // show spinner while loading
                  showSpinner = true;
                });
                try {
                  // try to add the new user
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  if (newUser != null) {
                    Navigator.pushNamed(context, "/chat");
                  }
                  // stop loading animation
                  setState(() {
                    showSpinner = false;
                  });
                } catch (e) {
                  print(e);
                  setState(() {
                    showSpinner = false;
                  });
                  // show alert if user failed to register
                  Alert(
                      context: context,
                      title: "ERROR",
                      desc: "username or password are invalid. please try again with password at minimum 8 characters!"
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
