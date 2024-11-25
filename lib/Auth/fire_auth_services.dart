import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // make signup with email and password function
  signUpWithEmailPassword(
      String email, String password, String name, String phone) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
      } catch (e) {}
    }
  }
}
