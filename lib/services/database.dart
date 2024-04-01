import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseService {
  late final String uid;

  DatabaseService({required this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name) async {
    return await userCollection.doc(uid).set({
      'name': name,
    });
  }

  Future updateUserAgeData(int age) async {
    return await userCollection.doc(uid).update({
      'age': age,
    });
  }


  Future<int?> getUserAge() async {
    try {
      DocumentSnapshot userSnapshot = await userCollection.doc(uid).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        return userData['age'];
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user age: $e');
      return null;
    }
  }

  // Future<int?> getUserData() async {
  //   final DocumentSnapshot snap = await userCollection.doc(uid).get();
  //   if (snap.exists) {
  //     final data = snap.data() as Map<String, dynamic>;
  //     return data['age'];
  //   } else {
  //     return null; // Handle case where document doesn't exist
  //   }
  // }
}