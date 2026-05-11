import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_chat/add_friend/add_friend.dart';
import 'package:e_chat/add_group/add_group.dart';
import 'package:e_chat/chat_page/chat_page.dart';
import 'package:e_chat/home_page/navigationdata.dart';
import 'package:e_chat/profile%20page/profile_page.dart';
import 'package:e_chat/utilities/Fire_base_manager.dart';
import 'package:e_chat/utilities/commonColors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../group_page/group_page.dart';
int currentIndex = 0;

class ChatsHomePage extends StatefulWidget {
  const ChatsHomePage({super.key});

  @override
  State<ChatsHomePage> createState() => _ChatsHomePageState();
}

class _ChatsHomePageState extends State<ChatsHomePage> {
  String image = "assets/icons/cross_Icon.png";

  bool isOpened = true;

  late final List<Widget> screens = [
    Center(child: chatData(context: context)),
    GroupPage(),
    ProfilePage(),
    Center(child: Text("More Screen")),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 90),
            child: screens[currentIndex],
          ),

          topSection(),
        ],
      ),

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,

        ),
        child: BottomNavigationBar(

          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: isDark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
          showSelectedLabels: false,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          showUnselectedLabels: false,
          items: NavigationData.getNavItems(context),
          currentIndex: currentIndex,

          onTap: (value) {

            setState(() {
              currentIndex = value;
            });
          },
        ),
      ),
    );
  }

  Widget topSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Image.asset(
          "assets/images/chat_home_bg_lisght.png",
          width: double.infinity,
          height: 140,
          fit: BoxFit.cover,
        ),
        SafeArea(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/main_e_chat_dark.png",
                  width: 100,
                  height: 40,
                ),
                const Spacer(),
                Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 10),
                    PopupMenuButton(
                      constraints: const BoxConstraints.tightFor(width: 330),

                      onOpened: () {
                        setState(() {
                          isOpened = !isOpened;
                        });
                      },
                      onCanceled: () {
                        setState(() {
                          isOpened = !isOpened;
                        });
                      },
                      icon: Image.asset(
                        isOpened
                            ? "assets/icons/plus_icon.png"
                            : "assets/icons/cross_Icon.png",
                        width: isOpened ? 18 : 30,
                      ),
                      offset: Offset(0, 50),

                      itemBuilder: (context) {
                        return <PopupMenuEntry<dynamic>>[
                          PopupMenuItem(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddFriend(),
                                ),
                              );
                            },

                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/icons/addFreind_dark_icon.png",
                                  width: 24,
                                  height: 24,
                                ),

                                SizedBox(width: 16),

                                Text(
                                  "Add Friend",
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.backgroundLight
                                        : AppColors.backgroundDark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          PopupMenuItem(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AddGroup(),));
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/icons/group_icon_inactive.png",
                                  width: 24,
                                  height: 24,
                                ),
                                SizedBox(width: 16),
                                Text(
                                  "Create Group",
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.backgroundLight
                                        : AppColors.backgroundDark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static dynamic chatData({required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder<QuerySnapshot>(
      stream: FireBaseManager.collection
          .doc(globalDocID)
          .collection("Friends")
          .snapshots(),
      builder: (context, snapshot) {
        // 1. Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Error
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        // 3. Empty
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No conversations found."));
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final otherUser = data[FireBaseManager.otherUser] ?? {};
            final mainUser = data["currentUser"] ?? {};

            final isMe = data["senderId"] == globalDocID;


            final name =
                otherUser[FireBaseManager.userName] ?? "Unknown User";

            final otherUserID =
                otherUser[FireBaseManager.docId] ?? "";

            final pic =
            otherUser[FireBaseManager.userPic];

            final lastMsg = (data['lastMessage'] ?? "").toString().isNotEmpty
                ? data['lastMessage']
                : "No messages yet";

            final ts = data['dateTime'];

            String formattedTime = "";

            if (ts != null && ts is Timestamp) {
              final time = ts.toDate();
              formattedTime =
              "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
            }

            final count =
                int.tryParse((data['pendingCount'] ?? 0).toString()) ?? 0;




            return InkWell(
              onTap: () async {
                print("RAW TS: ${data['dateTime']}");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      otherUserId: otherUserID,
                      otherUserName: name,

                    ),
                  ),
                );

                final snap = await FirebaseFirestore.instance
                    .collection("Users")
                    .doc(globalDocID)
                    .collection("Friends")
                    .where("friendUserId", isEqualTo: otherUserID)
                    .limit(1)
                    .get();

                if (snap.docs.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection("Users")
                      .doc(globalDocID)
                      .collection("Friends")
                      .doc(snap.docs.first.id)
                      .update({
                    "pendingCount": 0,
                  });
                }


              },
              child: ListTile(


                leading: ClipOval(
                  child: pic != null && pic.toString().startsWith("http")
                      ? Image.network(
                    pic,
                    width: 42,
                    height: 42,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.account_circle, size: 42),
                  )
                      : const Icon(Icons.account_circle, size: 42),
                ),

                title: Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.backgroundLight
                        : AppColors.backgroundDark,
                    fontSize: 16,
                  ),
                ),

                subtitle: Text(
                  lastMsg,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondaryDark,
                    fontSize: 14,
                  ),
                ),

                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                formattedTime,
                      style: const TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),

                    if (count > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          count.toString(),
                          style: const TextStyle(
                            color: AppColors.backgroundLight,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 18),
                  ],
                ),
              ),
            );
          },
        );
      },
    );  }











}
