import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spam_chat/views/signIn.dart';
import 'package:spam_chat/views/signUp.dart';

class Authenticate extends StatefulWidget {
  // final bool showSignIn;
  Authenticate({Key key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  // @override
  // void initState() {
  //   super.initState();
  //   var auth = FirebaseAuth.instance;
  //   // ignore: deprecated_member_use
  //   auth.onAuthStateChanged.listen((user) {
  //     if (user != null) {
  //       print("user is logged in");
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => ChatScreen()));
  //     } else {
  //       print("user is not logged in");
  //     }
  //   });
  // }

  bool showSignIn = true;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggle: toggleView);
    } else {
      return SignUp(toggle: toggleView);
    }
  }
}
