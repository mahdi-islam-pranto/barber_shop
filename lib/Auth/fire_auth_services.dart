import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:barber_shop/components/customProgressIndecator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import '../screens/homepage.dart';

class FireAuthServices {
// creating firebase instance
  final FirebaseAuth auth = FirebaseAuth.instance;

  // make signup with email and password function
  // implemented in login page

  // login with google function
  getCurrentUser() async {
    return await auth.currentUser;
  }

  // function to implement the google signin

  Future<void> signupWithGoogle(BuildContext context) async {
    try {
      // add loader
      // show loading
      CustomProgress customProgress = CustomProgress(context);
      customProgress.showDialog(
          "Please wait", SimpleFontelicoProgressDialogType.spinner);

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        // Getting users credential
        UserCredential result = await auth.signInWithCredential(authCredential);
        User? user = result.user;
        print(user?.displayName.toString());

        print(user?..uid.toString());

        // if user is not exists in firestore, add user
        if (user != null) {
          final userDocs = await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get();
          if (!userDocs.exists) {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .set({
              "id": user.uid,
              "name": user.displayName,
              "phone": user.phoneNumber,
              "email": user.email,
            });
          }
        }

        // put this user data to firestore
        // await FirebaseFirestore.instance.collection("users").doc(user?.uid).set({
        //   "id": user?.uid.toString(),
        //   "name": user?.displayName.toString(),
        //   "phone": user?.phoneNumber.toString(),
        //   "email": user?.email.toString(),
        // });

        // save the user data to shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("id", user!.uid.toString());
        prefs.setString("name", user.displayName.toString());
        prefs.setString("email", user.email.toString());

        // if user is not null we simply call the MaterialpageRoute,

        if (result != null) {
          customProgress.hideDialog();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } // if result not null we simply call the MaterialpageRoute,
        AnimatedSnackBar.material(
          'Logged In Successfully',
          type: AnimatedSnackBarType.success,
          duration: const Duration(seconds: 3),
          mobileSnackBarPosition: MobileSnackBarPosition.top,
        ).show(context);
        // for go to the HomePage screen
      }
    } catch (e) {
      // show the error in the snackbar
      AnimatedSnackBar.material(
          "User Not Found. Try to login with email and password",
          type: AnimatedSnackBarType.error);
    }
  }
}
