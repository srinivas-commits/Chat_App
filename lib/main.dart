import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spam_chat/helper/authenticate.dart';
import 'package:spam_chat/helper/helperFunctions.dart';
import 'package:spam_chat/views/chatrooms.dart';

// project-136989755210
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userLogInfo = false;
  @override
  void initState() {
    getUserLogInfo();
    super.initState();
  }

  getUserLogInfo() {
    setState(() {
      HelperFunctions.getUserLoggedInSharedPreference().then((value) {
        userLogInfo = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spam Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //scaffoldBackgroundColor: Colors.red,
        primaryColor: Colors.pink[600],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userLogInfo ? ChatScreen() : Authenticate(),
    );
  }
}
