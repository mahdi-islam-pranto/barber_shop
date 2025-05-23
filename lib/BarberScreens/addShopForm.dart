import 'dart:developer';
import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:barber_shop/BarberScreens/barberHomePage.dart';
import 'package:barber_shop/resources/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/customProgressIndecator.dart';

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

  String address = '';

  // make controllers
  TextEditingController nameController = TextEditingController();

  TextEditingController addressController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  bool _isLoading = false;

  List<File> selectedImages = []; // List of selected image
  final picker = ImagePicker(); // Instance of Image picker

  // supabase storage instance
  final supabase = Supabase.instance.client;

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, // To set quality of images
        maxHeight: 1000, // To set maxheight of images that you want in your app
        maxWidth: 1000); // To set maxheight of images that you want in your app
    List<XFile> xfilePick = pickedFile;

    // if atleast 1 images is selected it will add
    // all images in selectedImages
    // variable so that we can easily show them in UI
    if (xfilePick.isNotEmpty) {
      for (var i = 0; i < xfilePick.length; i++) {
        selectedImages.add(File(xfilePick[i].path));
      }
      setState(
        () {
          print("all images $selectedImages");
        },
      );
    } else {
      // If no image is selected it will show a
      // snackbar saying nothing is selected
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Nothing is selected')));
    }
  }

  // get uid of current user from firebase

  String? userUid = FirebaseAuth.instance.currentUser?.uid;

  // list to store all uploaded images urls
  List<String> uploadedImages = [];

  // function to upload image to supabase storage
  Future<List<String>> uploadImages() async {
    List<String> uploadedImageUrls = [];
    try {
      for (var i = 0; i < selectedImages.length; i++) {
        // Create path: barberShopImages/userId/shopName/filename
        String imagePath =
            'barberShopImages/$userUid/$name/${selectedImages[i].path.split('/').last}';

        // Upload image to the shopimages bucket
        await supabase.storage.from('shopimages').upload(
              imagePath,
              selectedImages[i],
            );

        // Get public URL from the shopimages bucket
        String imageUrl =
            await supabase.storage.from('shopimages').getPublicUrl(imagePath);

        uploadedImageUrls.add(imageUrl);
      }
      return uploadedImageUrls;
    } catch (e) {
      log('Failed to upload images: $e');
      throw Exception('Failed to upload images: $e');
    }
  }

// addShop function to handle the shop creation process
  Future<void> addShop() async {
    // Check if any image is selected
    if (selectedImages.isEmpty) {
      AnimatedSnackBar.material(
        'Please select at least one image for your shop',
        type: AnimatedSnackBarType.error,
        duration: const Duration(seconds: 3),
        mobileSnackBarPosition: MobileSnackBarPosition.top,
      ).show(context);
      return;
    }

    // Validate form

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // if form is valid then set all values in variables

    setState(() {
      name = nameController.text;
      email = emailController.text;
      phone = phoneController.text;
      address = addressController.text;
    });

    // Show loading dialog
    CustomProgress customProgress = CustomProgress(context);
    customProgress.showDialog(
        "Creating shop...", SimpleFontelicoProgressDialogType.spinner);

    try {
      // Upload images first to supa base storage and get their URLs
      final imageUrls = await uploadImages();

      // Add shop data to Firestore database - UPDATED STRUCTURE
      await FirebaseFirestore.instance.collection('barberShops').add({
        'name': name,
        'phone': phone,
        'email': email,
        'address': address,
        'images': imageUrls,
        'ownerUid': userUid,
        'createdAt': FieldValue.serverTimestamp(),
        'rating': "4.8",
      });

      // Clear all fields
      nameController.clear();
      phoneController.clear();
      emailController.clear();
      addressController.clear();
      setState(() {
        selectedImages.clear();
      });

      // Hide loading dialog
      customProgress.hideDialog();

      // Navigate to home page
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const Barberhomepage()));

      // Show success message
      AnimatedSnackBar.material(
        'Shop added successfully',
        type: AnimatedSnackBarType.success,
        duration: const Duration(seconds: 3),
        mobileSnackBarPosition: MobileSnackBarPosition.top,
      ).show(context);
    } catch (e) {
      // Hide loading dialog
      customProgress.hideDialog();

      log('Failed to add shop: $e');
      // Show error message
      AnimatedSnackBar.material(
        'Error creating shop: ${e.toString()}',
        type: AnimatedSnackBarType.error,
        duration: const Duration(seconds: 3),
        mobileSnackBarPosition: MobileSnackBarPosition.top,
      ).show(context);
    }
  }

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

                        SizedBox(
                          height: MediaQuery.of(context).size.height / 15,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(boxColor),
                              alignment: Alignment.centerLeft,
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                            ),
                            // TO change button color
                            child: Text(
                                "Select Shop Images (First image will be shop's front image)*",
                                style: TextStyle(
                                    color: textColor.withOpacity(0.5))),
                            onPressed: () {
                              getImages();
                            },
                          ),
                        ),

                        // show selected images

                        selectedImages.isNotEmpty
                            ? Container(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: selectedImages.length,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.file(
                                      selectedImages[index],
                                      height: 100,
                                    ),
                                  ),
                                ),
                              )
                            : const Text('No image selected'),

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
                                  // if all fields are valid
                                  //  save all data in firestore
                                  addShop();
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
