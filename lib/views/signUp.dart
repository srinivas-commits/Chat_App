import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spam_chat/helper/helperFunctions.dart';
import 'package:spam_chat/services/auth.dart';
import 'package:spam_chat/services/database.dart';
import 'package:spam_chat/views/chatrooms.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  const SignUp({Key key, this.toggle}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  signUser() {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        "name": userNameTextEditingController.text,
        "email": emailTextEditingController.text
      };

      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);

      HelperFunctions.saveUserNameSharedPreference(
          userNameTextEditingController.text);

      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) {
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        databaseMethods.uploadUserInfo(userInfoMap);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
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
                              return val.isEmpty || val.length < 4
                                  ? "letters is less than 6"
                                  : null;
                            },
                            controller: userNameTextEditingController,
                            decoration: InputDecoration(
                              hintText: "User name",
                              icon: Icon(
                                Icons.emoji_emotions,
                                color: Colors.blueGrey,
                              ),
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (value) {},
                          ),
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
                                Icons.email,
                                color: Colors.blueGrey,
                              ),
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (value) {},
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
                      height: 40.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        signUser();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          "Sign Up",
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
                        "Sign Up with Google",
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
                          "Already have account?",
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
                              "Log In",
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
            ),
    );
  }
}
