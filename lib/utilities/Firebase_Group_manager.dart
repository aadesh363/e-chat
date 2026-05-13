import 'package:cloud_firestore/cloud_firestore.dart';
import 'Fire_base_manager.dart';

class GroupManager {

  static CollectionReference<Map<String, dynamic>>
  groupCollection(String userId) {

    return FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .collection("Groups");
  }

  static Future<String> createGroup({
    required String userId,
    required String groupName,
    required List<String> members,
    required List<String> groupPic,
    required String gID,
  }) async {

    //String groupId = groupCollection(userId).doc().id;
    if (!members.contains(globalDocID)) {
      members.add(globalDocID);
    }


    await groupCollection(userId).doc(gID).set({

      "groupId": gID,
      "groupName": groupName,
      "groupPic": groupPic,
      "members": members,
      "adminId": globalDocID,
      "createdAt": FieldValue.serverTimestamp(),
      "lastMessage": "Welcome to our New Group $groupName",
      "pendingCount": 1,

    });
   FirebaseFirestore.instance.collection("Users").doc(userId).update({
     "groupID":FieldValue.arrayUnion([gID])
   });



    return gID;
  }

  static Stream<QuerySnapshot> getUserGroups(
      String userId,
      ) {

    return groupCollection(userId)
        .where("members", arrayContains: userId)
        .snapshots();
  }

  static Future<void> addMember({
    required String ownerId,
    required String groupId,
    required String userId,
  }) async {

    await groupCollection(ownerId)
        .doc(groupId)
        .update({

      "members": FieldValue.arrayUnion([userId])

    });
  }

  static Future<void> removeMember({
    required String ownerId,
    required String groupId,
    required String userId,
  }) async {

    await groupCollection(ownerId)
        .doc(groupId)
        .update({

      "members": FieldValue.arrayRemove([userId])

    });
  }

  static Future<void> sendMessage({
    required String ownerId,
    required String groupId,
    required String message,
  }) async {

    final msgRef = groupCollection(ownerId)
        .doc(groupId)
        .collection("messages")
        .doc();

    await msgRef.set({

      "messageId": msgRef.id,
      "senderId": globalDocID,
      "message": message,
      "timeStamp": FieldValue.serverTimestamp(),

    });

    await groupCollection(ownerId)
        .doc(groupId)
        .update({

      "lastMessage": message,
      "timeStamp": FieldValue.serverTimestamp(),

    });
  }

  static Stream<QuerySnapshot> getMessages({
    required String ownerId,
    required String groupId,
  }) {

    return groupCollection(ownerId)
        .doc(groupId)
        .collection("messages")
        .orderBy("timeStamp", descending: true)
        .snapshots();
  }

  static Future<void> deleteGroup({
    required String ownerId,
    required String groupId,
  }) async {

    await groupCollection(ownerId)
        .doc(groupId)
        .delete();
  }
}