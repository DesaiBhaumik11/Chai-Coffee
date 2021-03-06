import 'package:chai_coffee/Models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'database.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj base on firebaseUser
  UserFromFirebase _userFromFirebaseUser(User user){
    return user != null ? UserFromFirebase(uid: user.uid) : null;
  }

  // auth change stream
  Stream<UserFromFirebase> get user {
    return _auth.authStateChanges()
        //.map((User user) => _userFromFirebase(user));
    .map(_userFromFirebaseUser);
  }

  // sign in Anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      //create new document for user with uid
      await DatabaseService(uid: user.uid).updateUserData('0', 'New Chai Coffee User', 100);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}