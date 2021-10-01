import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_tracker/pages/Catergories/breakfast.dart';

class FirestoreServices {
  final _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getCollection(
      String collectionName) async {
    return await _firestore.collection(collectionName).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCollections(
      String collectionName, String docId, String cN2) async {
    print(uid);
    print(cN2);
    return await _firestore
        .collection(collectionName)
        .doc(docId)
        .collection(cN2)
        .get();
  }
}

FirestoreServices firestoreServices = FirestoreServices();
