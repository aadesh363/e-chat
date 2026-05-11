import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_chat/utilities/Fire_base_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_overlap/flutter_image_overlap.dart';

import '../utilities/commonColors.dart';
String myName ="";
class GroupChatPage extends StatefulWidget {
  final String groupID;

  const GroupChatPage({super.key, required this.groupID});

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  TextEditingController msgController = TextEditingController();
@override
  void initState() {
    // TODO: implement initState

    super.initState();
    getMyName();

}

  Future<void> getMyName() async {

    var snap = await FirebaseFirestore.instance
        .collection("Users")
        .doc(globalDocID)
        .get();

    myName =
        snap.data()?["userName"] ?? "";

    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(globalDocID)
              .collection("Groups")
              .doc(widget.groupID)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return CircularProgressIndicator();
            }
            final data = snapshot.data!.data() as Map<String, dynamic>;

            final ts = data['lastMessageTimme'];

            String formattedTime = "";

            if (ts != null && ts is Timestamp) {
              final time = ts.toDate();

              formattedTime =
                  "${time.hour.toString().padLeft(2, '0')}:"
                  "${time.minute.toString().padLeft(2, '0')}";
            }

            final count = (data['members'] as List?)?.length ?? 0;
            final pics = List<String>.from(data["groupPic"]);

            final visibleImages = pics.take(2).toList();

            final remainingCount = pics.length - visibleImages.length;
            return Column(
              children: [
                AppBar(
                  leading: isDark
                      ? InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Image.asset(
                            "assets/icons/appbar_btn_dark.png",
                          ),
                        )
                      : InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Image.asset(
                            "assets/icons/appbar_btn_light.png",
                          ),
                        ),
                  title: Text("Message"),
                  actions: [
                    isDark
                        ? Image.asset("assets/icons/three_dot_dark.png")
                        : Image.asset("assets/icons/three_dot_light.png"),
                  ],
                ),
                ListTile(
                  minLeadingWidth: 0,
                  horizontalTitleGap: 0,
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      OverlappingImages(
                        images: List<ImageProvider>.from(
                          visibleImages.map((e) => AssetImage(e)),
                        ),

                        imageRadius: 16,
                      ),

                      if (remainingCount > 0)
                        Transform.translate(
                          offset: const Offset(-30, 0),

                          child: Container(
                            width: 40,
                            height: 40,

                            alignment: Alignment.center,

                            decoration: BoxDecoration(
                              shape: BoxShape.circle,

                              color: isDark
                                  ? AppColors.backgroundLight
                                  : AppColors.backgroundDark,
                            ),

                            child: Text(
                              "+$remainingCount",

                              style: TextStyle(
                                color: isDark
                                    ? AppColors.backgroundDark
                                    : AppColors.backgroundLight,

                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data["groupName"],
                        style: TextStyle(
                          color: isDark
                              ? AppColors.backgroundLight
                              : AppColors.backgroundDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "$count members",
                        style: TextStyle(
                          color: isDark
                              ? AppColors.backgroundLight
                              : AppColors.backgroundDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        isDark
                            ? "assets/icons/videoCallDark.png"
                            : "assets/icons/videoCallLight.png",
                        width: 23,
                        height: 18,
                      ),
                      SizedBox(width: 23),
                      Image.asset(
                        isDark
                            ? "assets/icons/phoneDark.png"
                            : "assets/icons/phoneLight.png",
                        width: 23,
                        height: 18,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? Color(0xff2C2D3A) : Color(0xffF0F0F3),
                    ),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Users")
                          .doc(globalDocID)
                          .collection("Groups")
                          .doc(widget.groupID)
                          .collection("messages")
                          .orderBy("timeStamp", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text("No messages yet"));
                        }

                        final docs = snapshot.data!.docs;
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: docs.length,
                                reverse: true,
                                padding: const EdgeInsets.all(12),
                                itemBuilder: (context, index) {
                                  final data =
                                      docs[index].data()
                                          as Map<String, dynamic>;

                                  final isMe =
                                      data["senderId"] == globalDocID;

                                  final time = data["timeStamp"] != null
                                      ? (data["timeStamp"] as Timestamp)
                                            .toDate()
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
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(
                                              context,
                                            ).size.width *
                                            0.8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isMe
                                            ? AppColors.secondary
                                            : AppColors.backgroundLight,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(16),
                                          topRight: const Radius.circular(16),
                                          bottomLeft: const Radius.circular(
                                            16,
                                          ),
                                          bottomRight: const Radius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: isMe
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,

                                        children: [
                                          Text(
                                            (data["message"] ?? "")
                                                .toString(),
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

////////yaha mujhe typing status ka logic dalna he


                          StreamBuilder(stream: FirebaseFirestore.instance.collection("Users").doc(globalDocID).collection("Groups").doc(widget.groupID).snapshots(), builder: (context, snapshot) {

                            if (!snapshot.hasData) {
                              return SizedBox();
                            }

                            final data =
                            snapshot.data!.data()
                            as Map<String, dynamic>;

                            List typingUsers =
                                data["typingUser"] ?? [];
                            typingUsers.remove(
                             myName
                            );
                            if( typingUsers.isEmpty) {
                            return  SizedBox();
                            }
                            String typingText = "";

                            if (typingUsers.length > 2) {

                              typingText =
                              "Multiple users typing...";

                            } else {

                              typingText =
                              "${typingUsers.join(",")} typing...";
                            }
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [


                                  Text(

                                    typingText,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },)
                          ],
                        );
                      },
                    ),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black : Colors.white,
                  ),
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
                              bool typingStatus=value.trim().isNotEmpty;
                              var snap = await FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(globalDocID)
                                  .get();

                              var name = snap.data();

                              print(name?["userName"]);
                              print("My name is $myName");
                              for(var i in data["members"])
                                {
                                  FirebaseFirestore.instance.collection("Users").doc(i).collection("Groups").doc(widget.groupID).update(
                                      {

                                        "typingUser":typingStatus?FieldValue.arrayUnion([name?["userName"]]):FieldValue.arrayRemove([name?["userName"]]),
                                      });
                                }
                              FirebaseFirestore.instance.collection("Users").doc(globalDocID).collection("Groups").doc(widget.groupID).update(
                                {"typingUser":typingStatus?FieldValue.arrayUnion([name?["userName"]]):FieldValue.arrayRemove([name?["userName"]]),}
                              );

                            },
                            onTapOutside: (event) async {
                              var snap = await FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(globalDocID)
                                  .get();

                              var name = snap.data();
                              for(var i in data["members"])
                              {
                                FirebaseFirestore.instance.collection("Users").doc(i).collection("Groups").doc(widget.groupID).update(
                                    {

                                      "typingUser":FieldValue.arrayRemove([name?["userName"]]),
                                    });
                              }
                              FirebaseFirestore.instance.collection("Users").doc(globalDocID).collection("Groups").doc(widget.groupID).update(
                                  {"typingUser":FieldValue.arrayRemove([name?["userName"]]),}
                              );
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
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
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
                            final text = msgController.text.trim();
                            if (text.isEmpty) return;
                            msgController.clear();

                            print(widget.groupID);
                            await sendMessage(text: text);
                            for (var i in data["members"]) {
                              if (i != globalDocID) {
                                await sendOtherMessage(docsID: i, text: text);
                              }
                            }
                            if (data["adminId"] != globalDocID) {
                              await sendOtherMessage(
                                docsID: data["adminId"],
                                text: text,
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> sendMessage({required String text}) async {
    // final text = msgController.text.trim();
    // if (text.isEmpty) return;

    // msgController.clear();

    // final chatId = compareId(currentUserId, otherUserId);
    final senderMSG = FirebaseFirestore.instance
        .collection("Users")
        .doc(globalDocID)
        .collection("Groups")
        .doc(widget.groupID)
        .collection("messages")
        .doc();

    await senderMSG.set({
      "senderId": globalDocID,
      "message": text,
      "timeStamp": FieldValue.serverTimestamp(),
      "messageID": senderMSG.id,
    });
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(globalDocID)
        .collection("Groups")
        .doc(widget.groupID)
        .update({
          "lastMessage": text,

          "createdAt": FieldValue.serverTimestamp(),

          "pendingCount": 0,
        });
  }

  Future<void> sendOtherMessage({
    required String docsID,
    required String text,
  }) async {
    final participantMSG = FirebaseFirestore.instance
        .collection("Users")
        .doc(docsID)
        .collection("Groups")
        .doc(widget.groupID)
        .collection("messages")
        .doc();

    await participantMSG.set({
      "senderId": globalDocID,
      "message": text,
      "timeStamp": FieldValue.serverTimestamp(),
      "messageID": participantMSG.id,
    });
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(docsID)
        .collection("Groups")
        .doc(widget.groupID)
        .update({
          "pendingCount": FieldValue.increment(1),

          "lastMessage": text,

          "createdAt": FieldValue.serverTimestamp(),
        });
  }


  }



