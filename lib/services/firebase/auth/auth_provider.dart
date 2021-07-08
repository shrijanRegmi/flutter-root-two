import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:root_two/models/firebase/user.dart';
import 'package:root_two/services/firebase/database/database_provider.dart';

class AuthProvider {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final _ref = FirebaseFirestore.instance;

  // sign in with email and password
  Future signInWithEmailAndPassword({
    @required final String email,
    @required final String password,
  }) async {
    try {
      final _result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final _user = _result.user;
      _userFromFirebase(_user);
      return null;
    } catch (e) {
      print(e.message);
      return e;
    }
  }

  // sign up with email and password
  Future signUpWithEmailAndPassword({
    @required final String name,
    @required final String email,
    @required final String password,
  }) async {
    try {
      final _result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final _user = _result.user;
      _userFromFirebase(_user);
      DatabaseProvider(uid: _user.uid)
          .sendUserDetails(name: name, email: email);
      return null;
    } catch (e) {
      print(e.message);
      return e;
    }
  }

  // signning with google
  Future signInWithGoogle() async {
    try {
      final _googleAccount = await _googleSignIn.signIn();
      if (_googleAccount != null) {
        final _googleAuthentication = await _googleAccount.authentication;
        final _cred = GoogleAuthProvider.credential(
          idToken: _googleAuthentication.idToken,
          accessToken: _googleAuthentication.accessToken,
        );
        final _result = await _auth.signInWithCredential(_cred);

        if (_result != null) {
          final _firebaseUser = _result.user;

          _userFromFirebase(_firebaseUser);

          final _userRef = _ref.collection('users').doc(_firebaseUser.uid);
          final _userSnap = await _userRef.get();

          if (!_userSnap.exists) {
            await DatabaseProvider(uid: _firebaseUser.uid).sendUserDetails(
              name: _googleAccount.displayName,
              email: _googleAccount.email,
            );
          }
        }

        print('Success: Signing in with google');
        return null;
      }
    } catch (e) {
      print(e);
      print('Error!!!: Signing in with google');
      return e;
    }
  }

  // sign out user
  Future signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn?.signOut();
    } catch (e) {
      print(e.message);
    }
  }

  // user from firebase
  AppUser _userFromFirebase(User _user) {
    return _user != null ? AppUser(uid: _user.uid) : null;
  }

  // stream of user
  Stream<AppUser> get initUserDetail {
    return _auth.authStateChanges().map(_userFromFirebase);
  }
}
