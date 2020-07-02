import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/round_button.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:status_alert/status_alert.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 130.0,
                ),
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Enter Email'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Enter Password'),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  color: Colors.lightBlueAccent,
                  title: 'Login',
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (user != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      setState(() {
                        showSpinner = false;
                      });
                      switch (e.code) {
                        case "ERROR_INVALID_EMAIL":
                          StatusAlert.show(
                            context,
                            duration: Duration(seconds: 2),
                            title: 'Login Error',
                            subtitle: 'Invalid Email',
                            configuration: IconConfiguration(icon: Icons.close),
                          );
                          break;

                        case "ERROR_WRONG_PASSWORD":
                          StatusAlert.show(
                            context,
                            duration: Duration(seconds: 2),
                            title: 'Login Error',
                            subtitle: 'Invalid Password',
                            configuration: IconConfiguration(icon: Icons.close),
                          );
                          break;
                        case "ERROR_USER_NOT_FOUND":
                          StatusAlert.show(
                            context,
                            duration: Duration(seconds: 2),
                            title: 'Login Error',
                            subtitle: 'User Not 404',
                            configuration: IconConfiguration(icon: Icons.close),
                          );
                          break;
                        default:
                          StatusAlert.show(
                            context,
                            duration: Duration(seconds: 2),
                            title: 'Login Error',
                            subtitle: '$e',
                            configuration: IconConfiguration(icon: Icons.close),
                          );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
