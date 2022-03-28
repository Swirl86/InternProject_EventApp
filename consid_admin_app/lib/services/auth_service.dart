import 'package:admin_app/shared/local_var.dart';
import 'package:admin_app/shared/reusables.dart';
import 'package:admin_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // auth change user stream
  Stream<UserModel?> get onAuthStateChanged {
    return _auth.authStateChanges().map(_userModelFromFirebase);
  }

  //create an userModel object based on Firebase User object
  UserModel? _userModelFromFirebase(User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  //sing in with email & password
  Future signIn(String email, String password, BuildContext context) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } catch (e) {
      showAlertDialog(context, LocalVar.errorLogin);
      return null;
    }
  }

  //sign out
  Future signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } catch (e) {
      showAlertDialog(context, LocalVar.errorLogout);
      return null;
    }
  }
}
