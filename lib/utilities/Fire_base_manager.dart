import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FireBaseManager {
  static String mobileNumber = "MobileNumber";
  static String otp = "OTP";
  static String userName = "userName";
  static String userPic = "userPic";
  static String userPin = "userPin";

  static String docId = "docId";
  static String? currentDocId;

  static var collection = FirebaseFirestore.instance.collection("Users");

  static void updateData({required Map<String, dynamic> data}) {
    try {
      if (currentDocId == null) return;
      collection.doc(currentDocId).update(data);
    } catch (e) {
      print("EXP in Update data method :::: $e ");
    }
  }

  static void addCollection({
    required Map<String, dynamic> data,
    String? collectionName,
  }) {
    try {
      var collectionRef = collectionName != null
          ? FirebaseFirestore.instance.collection(collectionName)
          : collection;

      String uniqueId = collectionRef.doc().id;

      currentDocId = uniqueId;

      collectionRef.doc(uniqueId).set({
        ...data,
        docId: uniqueId,
      });

      print(uniqueId);
    } catch (e) {
      print("EXP in addCollection method :: $e");
    }
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getData() {
    if (currentDocId == null) {
      throw Exception("docId is null");
    }
    return collection.doc(currentDocId).get();
  }

  static void deleteUserData() {
    try {
      if (currentDocId == null) return;
      collection.doc(currentDocId).delete();
    } catch (e) {
      print("EXP in delete user data  method $e");
    }
  }

  static void deleteFieldData({required String key}) {
    try {
      if (currentDocId == null) return;
      collection.doc(currentDocId).update({
        key: FieldValue.delete(),
      });
    } catch (e) {
      print("EXP in delete field data  method $e");
    }
  }

  static Future<bool> searchData({
    required String target,
    required String key,
  }) async {
    try {
      final querySnapshot = await collection
          .where(key, isEqualTo: target)
          .limit(1)
          .get();
      return querySnapshot.docs.isEmpty;
    } catch (e) {
      print("EXP in search data method :: $e");
      final querySnapshot = await collection
          .where(key, isEqualTo: target)
          .limit(1)
          .get();
      return querySnapshot.docs.isEmpty;
    }
  }

  static Future<List<QueryDocumentSnapshot<Object?>>> searchUsersByNumber({
    required TextEditingController controller,
  }) async {
    QuerySnapshot userNumber = await collection
        .orderBy(FireBaseManager.mobileNumber)
        .startAt([controller.text])
        .endAt([controller.text + "\uf8ff"])
        .get();
    return userNumber.docs;
  }
}