import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_chat/home_page/ChatsHomePage.dart';
import 'package:e_chat/utilities/Fire_base_manager.dart';
import 'package:e_chat/utilities/commonColors.dart';
import 'package:e_chat/utilities/commonWidget.dart';
import 'package:flutter/material.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({super.key});

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  final searchController = TextEditingController();
  final user = [];
  bool typeStart = false;

  String dialCode = "+91";
  var userData;


  TextEditingController phoneEditingController = TextEditingController();


  @override
  Future<void> getData() async {
    var data = await FireBaseManager.getData();
    setState(() {



      dialCode = userData?[FireBaseManager.dialCOde] ?? "+91";

    });
  }
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {

        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(

          children: [
            Stack(
              children: [
                Image.asset("assets/images/chat_home_bg_lisght.png"),

                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return ChatsHomePage();
                            },));
                          },
                          child: Image.asset(
                            "assets/images/add_frnd_btn.png",
                            width: 42,
                            height: 42,
                          ),
                        ),

                        const Spacer(),
                        Text(
                          "Add Friend",
                          style: TextStyle(
                            fontSize: 22,
                            color: AppColors.backgroundLight,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 24),
                child: CWidget.commonTextField(
                 onChanges: (p0) async{
                   var a = await FireBaseManager.searchUsersByNumber(controller: phoneEditingController,dialCode:dialCode );
                    user.clear();
                   final friendSnap = await FirebaseFirestore.instance
                       .collection("Users")
                       .doc(globalDocID)
                       .collection("Friends")
                       .get();

                   final friendIds = friendSnap.docs
                       .map((doc) => doc['friendUserId'])
                       .toList();

                   final newDocs = a.where((doc) =>
                   doc[FireBaseManager.docId] != globalDocID &&
                       !friendIds.contains(doc[FireBaseManager.docId])
                   );
                   user.addAll(newDocs);
                    setState(() {});
                 },

                  isBorder: true,
                  context,


                  controller: phoneEditingController,
                  onCountryChanged: (p0) {},
                  dialCode: dialCode,
                  dialogBackgroundColor: isDark
                      ? AppColors.backgroundDark
                      : AppColors.backgroundLight,
                ),
              ),
            ),
                           user.isEmpty? Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 60,
                horizontal: 18,
              ),
              child: Image.asset("assets/images/add_frnd_BG.png",height: 286,width: 240,),
            ):SizedBox(
             height: 200,
              child: ListView.builder(
                itemCount: user.length,
                itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    width: 60,
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child:
                      user[index][FireBaseManager.userPic] != null &&
                          (!user[index][FireBaseManager.userPic]
                              .toString()
                              .contains("assets"))
                          ? Image.file(
                        File(user[index][FireBaseManager.userPic]),
                        width: 30,
                        fit: BoxFit.contain,
                      )
                          : Image.asset(
                        user[index][FireBaseManager.userPic],
                        width: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    user[index][FireBaseManager.userName],
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  subtitle: Text(
                    user[index][FireBaseManager.mobileNumber],
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textSecondaryDark,
                      fontSize: 12,
                    ),
                  ),
                  trailing: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.backgroundLight.withOpacity(0.2),
                    ),
                    child: Center(
                      child: InkWell(
                        onTap: () async {
                          var currentUserData = await FireBaseManager.getData();
                          final otherId = user[index][FireBaseManager.docId];

                          final currentUserRef = FirebaseFirestore.instance
                              .collection("Users")
                              .doc(globalDocID)
                              .collection("Friends");

                          final otherUserRef = FirebaseFirestore.instance
                              .collection("Users")
                              .doc(otherId)
                              .collection("Friends");

                          final doc1 = await currentUserRef.add({
                            FireBaseManager.participants: [globalDocID, otherId],

                            FireBaseManager.currentUser: {
                              FireBaseManager.userName: currentUserData[FireBaseManager.userName],
                              FireBaseManager.docId: currentUserData[FireBaseManager.docId],
                              FireBaseManager.userPic: currentUserData[FireBaseManager.userPic],
                              FireBaseManager.dateTime: "",
                            },

                            FireBaseManager.otherUser: {
                              FireBaseManager.userName: user[index][FireBaseManager.userName],
                              FireBaseManager.docId: otherId,
                              FireBaseManager.userPic: user[index][FireBaseManager.userPic],
                              FireBaseManager.dateTime: "",
                            },

                            "friendUserId": otherId,
                            FireBaseManager.timeStamp: FieldValue.serverTimestamp(),
                          });

                          final doc2 = await otherUserRef.add({
                            FireBaseManager.participants: [globalDocID, otherId],

                            FireBaseManager.otherUser: {
                              FireBaseManager.userName: currentUserData[FireBaseManager.userName],
                              FireBaseManager.docId: globalDocID,
                              FireBaseManager.userPic: currentUserData[FireBaseManager.userPic],
                            },

                            FireBaseManager.currentUser: {
                              FireBaseManager.userName: user[index][FireBaseManager.userName],
                              FireBaseManager.docId: otherId,
                              FireBaseManager.userPic: user[index][FireBaseManager.userPic],
                            },

                            "friendUserId": globalDocID,
                            FireBaseManager.timeStamp: FieldValue.serverTimestamp(),
                          });

                        }                       ,
                        child: Image.asset(
                         "assets/icons/addFrndIcon.png",
                          color: AppColors.primary,
                          width: 24,
                        ),
                      ),
                    ),
                  ),
                );
              },),
            ),
          ],
        ),
      ),
    );
  }
}
