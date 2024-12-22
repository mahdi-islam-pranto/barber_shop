import 'package:barber_shop/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddShopForm extends StatefulWidget {
  const AddShopForm({super.key});

  @override
  State<AddShopForm> createState() => _AddShopFormState();
}

class _AddShopFormState extends State<AddShopForm> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // form values
  String name = '';

  String phone = '';

  String email = '';

  String password = '';

  // make controllers
  TextEditingController nameController = TextEditingController();

  TextEditingController addressController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  // image picker
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: textColor, //change your color here
          ),
          centerTitle: true,
          elevation: 2,
          backgroundColor: boxColor,
          title: Text('CREATE NEW SHOP', style: TextStyle(color: textColor)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // barber image
              Container(
                padding: const EdgeInsets.only(top: 40),
                child: Image.asset(
                  "assets/images/shop.png",
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 7,
                ),
              ),
              // form
              Center(
                child: Container(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // shop Name form
                        TextFormField(
                            controller: nameController,
                            style: TextStyle(color: textColor),
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ' Shop name is required.';
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
                              hintText: "Enter shop name",
                              labelStyle: TextStyle(color: textColor),
                            )),

                        const SizedBox(
                          height: 12,
                        ),

                        // address form

                        TextFormField(
                            controller: addressController,
                            style: TextStyle(color: textColor),
                            keyboardType: TextInputType.streetAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ' Shop address is required.';
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
                              hintText: "Enter shop address",
                              labelStyle: TextStyle(color: textColor),
                            )),

                        const SizedBox(
                          height: 12,
                        ),

                        // shop phone number form
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
                                borderSide:
                                    BorderSide(color: textColor, width: 2.0),
                              ),
                              prefixIcon: Icon(Icons.phone, color: textColor),
                              hintStyle:
                                  TextStyle(color: textColor.withOpacity(0.5)),
                              hintText: "Shop contact number",
                              labelStyle: TextStyle(color: textColor),
                            )),

                        const SizedBox(
                          height: 12,
                        ),
                        // shop email form
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
                                borderSide:
                                    BorderSide(color: textColor, width: 2.0),
                              ),
                              prefixIcon: Icon(Icons.person, color: textColor),
                              hintStyle:
                                  TextStyle(color: textColor.withOpacity(0.5)),
                              hintText: "Shop email address",
                              labelStyle: TextStyle(color: textColor),
                            )),
                        const SizedBox(
                          height: 12,
                        ),

                        // add shop front image

                        Container(),

                        const SizedBox(
                          height: 12,
                        ),

                        // add multiple images

                        const SizedBox(
                          height: 20,
                        ),

                        // login button
                        _isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                color: buttonColor,
                              ))
                            : ElevatedButton(
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
                                  }
                                },
                                child: _isLoading
                                    ? CircularProgressIndicator(
                                        color: backGroundColor,
                                        strokeWidth: 3,
                                      )
                                    : Text(
                                        "Create shop".toUpperCase(),
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
                ),
              ),
            ],
          ),
        ));
  }
}
