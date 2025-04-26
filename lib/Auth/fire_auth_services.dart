import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:barber_shop/components/customProgressIndecator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import '../BarberScreens/barberHomePage.dart';
import '../screens/homepage.dart';

class FireAuthServices {
  // creating firebase instance
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // make signup with email and password function
  // implemented in login page

  // Get current user function
  User? getCurrentUser() {
    return auth.currentUser;
  }

  // function to implement the google signin
  Future<void> signupWithGoogle(BuildContext context) async {
    // Store context reference to check if widget is mounted later
    final scaffoldContext = context;

    try {
      // Show loading dialog
      CustomProgress customProgress = CustomProgress(scaffoldContext);
      customProgress.showDialog(
          "Please wait", SimpleFontelicoProgressDialogType.spinner);

      try {
        // Begin interactive sign in process
        final GoogleSignInAccount? googleSignInAccount =
            await googleSignIn.signIn();

        if (googleSignInAccount == null) {
          // User canceled the sign-in flow
          customProgress.hideDialog();
          return;
        }

        // Obtain auth details from request
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        // Create new credential for Firebase
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        // Sign in to Firebase with the Google credential
        UserCredential result = await auth.signInWithCredential(authCredential);
        User? user = result.user;

        if (user == null) {
          customProgress.hideDialog();
          if (!_isContextValid(scaffoldContext)) return;

          AnimatedSnackBar.material(
            'Failed to sign in with Google',
            type: AnimatedSnackBarType.error,
          ).show(scaffoldContext);
          return;
        }

        // Check if user exists in Firestore
        final userDocs = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        // If user doesn't exist, add to Firestore
        if (!userDocs.exists) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .set({
            "id": user.uid,
            "name": user.displayName ?? "User",
            "phone": user.phoneNumber ?? "",
            "email": user.email ?? "",
            "user-type": "customer",
            "created_at": FieldValue.serverTimestamp(),
          });
        }

        // Save user data to shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("id", user.uid);
        prefs.setString("name", user.displayName ?? "User");
        prefs.setString("email", user.email ?? "");
        prefs.setString("user-type",
            userDocs.exists ? userDocs.get("user-type") : "customer");

        // Hide loading dialog
        customProgress.hideDialog();

        // Check if context is still valid before navigating
        if (!_isContextValid(scaffoldContext)) return;

        // Navigate based on user type
        String userType =
            userDocs.exists ? userDocs.get("user-type") : "customer";

        if (userType == "barber") {
          Navigator.pushAndRemoveUntil(
              scaffoldContext,
              MaterialPageRoute(builder: (context) => const Barberhomepage()),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              scaffoldContext,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false);
        }

        // Show success message
        AnimatedSnackBar.material(
          'Logged In Successfully',
          type: AnimatedSnackBarType.success,
          duration: const Duration(seconds: 3),
          mobileSnackBarPosition: MobileSnackBarPosition.top,
        ).show(scaffoldContext);
      } catch (e) {
        // Hide loading dialog on error
        customProgress.hideDialog();
        rethrow;
      }
    } catch (e) {
      // For debugging only
      debugPrint('Google sign in error: $e');

      // Check if context is still valid before showing error
      if (!_isContextValid(scaffoldContext)) return;

      // Show error message
      AnimatedSnackBar.material(
        "Failed to sign in with Google. Please try again or use email login.",
        type: AnimatedSnackBarType.error,
        duration: const Duration(seconds: 3),
      ).show(scaffoldContext);
    }
  }

  // Helper method to check if context is still valid
  bool _isContextValid(BuildContext context) {
    return context.mounted;
  }

  // Sign out method
  Future<void> signOut(BuildContext context) async {
    // Store context reference to check if widget is mounted later
    final scaffoldContext = context;

    try {
      // Sign out from Firebase
      await auth.signOut();

      // Sign out from Google if signed in with Google
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      // Clear shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Check if context is still valid before showing message
      if (!_isContextValid(scaffoldContext)) return;

      // Show success message
      AnimatedSnackBar.material(
        'Signed out successfully',
        type: AnimatedSnackBarType.success,
      ).show(scaffoldContext);
    } catch (e) {
      debugPrint('Sign out error: $e');

      // Check if context is still valid before showing error
      if (!_isContextValid(scaffoldContext)) return;

      AnimatedSnackBar.material(
        'Error signing out',
        type: AnimatedSnackBarType.error,
      ).show(scaffoldContext);
    }
  }
}
