import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_chat/utilities/pref_keys.dart';
import 'package:e_chat/utilities/prefrence_file.dart';
import 'package:flutter/cupertino.dart';

class FireBaseManager {
  static String mobileNumber = "MobileNumber";
  static String otp = "OTP";
  static String userName = "userName";
  static String userPic = "userPic";
  static String userPin = "userPin";

  static var collection = FirebaseFirestore.instance.collection("Users");

  static void addCollection({required Map<String, dynamic> data}) {
    try {
      collection.add(data).then((value) {
        SharedPref.setString(key: PrefKeys.docID, value: value.id);
        print(value.id);
      });
    } catch (e) {
      print("EXP in addCollection method :: $e");
    }
  }

  static void updateData({required Map<String, dynamic> data}) {
    try {
      collection.doc(SharedPref.getString(action: PrefKeys.docID)).update(data);
    } catch (e) {
      print("EXP in Update data method :::: $e ");
    }
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getData() {
    try {
      return collection.doc(SharedPref.getString(action: PrefKeys.docID)).get();
    } catch (e) {
      print("EXP in get data method $e");
      return collection.doc(SharedPref.getString(action: PrefKeys.docID)).get();
    }
  }

  static void deleteUserData() {
    try{
      collection.doc(SharedPref.getString(action: PrefKeys.docID)).delete();

    }
    catch(e){
      print("EXP in delete user data  method $e");

    }
  }

  static void deleteFieldData({required String key}) {
    try{
      collection.doc(SharedPref.getString(action: PrefKeys.docID)).update({
        key: FieldValue.delete(),
      });
    }
    catch(e){
      print("EXP in delete field data  method $e");
    }
  }

  static Future<bool> searchData({
    required String target,
    required String key,
  }) async {
   try{
     final querySnapshot = await collection
         .where(key, isEqualTo: target)
         .limit(1)
         .get();
     return querySnapshot.docs.isEmpty;
   }
   catch(e){
     print("EXP in search data method :: $e");
     final querySnapshot = await collection
         .where(key, isEqualTo: target)
         .limit(1)
         .get();
     return querySnapshot.docs.isEmpty;
   }
  }
  static Future<List<QueryDocumentSnapshot<Object?>>> searchUsersByNumber({required TextEditingController controller})async
  {
    QuerySnapshot userNumber = await collection.
    orderBy(FireBaseManager.mobileNumber).startAt([controller.text]).endAt([controller.text + "\uf8ff"]).get();
    return userNumber.docs;
  }
}
