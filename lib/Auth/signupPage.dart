import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../resources/colors.dart';
import '../screens/homepage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final textFieldFocusNode = FocusNode();
  bool obscured = true;

  void toggleObscured() {
    setState(() {
      obscured = !obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  // form key
  final _formKey = GlobalKey<FormState>();

  // form values
  String name = '';
  String phone = '';
  String email = '';
  String password = '';

  // make controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // signup function with firebase
  void signup() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        print("User Signed Up:  + ${userCredential.user!.uid}");
        print("Email:  + ${userCredential.user!.email}");

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registered Successfully")));

        // navigate to Home page
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const HomePage();
        }));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Password is too weak"),
              backgroundColor: Colors.redAccent,
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Email is already in use"),
              backgroundColor: Colors.redAccent,
            ),
          );
        } else if (e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Email is invalid"),
              backgroundColor: Colors.redAccent,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please try again with valid information"),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Name form
            TextFormField(
                controller: nameController,
                style: TextStyle(color: textColor),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required.';
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
                  hintText: "Full name",
                  labelStyle: TextStyle(color: textColor),
                )),

            const SizedBox(
              height: 12,
            ),

            // phone number form
            TextFormField(
                controller: phoneController,
                style: TextStyle(color: textColor),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required.';
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
                  prefixIcon: Icon(Icons.phone, color: textColor),
                  hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                  hintText: "Phone number",
                  labelStyle: TextStyle(color: textColor),
                )),

            const SizedBox(
              height: 12,
            ),
            // email form
            TextFormField(
                controller: emailController,
                style: TextStyle(color: textColor),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email address is required.';
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
                  hintText: "Email address",
                  labelStyle: TextStyle(color: textColor),
                )),
            const SizedBox(
              height: 12,
            ),

            // password field
            TextFormField(
              controller: passwordController,
              obscureText: obscured,
              style: TextStyle(color: textColor),
              keyboardType: TextInputType.visiblePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'give a password';
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
                prefixIcon: Icon(Icons.lock, color: textColor),
                suffixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                  child: GestureDetector(
                    onTap: toggleObscured,
                    child: Icon(
                      obscured
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      size: 24,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                hintText: "Password",
                labelStyle: TextStyle(color: textColor),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // login button

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                minimumSize: const Size(200, 50),
                maximumSize: const Size(200, 50),
              ),
              onPressed: () {
                // add loading
                // const CircularProgressIndicator(
                //   color: Colors.amber,
                // );
                // add validation
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    name = nameController.text;
                    email = emailController.text;
                    phone = phoneController.text;
                    password = passwordController.text;
                  });
                  // sign up user with email and password
                  signup();
                }
              },
              child: Text(
                "Register".toUpperCase(),
                style: TextStyle(
                    color: backGroundColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
