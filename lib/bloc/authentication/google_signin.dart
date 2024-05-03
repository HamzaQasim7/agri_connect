import 'dart:async';
import 'dart:io';

import 'package:farmassist/ui/extensions/custom_snackbar.dart';
import 'package:farmassist/ui/home_page.dart';
import 'package:farmassist/ui/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/authentication/repositories/authentication_repository.dart';

class GoogleSignInHelper {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();

  Future<void> handleGoogleBtnClick(BuildContext context) async {
    try {
      final user = await signInWithGoogle(context);
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        context.showCustomSnackBar('Successfully logged in using Google');
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        context.showCustomSnackBar('Login failed');
      }
    } catch (error) {
      print('Error during Google sign-in: $error');
      context.showCustomSnackBar('Error occurred, please try again');
    }
  }

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in with Google: $e');
      throw e;
    }
  }

  Future<void> signOutGoogle(BuildContext context) async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    } catch (e) {
      print('Error signing out from Google: $e');
      context.showCustomSnackBar('Error occurred during sign-out');
    }
  }
}
