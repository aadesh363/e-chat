import 'package:cloud_firestore/cloud_firestore.dart';
import 'Fire_base_manager.dart';

class GroupManager {
  static final groupCollection =
  FirebaseFirestore.instance.collection("Users").doc().collection("Groups");

  static Future<String> createGroup({
    required String groupName,
    required List<String> members,
    required List<String> groupPic,
  }) async {
    String groupId = groupCollection.doc().id;

    await groupCollection.doc(groupId).set({
      "groupId": groupId,
      "groupName": groupName,
      "groupPic": groupPic,
      "members": members,
      "adminId": globalDocID,
      "createdAt": FieldValue.serverTimestamp(),
      "lastMessage": "Welcome to our New Group $groupName",
      "pendingCount":1,
    });

    return groupId;
  }

  static Stream<QuerySnapshot> getUserGroups() {
    return groupCollection
        .where("members", arrayContains: globalDocID)
        .snapshots();
  }

  static Future<void> addMember({
    required String groupId,
    required String userId,
  }) async {
    await groupCollection.doc(groupId).update({
      "members": FieldValue.arrayUnion([userId])
    });
  }

  static Future<void> removeMember({
    required String groupId,
    required String userId,
  }) async {
    await groupCollection.doc(groupId).update({
      "members": FieldValue.arrayRemove([userId])
    });
  }

  static Future<void> sendMessage({
    required String groupId,
    required String message,
  }) async {
    final msgRef = groupCollection
        .doc(groupId)
        .collection("messages")
        .doc();

    await msgRef.set({
      "messageId": msgRef.id,
      "senderId": globalDocID,
      "message": message,
      "timeStamp": FieldValue.serverTimestamp(),
    });

    await groupCollection.doc(groupId).update({
      "lastMessage": message,
      "timeStamp": FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> getMessages(String groupId) {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("timeStamp", descending: true)
        .snapshots();
  }

  static Future<void> deleteGroup(String groupId) async {
    await groupCollection.doc(groupId).delete();
  }




}