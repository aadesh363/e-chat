import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_chat/utilities/commonColors.dart';
import 'package:e_chat/utilities/commonWidget.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../utilities/Fire_base_manager.dart';

int pendingCount = 0;

class ChatScreen extends StatefulWidget {
  final String otherUserId;
  final String otherUserName;

  const ChatScreen({
    super.key,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msgController = TextEditingController();

  late String otherUserId;
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    otherUserId = widget.otherUserId;

    currentUserId = globalDocID;
    getdata();
    // resetUnread();
  }

  var a;

  Future<void> getdata() async {
    final currentSnap = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUserId)
        .collection("Friends")
        .where("friendUserId", isEqualTo: otherUserId)
        .limit(1)
        .get();
    setState(() {
      a = currentSnap;
    });
  }

  String compareId(String id1, String id2) {
    return id1.compareTo(id2) < 0 ? "${id1}_$id2" : "${id2}_$id1";
  }

  // Future<void> resetUnread() async {
  //   await FirebaseFirestore.instance
  //       .collection("Users")
  //       .doc(currentUserId)
  //       .collection("Friends")
  //       .doc(otherUserId)
  //       .set({
  //     "pendingMessageCount": 0,
  //   }, SetOptions(merge: true));
  // }

  // Future<void> sendMessage() async {
  //   setState(() {
  //     pendingCount += 1;
  //   });
  //   final text = msgController.text.trim();
  //   if (text.isEmpty)
  //
  //   return;
  //
  //   final chatId = compareId(currentUserId, otherUserId);
  //
  //   final friendDocId = await getFriendDocId();
  //
  //   if (friendDocId == null) {
  //     print("Friend doc not found ❌");
  //     return;
  //   }
  //   await FirebaseFirestore.instance
  //       .collection("chats")
  //       .doc(chatId)
  //       .collection("messages")
  //       .add({
  //         "senderId": currentUserId,
  //         "message": text,
  //         "timeStamp": FieldValue.serverTimestamp(),
  //       });
  //
  //   FirebaseFirestore.instance
  //       .collection("Users")
  //       .doc(globalDocID)
  //       .collection("Friends")
  //       .doc(friendDocId)
  //       .update({
  //
  //
  //     "lastMessage": msgController.text.trim(),
  //     "otherUser.pendingCount": pendingCount,
  //
  //
  //   });
  //
  //   msgController.clear();
  // }

  Future<void> sendMessage() async {
    final text = msgController.text.trim();
    if (text.isEmpty) return;

    msgController.clear();

    final chatId = compareId(currentUserId, otherUserId);

    await FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .add({
          "senderId": currentUserId,
          "message": text,
          "timeStamp": FieldValue.serverTimestamp(),
        });

    final currentSnap = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUserId)
        .collection("Friends")
        .where("friendUserId", isEqualTo: otherUserId)
        .limit(1)
        .get();

    final otherSnap = await FirebaseFirestore.instance
        .collection("Users")
        .doc(otherUserId)
        .collection("Friends")
        .where("friendUserId", isEqualTo: currentUserId)
        .limit(1)
        .get();

    if (currentSnap.docs.isEmpty || otherSnap.docs.isEmpty) return;

    final currentDocId = currentSnap.docs.first.id;
    final otherDocId = otherSnap.docs.first.id;
    var times = FieldValue.serverTimestamp();
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUserId)
        .collection("Friends")
        .doc(currentDocId)
        .update({
          "lastMessage": text,
          "pendingCount": 0,
          "dateTime": FieldValue.serverTimestamp(),
        });

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(otherUserId)
        .collection("Friends")
        .doc(otherDocId)
        .update({
          "lastMessage": text,
          "pendingCount": FieldValue.increment(1),
          "dateTime": FieldValue.serverTimestamp(),
        });
  }

  @override
  Widget build(BuildContext context) {
    final chatId = compareId(currentUserId, otherUserId);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xffF0F0F3),
        appBar: AppBar(title: Text(widget.otherUserName)),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("chats")
                    .doc(chatId)
                    .collection("messages")
                    .orderBy("timeStamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No messages yet"));
                  }

                  final docs = snapshot.data!.docs;

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          reverse: true,
                          padding: const EdgeInsets.all(12),
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final data =
                                docs[index].data() as Map<String, dynamic>;

                            final isMe = data["senderId"] == currentUserId;

                            final time = data["timeStamp"] != null
                                ? (data["timeStamp"] as Timestamp).toDate()
                                : null;

                            return Align(
                              alignment: isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  12,
                                  16,
                                  12,
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.8,
                                ),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? AppColors.secondary
                                      : AppColors.backgroundLight,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(16),
                                    topRight: const Radius.circular(16),
                                    bottomLeft: const Radius.circular(16),
                                    bottomRight: const Radius.circular(4),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: isMe
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (data["message"] ?? "").toString(),
                                      style: TextStyle(
                                        color: isMe
                                            ? AppColors.backgroundLight
                                            : AppColors.backgroundDark,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      time != null
                                          ? "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}"
                                          : "",
                                      style: TextStyle(
                                        color: isMe
                                            ? AppColors.backgroundLight
                                            : AppColors.backgroundDark,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      StreamBuilder<bool>(
                        stream: getTypingStatus(
                          currentUserId: currentUserId,
                          otherUserId: otherUserId,
                        ),
                        builder: (context, snapshot) {
                          final isTyping = snapshot.data ?? false;

                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  isTyping ? "typing..." : "",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),

            msgArea(),
          ],
        ),
      ),
    );
  }

  Stream<bool> getTypingStatus({
    required String currentUserId,
    required String otherUserId,
  }) {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(otherUserId)
        .collection("Friends")
        .where("friendUserId", isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return false;

          final data = snapshot.docs.first.data();
          return data['typing'] ?? false;
        });
  }

  Widget msgArea() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(color: isDark ? Colors.black : Colors.white),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
        child: Row(
          children: [
            isDark
                ? Image.asset(
                    "assets/icons/plus_icon_chat_dark.png",
                    width: 42,
                    height: 42,
                  )
                : Image.asset(
                    "assets/icons/plus_icon_chat_light.png",
                    width: 42,
                    height: 42,
                  ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                onChanged: (value) async {
                  print("WRITE → to: $otherUserId, from: $currentUserId");
                  print(value.isNotEmpty);

                  final snap = await FirebaseFirestore.instance
                      .collection("Users")
                      .doc(currentUserId)
                      .collection("Friends")
                      .where("friendUserId", isEqualTo: otherUserId)
                      .limit(1)
                      .get();

                  if (snap.docs.isNotEmpty) {
                    await FirebaseFirestore.instance
                        .collection("Users")
                        .doc(currentUserId)
                        .collection("Friends")
                        .doc(snap.docs.first.id)
                        .update({"typing": value.isNotEmpty});
                  }
                },
                onTapOutside: (event) async {
                  final snap = await FirebaseFirestore.instance
                      .collection("Users")
                      .doc(currentUserId)
                      .collection("Friends")
                      .where("friendUserId", isEqualTo: otherUserId)
                      .limit(1)
                      .get();

                  if (snap.docs.isNotEmpty) {
                    await FirebaseFirestore.instance
                        .collection("Users")
                        .doc(currentUserId)
                        .collection("Friends")
                        .doc(snap.docs.first.id)
                        .update({"typing": false});
                  }
                },
                controller: msgController,
                style: Theme.of(context).textTheme.titleMedium,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  fillColor: isDark
                      ? AppColors.msgFieldDark
                      : AppColors.msgFieldLight,
                  filled: true,
                  hintText: "Type a message...",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () async {
                final snap = await FirebaseFirestore.instance
                    .collection("Users")
                    .doc(currentUserId)
                    .collection("Friends")
                    .where("friendUserId", isEqualTo: otherUserId)
                    .limit(1)
                    .get();

                if (snap.docs.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection("Users")
                      .doc(currentUserId)
                      .collection("Friends")
                      .doc(snap.docs.first.id)
                      .update({"typing": false});
                }
                sendMessage();
              },
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> getFriendDocId() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUserId)
        .collection("Friends")
        .where("participants", arrayContains: otherUserId)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    }

    return null;
  }
}
