import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:barber_shop/resources/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'loginPage.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

String email = '';
TextEditingController emailController = TextEditingController();

resetPassword() async {
  try {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) {
      print('Password reset link sent to $email');
    });

    // show success message
    AnimatedSnackBar.material(
      'Password reset link sent to $email',
      type: AnimatedSnackBarType.success,
    );
  } on FirebaseAuthException catch (e) {
    AnimatedSnackBar.material(
      'Error: $e',
      type: AnimatedSnackBarType.error,
    );
  }
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Recover Password',
              style: TextStyle(fontSize: 20),
            ),
            // email or phone number field
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: TextFormField(
                  controller: emailController,
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email or Phone number is required.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    fillColor: boxColor,
                    contentPadding: const EdgeInsets.all(20),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: textColor, width: 2.0),
                    ),
                    prefixIcon: Icon(Icons.person, color: textColor),
                    hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                    hintText: " Email Address",
                    labelStyle: TextStyle(color: textColor),
                  )),
            ),

            // submit button
            GestureDetector(
              onTap: () {
                setState(() {
                  email = emailController.text;
                });
                print("hello");
                resetPassword();

                // navigate to login page
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: backGroundColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // back to login button
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: Text(
                  "< Back to Login",
                  style: TextStyle(
                    color: buttonColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
