import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:barber_shop/Auth/signupPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import '../components/customProgressIndecator.dart';
import '../resources/colors.dart';
import '../screens/homepage.dart';
import 'fire_auth_services.dart';
import 'forgot_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final textFieldFocusNode = FocusNode();
  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  // form key
  final _formKey = GlobalKey<FormState>();

  // form values

  String email = '';
  String password = '';

  // make controllers

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // login function
  login() async {
    if (_formKey.currentState!.validate()) {
      // show loading
      CustomProgress customProgress = CustomProgress(context);
      customProgress.showDialog(
          "Please wait", SimpleFontelicoProgressDialogType.spinner);
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        // hide loading
        customProgress.hideDialog();

        // Navigate to home page
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const HomePage();
        }));
        // show snackbar

        AnimatedSnackBar.material(
          'Logged In Successfully',
          type: AnimatedSnackBarType.success,
          duration: const Duration(seconds: 3),
          mobileSnackBarPosition: MobileSnackBarPosition.top,
        ).show(context);
      } on FirebaseAuthException catch (e) {
        customProgress.hideDialog();
        // if cant find user
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No user found for this email.")),
          );
        } else if (e.code == 'wrong-password') {
          print('###### Wrong Password');
          AnimatedSnackBar.material(
            'Wrong Password',
            type: AnimatedSnackBarType.error,
          ).show(context);
        } else if (e.code == 'invalid-credential') {
          print('###### Invalid Email');
          AnimatedSnackBar.material(
            'Invalid Email or Password',
            type: AnimatedSnackBarType.error,
          ).show(context);
        } else {
          AnimatedSnackBar.material(
            '${e.code}',
            type: AnimatedSnackBarType.error,
          ).show(context);
        }
      }
    }
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // barber image
            Container(
              padding: const EdgeInsets.only(top: 40),
              child: Image.asset(
                "assets/images/login_image.png",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
              ),
            ),
            // login and Sign up field

            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: ContainedTabBarView(
                initialIndex: _currentIndex,
                tabBarProperties: TabBarProperties(
                    width: 200,
                    indicatorColor: textColor,
                    background: Container(
                      decoration: BoxDecoration(
                        color: boxColor,
                        border: Border.all(color: textColor),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                    )),
                tabs: [
                  Text(
                    'Login',
                    style: TextStyle(color: textColor, fontSize: 20),
                  ),
                  Text(
                    'Sign up',
                    style: TextStyle(color: textColor, fontSize: 20),
                  ),
                ],
                views: [
                  // login form
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // email or phone number field
                          TextFormField(
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
                                  borderSide:
                                      BorderSide(color: textColor, width: 2.0),
                                ),
                                prefixIcon:
                                    Icon(Icons.person, color: textColor),
                                hintStyle: TextStyle(
                                    color: textColor.withOpacity(0.5)),
                                hintText: "Email or Phone number",
                                labelStyle: TextStyle(color: textColor),
                              )),
                          const SizedBox(
                            height: 20,
                          ),

                          // password field
                          TextFormField(
                            controller: passwordController,
                            obscureText: _obscured,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter a password';
                              }
                              return null;
                            },
                            style: TextStyle(color: textColor),
                            keyboardType: TextInputType.visiblePassword,
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
                                borderSide:
                                    BorderSide(color: textColor, width: 2.0),
                              ),
                              prefixIcon: Icon(Icons.lock, color: textColor),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                child: GestureDetector(
                                  onTap: _toggleObscured,
                                  child: Icon(
                                    _obscured
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                    size: 24,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              hintStyle:
                                  TextStyle(color: textColor.withOpacity(0.5)),
                              hintText: "Password",
                              labelStyle: TextStyle(color: textColor),
                            ),
                          ),

                          // forget passworrd
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPassword()),
                                  );
                                },
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // dont have an account
                          const Text(
                            "Don't have an account? Go to Sign up",
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          // login button

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              minimumSize: const Size(200, 50),
                              maximumSize: const Size(200, 50),
                            ),
                            onPressed: () {
                              // firebase login
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  email = emailController.text.trim();
                                  password = passwordController.text.trim();
                                });
                                login();
                              }
                            },
                            child: Text(
                              "Login".toUpperCase(),
                              style: TextStyle(
                                  color: backGroundColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),

                          // google sign in buttons
                          Container(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  Text("Or Sign in with",
                                      style: TextStyle(
                                          color: textColor, fontSize: 16)),
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  // google sign / email in button
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // login with google
                                          FireAuthServices()
                                              .signupWithGoogle(context);
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: Image.asset(
                                                  'assets/images/google.png')
                                              .image,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: Image.asset(
                                                'assets/images/apple.png')
                                            .image,
                                      ),
                                      const SizedBox(width: 20),
                                      CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: Icon(
                                          Icons.facebook,
                                          color: textColor,
                                          size: 42,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),

                  // Sign up form
                  const SignupPage(),
                ],
                onChange: (index) => print(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

// sign up tab
}
