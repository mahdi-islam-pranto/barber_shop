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

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = '';
  TextEditingController emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    if (email.isEmpty) {
      AnimatedSnackBar.material(
        'Please enter your email address',
        type: AnimatedSnackBarType.error,
      ).show(context);
      return;
    }

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Check if widget is still mounted
      if (!mounted) return;

      // Show success message
      AnimatedSnackBar.material(
        'Password reset link sent to $email',
        type: AnimatedSnackBarType.success,
      ).show(context);

      // Clear email field
      emailController.clear();

      // Navigate back after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } on FirebaseAuthException catch (e) {
      // Check if widget is still mounted
      if (!mounted) return;

      String errorMessage;

      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Invalid email format';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        default:
          errorMessage = 'Error: ${e.message ?? e.code}';
      }

      AnimatedSnackBar.material(
        errorMessage,
        type: AnimatedSnackBarType.error,
      ).show(context);

      debugPrint('Password reset error: ${e.code} - ${e.message}');
    } catch (e) {
      // Check if widget is still mounted
      if (!mounted) return;

      AnimatedSnackBar.material(
        'An error occurred. Please try again later.',
        type: AnimatedSnackBarType.error,
      ).show(context);

      debugPrint('Password reset error: $e');
    } finally {
      // Reset loading state if widget is still mounted
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

// Moved to above
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _isLoading
                  ? null // Disable button when loading
                  : () {
                      setState(() {
                        email = emailController.text.trim();
                      });
                      resetPassword();
                    },
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: backGroundColor,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      "Submit",
                      style: TextStyle(
                        color: backGroundColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
