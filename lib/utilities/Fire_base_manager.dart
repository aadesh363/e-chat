import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_chat/utilities/prefrence_file.dart';
import 'package:flutter/cupertino.dart';
String globalDocID = "";
String globalFDocID = "";


class FireBaseManager {
  static String mobileNumber = "MobileNumber";
  static String participants = "participants";
  static String currentUser = "currentUser";
  static String otherUser = "otherUser";
  static String timeStamp = "timeStamp";
  static String otp = "OTP";
  static String userName = "userName";
  static String userPic = "userPic";
  static String userPin = "userPin";
  static String lastMsg = "lastMsg";
  static String dateTime = "dateTime";
  static String dialCOde = "dialcode";
  static String birthDate = "birthDate";
  static String email= "e-mail";
  static String gender= "gender";
  static String pendingMessageCount = "pendingMessageCount";


  static String docId = "docId";

  static var collection = FirebaseFirestore.instance.collection("Users");

  static void updateData({required Map<String, dynamic> data}) {
    try {
      if (globalDocID == "") return;
      collection.doc(globalDocID).update(data);
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
      globalDocID = uniqueId;



      SharedPref.prefs.setString("globalDocID", uniqueId);


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
    if (globalDocID.isEmpty) {
      throw Exception("Doc ID is empty");
    }
    return collection.doc(globalDocID).get();
  }

  static void deleteUserData() {
    try {
      if (globalDocID == null) return;
      collection.doc(globalDocID).delete();
    } catch (e) {
      print("EXP in delete user data  method $e");
    }
  }

  static void deleteFieldData({required String key}) {
    try {
      if (globalDocID == null) return;
      collection.doc(globalDocID).update({
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
      if(querySnapshot.docs.isNotEmpty) globalDocID = querySnapshot.docs[0][FireBaseManager.docId];
      return querySnapshot.docs.isEmpty;
    }
    catch (e) {
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
    required String dialCode,
  }) async {
    String searchText = "$dialCode ${controller.text.trim()}";

    QuerySnapshot userNumber = await collection
        .orderBy(FireBaseManager.mobileNumber)
        .startAt([searchText])
        .endAt([searchText + "\uf8ff"])
        .get();
print(searchText);
    return userNumber.docs;
  }


  static Future<List<QueryDocumentSnapshot<Object?>>> searchUserByName({
    required TextEditingController controller,

  }) async {
    String searchText = "${controller.text.trim()}";

    QuerySnapshot userNumber = await collection
        .orderBy(FireBaseManager.userName)
        .startAt([searchText])
        .endAt([searchText + "\uf8ff"])
        .get();
    print(searchText);
    return userNumber.docs;
  }




}