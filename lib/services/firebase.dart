import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreServices {
  final _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getCollection(
      String collectionName) async {
    return await _firestore.collection(collectionName).get();
  }
}

FirestoreServices firestoreServices = FirestoreServices();
