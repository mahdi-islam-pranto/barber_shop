import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // add user details data function
  Future<void> addUserDetails(
      Map<String, dynamic> userDetailsMap, String id) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userDetailsMap);
  }
}
