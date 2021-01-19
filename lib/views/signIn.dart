import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spam_chat/helper/helperFunctions.dart';
import 'package:spam_chat/services/auth.dart';
import 'package:spam_chat/services/database.dart';
import 'package:spam_chat/views/chatrooms.dart';

class SignIn extends StatefulWidget {
  final Function toggle;

  const SignIn({Key key, this.toggle}) : super(key: key);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();
  QuerySnapshot snapShotUserInfo;

  signUser() {
    if (formKey.currentState.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);
      databaseMethods
          .getUserByUseremail(emailTextEditingController.text)
          .then((val) {
        snapShotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(
            snapShotUserInfo.docs[0].data()["name"]);
      });

      setState(() {
        isLoading = true;
      });

      authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        if (val != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatScreen()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign In"),
        ),
        body: isLoading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.85,
                margin: EdgeInsets.only(top: 180, left: 30),
                decoration: BoxDecoration(
                    //color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? null
                                    : "Provide a valid emailId";
                              },
                              controller: emailTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Email",
                                icon: Icon(
                                  Icons.emoji_emotions_sharp,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              onChanged: (value) {},
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              obscureText: true,
                              validator: (val) {
                                return val.length > 6
                                    ? null
                                    : "Provide password with 6+ characters";
                              },
                              controller: passwordTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Password",
                                icon: Icon(
                                  Icons.security_sharp,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              onChanged: (value) {},
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 8.0),
                        child: Text(
                          "Forgot Password ?",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          signUser();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                          ),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(
                            "Log In",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          "Sign In with Google",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have account?",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "Register Now",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
  }
}
