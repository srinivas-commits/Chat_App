import 'package:firebase_auth/firebase_auth.dart';
import 'package:spam_chat/models/user.dart';

class AuthMethods {
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUse _userFromFirebaseUser(User user) {
    return user != null ? AppUse(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User fireBaseUser = result.user;
      return _userFromFirebaseUser(fireBaseUser);
    } catch (msg) {
      print(msg.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User fireBaseUser = result.user;
      return _userFromFirebaseUser(fireBaseUser);
    } catch (msg) {
      print(msg.toString());
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (msg) {
      print(msg.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (msg) {
      print(msg.toString());
    }
  }
}
