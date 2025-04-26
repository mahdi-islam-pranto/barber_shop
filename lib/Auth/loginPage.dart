import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:barber_shop/Auth/signupPage.dart';
import 'package:barber_shop/BarberScreens/barberHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
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
  bool _isLoading = false;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return; // If focus is on text field, dont unfocus
      }
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  // form key
  final _formKey = GlobalKey<FormState>();

  // form values
  String email = '';
  String password = '';

  // controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    emailController.dispose();
    passwordController.dispose();
    textFieldFocusNode.dispose();
    super.dispose();
  }

  // login function
  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    try {
      // Attempt to sign in with email and password
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Check if widget is still mounted
      if (!mounted) return;

      // Clear text fields
      emailController.clear();
      passwordController.clear();

      // Fetch the user's role from Firestore to determine access level
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
            code: 'user-not-found', message: 'User not found after login');
      }

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Check if widget is still mounted
      if (!mounted) return;

      // Get user role, default to customer if not found
      String userRole = 'customer';
      if (userSnapshot.exists && userSnapshot.data() is Map<String, dynamic>) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        if (userData.containsKey('user-type')) {
          userRole = userData['user-type'] as String;
        }
      }

      // Navigate based on user role
      if (!mounted) return;

      if (userRole == 'barber') {
        // Navigate to barber home page and remove all previous routes
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Barberhomepage()),
            (route) => false);
      } else {
        // Navigate to customer home page and remove all previous routes
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false);
      }

      // Show success message
      if (mounted) {
        AnimatedSnackBar.material(
          'Logged In Successfully',
          type: AnimatedSnackBarType.success,
          duration: const Duration(seconds: 3),
          mobileSnackBarPosition: MobileSnackBarPosition.top,
        ).show(context);
      }
    } on FirebaseAuthException catch (e) {
      // Check if widget is still mounted
      if (!mounted) return;

      // Handle specific Firebase Auth errors
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for this email';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong Password';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid Email or Password';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid Email Format';
          break;
        case 'too-many-requests':
          errorMessage =
              'Too many failed login attempts. Please try again later';
          break;
        default:
          errorMessage = 'Login Error: ${e.message ?? e.code}';
      }

      AnimatedSnackBar.material(
        errorMessage,
        type: AnimatedSnackBarType.error,
      ).show(context);

      debugPrint('Login error: ${e.code} - ${e.message}');
    } catch (e) {
      // Check if widget is still mounted
      if (!mounted) return;

      // Handle generic errors
      AnimatedSnackBar.material(
        'An error occurred during login',
        type: AnimatedSnackBarType.error,
      ).show(context);
      debugPrint('Login error: $e');
    } finally {
      // Reset loading state if widget is still mounted
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  final int _currentIndex = 0;

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
                            onPressed: _isLoading
                                ? null // Disable button when loading
                                : () {
                                    // firebase login
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        email = emailController.text.trim();
                                        password =
                                            passwordController.text.trim();
                                      });
                                      login();
                                    }
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
                                        onTap: _isLoading
                                            ? null // Disable when loading
                                            : () {
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
                onChange: (index) => debugPrint('Tab changed to index: $index'),
              ),
            ),
          ],
        ),
      ),
    );
  }

// sign up tab
}
