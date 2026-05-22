import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_chat/Group_chat_page/group_chat_page.dart';
import 'package:e_chat/group_page/group_page.dart';
import 'package:e_chat/utilities/Fire_base_manager.dart';
import 'package:e_chat/utilities/commonWidget.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../home_page/ChatsHomePage.dart';
import '../utilities/Firebase_Group_manager.dart';
import '../utilities/commonColors.dart';

class AddGroup extends StatefulWidget {
  const AddGroup({super.key});

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  TextEditingController nameEditingController = TextEditingController();
  List oldParticipants = [];
  List names = [];

  TextEditingController searchEditingController = TextEditingController();
  bool isChecked = false;
  List<bool> boolSet = [];
  List<Map<String, dynamic>> participants = <Map<String, dynamic>>[];
  var users = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  var data;

  Future<void> getData() async {
    var snap = await FirebaseFirestore.instance.collection("Users").get();
    for (var ui in snap.docs) {
      if (ui["docId"] != globalDocID) {
        print(ui["userName"]);
      }
      //  print(ui[FireBaseManager.userName]);
    }
    setState(() {
      data = snap.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
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

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ChatsHomePage();
                                },
                              ),
                            );
                          },
                          child: Image.asset(
                            "assets/images/add_frnd_btn.png",
                            width: 42,
                            height: 42,
                          ),
                        ),

                        const Spacer(),
                        Text(
                          "Create Group",
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

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name Group",
                      style: TextStyle(
                        color: isDark ? Color(0xffD0D1DB) : Color(0xff686A8A),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 9),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: TextFormField(
                        style: Theme.of(context).textTheme.titleMedium,
                        showCursor: false,
                        controller: nameEditingController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: "Enter Group name",
                          hintStyle: Theme.of(context).textTheme.titleMedium,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Members",
                      style: TextStyle(
                        color: isDark ? Color(0xffD0D1DB) : Color(0xff686A8A),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,

                          context: context,
                          builder: (context) {
                            oldParticipants = List.from(participants);
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(
                                      context,
                                    ).viewInsets.bottom,
                                  ),

                                  child: SingleChildScrollView(
                                    child: Stack(
                                      alignment: AlignmentGeometry.bottomCenter,
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(height: 10),
                                            Container(
                                              width: 61,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius:
                                                    BorderRadius.circular(11),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "Add members to group",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                            ),
                                            SizedBox(height: 16),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsGeometry.symmetric(
                                                    horizontal: 20,
                                                  ),
                                              child: SizedBox(
                                                height: 56,
                                                width: double.infinity,
                                                child: TextFormField(
                                                  controller:
                                                      searchEditingController,
                                                  onChanged: (value) async {
                                                    var a = await FireBaseManager.searchUserByName(
                                                      controller:
                                                          searchEditingController,
                                                    );
                                                    users.clear();
                                                    final friendSnap =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection("Users")
                                                            .doc(globalDocID)
                                                            .collection(
                                                              "Friends",
                                                            )
                                                            .get();

                                                    final friendIds = friendSnap
                                                        .docs
                                                        .map(
                                                          (doc) =>
                                                              doc['friendUserId'],
                                                        )
                                                        .toList();

                                                    final newDocs = a.where(
                                                      (doc) =>
                                                          doc[FireBaseManager
                                                                  .docId] !=
                                                              globalDocID &&
                                                          friendIds.contains(
                                                            doc[FireBaseManager
                                                                .docId],
                                                          ) &&
                                                          !participants.any(
                                                            (e) =>
                                                                e["docId"] ==
                                                                doc[FireBaseManager
                                                                    .docId],
                                                          ) &&
                                                          !users.any(
                                                            (e) =>
                                                                e[FireBaseManager
                                                                    .docId] ==
                                                                doc[FireBaseManager
                                                                    .docId],
                                                          ),
                                                    );
                                                    users.addAll(newDocs);

                                                    boolSet = List.generate(
                                                      users.length,
                                                      (index) => false,
                                                    );

                                                    setState(() {});
                                                  },
                                                  onTapOutside: (event) {
                                                    if (FocusManager
                                                            .instance
                                                            .primaryFocus
                                                            ?.hasFocus ??
                                                        false) {
                                                      FocusManager
                                                          .instance
                                                          .primaryFocus
                                                          ?.unfocus();
                                                    }
                                                  },
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),

                                                  decoration: InputDecoration(
                                                    hintText: "Search",
                                                    hintStyle: TextStyle(
                                                      color: Color(0xffBABDC1),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color: Color(
                                                                  0xffBABDC1,
                                                                ),
                                                              ),
                                                        ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                          borderSide:
                                                              BorderSide(
                                                                color: Color(
                                                                  0xffBABDC1,
                                                                ),
                                                              ),
                                                        ),

                                                    prefixIcon: Icon(
                                                      Icons.search_rounded,
                                                      color: Color(0xffBABDC1),
                                                      size: 25,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            SizedBox(
                                              height: 400,

                                              child: StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection("Users")
                                                    .where(
                                                      FieldPath.documentId,
                                                      isNotEqualTo: globalDocID,
                                                    )
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.data == null) {
                                                    return CircularProgressIndicator();
                                                  }
                                                  var docs =
                                                      snapshot.data!.docs;

                                                  return SizedBox(
                                                    //height: 600,
                                                    child: ListView.builder(
                                                      itemCount: users.length,

                                                      itemBuilder: (context, index) {
                                                        var listItem =
                                                            users[index];

                                                        return memberData(
                                                          mobileNumber:
                                                              listItem[FireBaseManager
                                                                  .mobileNumber],

                                                          onTap: () {
                                                            final alreadyExists =
                                                                participants.any(
                                                                  (e) =>
                                                                      e["docId"] ==
                                                                      listItem[FireBaseManager
                                                                          .docId],
                                                                );

                                                            setState(() {
                                                              if (alreadyExists) {
                                                                participants.removeWhere(
                                                                  (e) =>
                                                                      e["docId"] ==
                                                                      listItem[FireBaseManager
                                                                          .docId],
                                                                );
                                                              } else {
                                                                participants.add({
                                                                  "docId":
                                                                      listItem[FireBaseManager
                                                                          .docId],
                                                                  "mobileNo":
                                                                      listItem[FireBaseManager
                                                                          .mobileNumber],
                                                                  "userPic":
                                                                      listItem[FireBaseManager
                                                                          .userPic],

                                                                  "boolValue":
                                                                      true,

                                                                  "userName":
                                                                      listItem[FireBaseManager
                                                                          .userName],
                                                                });
                                                              }
                                                            });
                                                          },

                                                          boolValue:
                                                              participants.any(
                                                                (e) =>
                                                                    e["docId"] ==
                                                                    listItem[FireBaseManager
                                                                        .docId],
                                                              ),

                                                          userImage:
                                                              listItem[FireBaseManager
                                                                  .userPic],

                                                          userName:
                                                              listItem[FireBaseManager
                                                                  .userName],
                                                        );

                                                        //   Text(
                                                        //   listItem[FireBaseManager
                                                        //       .userName],
                                                        // );
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsGeometry.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10,
                                                  ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CWidget.commonELBTN(
                                                    onPressed: () {
                                                      print("lll");
                                                      Navigator.pop(context);
                                                    },
                                                    text: "Cancel`",
                                                    width: 160,
                                                    color: AppColors
                                                        .pinSkipBtnLight,
                                                    textColor:
                                                        AppColors.blueTextClr,
                                                  ),
                                                  Spacer(),
                                                  CWidget.commonELBTNG(
                                                    context,
                                                    boxShadow: [],
                                                    onTap: () {
                                                      bool isSame =
                                                          oldParticipants
                                                                  .length ==
                                                              participants
                                                                  .length &&
                                                          oldParticipants.every(
                                                            (
                                                              e,
                                                            ) => participants.any(
                                                              (p) =>
                                                                  p["docId"] ==
                                                                  e["docId"],
                                                            ),
                                                          );

                                                      if (isSame) {
                                                        CWidget.toast(
                                                          msg:
                                                              "No changes made",
                                                          backgroundColor:
                                                              Colors.red,
                                                        );

                                                        return;
                                                      }

                                                      CWidget.toast(
                                                        msg: "Added",
                                                        backgroundColor:
                                                            AppColors.primary,
                                                      );

                                                      Navigator.pop(context);
                                                    },
                                                    text: "Add",
                                                    width: 160,
                                                    fontSize: 18,
                                                    gradient:
                                                        AppColors.gradient,

                                                    color: AppColors
                                                        .backgroundLight,
                                                    height: 60,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Color(0xffECF9FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/plus_icon_gradiant.png",
                              width: 18,
                              height: 18,
                            ),
                            SizedBox(width: 10),
                            GradientText(
                              "Add members to group",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              colors: [Color(0xff40C4FF), Color(0xff03A9F4)],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: participants.length,

                        itemBuilder: (context, index) {
                          final participant = participants[index];
                          return ListTile(
                            title: Row(
                              children: [
                                ClipOval(
                                  child: Image.asset(
                                    participant["userPic"],
                                    width: 42,
                                    height: 42,
                                    fit: BoxFit.cover,

                                    errorBuilder: (context, error, stackTrace) {

                                      return Image.asset(
                                        "assets/images/user_icon_light.png",
                                        width: 42,
                                        height: 42,
                                        fit: BoxFit.cover,
                                      );

                                    },
                                  ),
                                ),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      participant["userName"],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    Text(
                                      participant["mobileNo"],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            trailing: InkWell(
                              onTap: () {
                                setState(() {
                                  participants.removeAt(index);
                                });
                              },
                              child: SizedBox(
                                child: isDark
                                    ? Image.asset(
                                        "assets/icons/darkCross.png",
                                        width: 36,
                                        height: 36,
                                      )
                                    : Image.asset(
                                        "assets/icons/lightCross.png",
                                        width: 36,
                                        height: 36,
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    Center(
                      child: CWidget.commonELBTNG(

                        context,
                        onTap: () async {
                          if(nameEditingController.text.trim()==""){
                            CWidget.toast(msg: "add group name first");
                            return;
                          }
                          if(participants.isEmpty){
                            CWidget.toast(msg: "add participants first");
                          return;
                          }

                          var adminSnap = await FirebaseFirestore.instance
                              .collection("Users")
                              .doc(globalDocID)
                              .get();

                          var adminData = adminSnap.data();
                          print(participants);
                          //  print("participants");
                          String groupID= FirebaseFirestore.instance.collection("temprory").doc().id;

                          GroupManager.createGroup(
                            userId: globalDocID,
                            groupName: nameEditingController.text,
                            members: participants
                                .map<String>((e) => e["docId"].toString())
                                .toList(),
                            groupPic: [
                              adminData?["userPic"]
                            ,
                              ...participants.map<String>(
                                    (e) => e["userPic"].toString(),
                              ),
                            ],
                              gID: groupID,
                          );
                            for (var ids in participants){
                              GroupManager.createGroup(gID: groupID,groupName: nameEditingController.text, members: participants
                                  .map<String>((e) => e["docId"].toString())
                                  .toList(), groupPic: [
                                adminData?["userPic"]
                                ,
                                ...participants.map<String>(
                                      (e) => e["userPic"].toString(),
                                ),
                              ],userId: ids["docId"]);
                            }
                          CWidget.showLoader(context);
                          await Future.delayed(Duration(seconds: 2));

                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          setState(() {
                            currentIndex=1;

                          });
                        },
                        text: "Create Group",
                        width: double.infinity,
                        fontSize: 20,
                        gradient: AppColors.gradient,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 45),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget memberData({
    required String userImage,
    required String userName,
    required void Function() onTap,
    required bool boolValue,
    required String mobileNumber,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        SizedBox(
          height: 45,
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
            child: Row(
              children: [
                ClipOval(child: Image.asset(userImage, width: 42, height: 42)),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      mobileNumber,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff686A8A),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                InkWell(
                  onTap: onTap,
                  child: Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      border: Border.all(color: cs.secondary.withOpacity(0.5)),
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    child: boolValue
                        ? Image.asset("assets/images/tick_checkbox.png")
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
