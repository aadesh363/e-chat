import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_chat/add_friend/add_friend.dart';
import 'package:e_chat/home_page/navigationdata.dart';
import 'package:e_chat/profile%20page/profile_page.dart';
import 'package:e_chat/utilities/Fire_base_manager.dart';
import 'package:e_chat/utilities/commonColors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatsHomePage extends StatefulWidget {
  const ChatsHomePage({super.key});

  @override
  State<ChatsHomePage> createState() => _ChatsHomePageState();
}

class _ChatsHomePageState extends State<ChatsHomePage> {
  int currentIndex = 0;
  String image = "assets/icons/cross_Icon.png";

  bool isOpened = true;



  late final List<Widget> screens = [
    Center(child: chatData(context: context)),
    Center(child: Text("Groups Screen")),
   ProfilePage().profileScreen(context: context),
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
          /// Current User Doc ID
          .collection("Friends")
          .snapshots(),
      builder: (context, snapshot) {
        // 1. Handle Loading State
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Handle Errors
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        // 3. Check for Data
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No conversations found."));
        }

        final docs = snapshot.data!.docs;
        // 4. Build Dynamic List
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            // Extract data for the current item
            final doc = docs[index];
            // final data = doc.data() as Map<String, dynamic>;

            return ListTile(
              onTap: () {
                // Add navigation to Message Page here
              },
              leading: ClipOval(
                child:
                    doc[FireBaseManager.otherUser][FireBaseManager.userPic] !=
                        null
                    ? Image.file(
                        File(
                          doc[FireBaseManager.otherUser][FireBaseManager
                              .userPic],
                        ),
                        width: 42,
                        height: 42,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.account_circle, size: 42),
                      )
                    : const Icon(Icons.account_circle, size: 42),
              ),
              title: Text(
                doc[FireBaseManager.otherUser][FireBaseManager.userName] ??
                    "Unknown User",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.backgroundLight :
                      AppColors.backgroundDark,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                doc[FireBaseManager.otherUser]['lastMsg'] != null &&
                        doc[FireBaseManager.otherUser]['lastMsg'] != ""
                    ? doc[FireBaseManager.otherUser]['lastMsg']
                    : "No messages yet",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondaryDark,
                  fontSize: 14, // Reduced slightly for subtitle
                ),
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min, // Prevents overflow in ListTile
                children: [
                  Text(
                    doc[FireBaseManager.otherUser]['dateTime'] ?? "",
                    style: TextStyle(
                      color: AppColors.textSecondaryDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Dynamic Unread Badge
                  if (doc[FireBaseManager.otherUser]['pendingMessageCount'] !=
                          null &&
                      doc[FireBaseManager.otherUser]['pendingMessageCount'] !=
                          "")
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        doc[FireBaseManager.otherUser]['pendingMessageCount']
                            .toString(),
                        style: const TextStyle(
                          color: AppColors.backgroundLight,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 18), // Maintain layout alignment
                ],
              ),
            );
          },
        );
      },
    );
  }

}
