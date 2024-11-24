import 'package:flutter/material.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';

import '../resources/colors.dart';

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
              height: MediaQuery.of(context).size.height / 2.5,
              child: ContainedTabBarView(
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
                    child: Column(
                      children: [
                        // email or phone number field
                        TextFormField(
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
                              prefixIcon: Icon(Icons.person, color: textColor),
                              hintStyle:
                                  TextStyle(color: textColor.withOpacity(0.5)),
                              hintText: "Email or Phone number",
                              labelStyle: TextStyle(color: textColor),
                            )),
                        const SizedBox(
                          height: 20,
                        ),

                        // password field
                        TextFormField(
                          obscureText: _obscured,
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
                              onPressed: () {},
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // login button

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            minimumSize: const Size(200, 50),
                            maximumSize: const Size(200, 50),
                          ),
                          onPressed: () {},
                          child: Text(
                            "Login".toUpperCase(),
                            style: TextStyle(
                                color: backGroundColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(color: boxColor)
                ],
                onChange: (index) => print(index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
