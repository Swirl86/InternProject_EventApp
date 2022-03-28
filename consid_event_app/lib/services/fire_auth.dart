import 'package:consid_event_app/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

  Future signIn() async {
    try {
      return _auth.signInWithEmailAndPassword(
          email: Constants.emailAuth, password: Constants.password);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    await _auth.signOut();
  }
}
