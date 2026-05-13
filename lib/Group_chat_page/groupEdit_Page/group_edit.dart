import 'package:e_chat/utilities/commonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_overlap/flutter_image_overlap.dart';

import '../../utilities/Fire_base_manager.dart';
import '../../utilities/commonColors.dart';
import '../group_chat_page.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupEdit extends StatefulWidget {
  final String adminID;
  final String groupID;

  const GroupEdit({required this.adminID, required this.groupID, super.key});

  @override
  State<GroupEdit> createState() => _GroupEditState();
}

class _GroupEditState extends State<GroupEdit> {
  TextEditingController searchEditingController = TextEditingController();

  TextEditingController groupNameController = TextEditingController();
  List<Map<String, dynamic>> addMembers = [];
  Color pickerColor = const Color(0xff2C2D3A);
  List<Map<String, dynamic>> membersData = [];

  Future<void> getUsername(List members) async {
    membersData.clear();

    final futures = members.map((m) async {
      final doc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(m)
          .get();

      final data = doc.data();

      if (data != null) {
        return {...data, "docId": doc.id};
      }

      return null;
    });

    final results = await Future.wait(futures);

    membersData = results.whereType<Map<String, dynamic>>().toList();

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Admin ID---${widget.adminID}");
    print("Group ID----${widget.groupID}");

    getColor();
  }

  Future<void> getColor() async {
    var snap = await FirebaseFirestore.instance
        .collection("Users")
        .doc(globalDocID)
        .collection("Groups")
        .doc(widget.groupID)
        .get();

    final data = snap.data();

    if (data?["colorBG"] != null) {
      pickerColor = Color(data!["colorBG"]);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool adminAccess = widget.adminID == globalDocID;
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsetsGeometry.symmetric(horizontal: 10),
        leading: isDark
            ? InkWell(
                onTap: () => Navigator.pop(context),
                child: Image.asset("assets/icons/appbar_btn_dark.png"),
              )
            : InkWell(
                onTap: () => Navigator.pop(context),
                child: Image.asset("assets/icons/appbar_btn_light.png"),
              ),

        actions: [
          Row(
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
              InkWell(
                onTap: () {},
                child: Image.asset(
                  isDark
                      ? "assets/icons/phoneDark.png"
                      : "assets/icons/phoneLight.png",
                  width: 23,
                  height: 18,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          color: pickerColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: AppColors.onboardingBg,
                              title: Center(
                                child: Text(
                                  'Pick group chat background color!',
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimaryLight,
                                  ),
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  colorPickerWidth: 200,
                                  pickerColor: pickerColor,
                                  onColorChanged: (color) {
                                    setState(() {
                                      pickerColor = color;
                                    });
                                  },
                                ),
                              ),
                              actions: [
                                CWidget.commonELBTNG(
                                  context,
                                  onTap: () async {
                                    await FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(globalDocID)
                                        .collection("Groups")
                                        .doc(widget.groupID)
                                        .update({"colorBG": pickerColor.value});

                                    Navigator.pop(context);
                                  },
                                  text: "Save",
                                  width: 50,
                                  fontSize: 12,
                                  gradient: AppColors.gradient,
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Image.asset(
                        "assets/images/picker_icon.png",
                        width: 45,
                        height: 45,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(globalDocID)
                    .collection("Groups")
                    .doc(widget.groupID)
                    .snapshots(),

                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;

                  final members = List<String>.from(data["members"] ?? []);

                  final count = members.length;

                  final pics = List<String>.from(data["groupPic"] ?? []);

                  final visibleImages = pics.take(2).toList();

                  final remainingCount = pics.length - visibleImages.length;

                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,

                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data["groupName"],

                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: isDark ? Colors.white : Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),

                            const SizedBox(width: 17),

                            GestureDetector(
                              onTap: () async {
                                groupNameController.text =
                                    data["groupName"] ?? "";
                                showDialog(
                                  context: context,

                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Enter new group name"),

                                      titleTextStyle: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(fontSize: 16),

                                      alignment: Alignment.center,

                                      actions: [
                                        TextFormField(
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium,

                                          controller: groupNameController,
                                        ),
                                        SizedBox(height: 10),

                                        Row(
                                          children: [
                                            CWidget.commonELBTNG(
                                              context,
                                              gradient: AppColors.gradient,
                                              onTap: () {
                                                Navigator.pop(context);
                                              },

                                              text: "Cancel",

                                              width: 100,
                                              fontSize: 16,
                                            ),
                                            Spacer(),

                                            CWidget.commonELBTNG(
                                              context,
                                              gradient: AppColors.gradient,
                                              onTap: () async {
                                                for (var i in members) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("Users")
                                                      .doc(i)
                                                      .collection("Groups")
                                                      .doc(widget.groupID)
                                                      .update({
                                                        "groupName":
                                                            groupNameController
                                                                .text,
                                                      });
                                                }

                                                Navigator.pop(context);
                                              },

                                              text: "Save",

                                              width: 100,
                                              fontSize: 16,
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },

                              child: Image.asset(
                                isDark
                                    ? "assets/icons/Pen.png"
                                    : "assets/icons/pen_light.png",

                                width: 21,
                                height: 21,
                              ),
                            ),
                          ],
                        ),

                        Text(
                          "$count members",

                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                        ),

                        const SizedBox(height: 32),

                        InkWell(
                          onTap: () async {
                            await getUsername(members);

                            showModalBottomSheet(
                              isScrollControlled: true,

                              context: context,

                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(
                                          context,
                                        ).viewInsets.bottom,
                                      ),

                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 10),

                                            Container(
                                              width: 61,
                                              height: 4,

                                              decoration: BoxDecoration(
                                                color: Colors.black12,

                                                borderRadius:
                                                    BorderRadius.circular(11),
                                              ),
                                            ),

                                            const SizedBox(height: 8),

                                            Text(
                                              "All members of Group",

                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                            ),

                                            const SizedBox(height: 16),

                                            SizedBox(
                                              height: 400,

                                              child: ListView.builder(
                                                itemCount: membersData.length,

                                                itemBuilder: (context, index) {
                                                  final user =
                                                      membersData[index];

                                                  return memberData(
                                                    userName: user["userName"],

                                                    mobileNumber:
                                                        user["MobileNumber"],

                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                              "Are you sure you want to remove ${user["userName"]} from the group?",
                                                            ),

                                                            titleTextStyle:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .bodyLarge
                                                                    ?.copyWith(
                                                                      fontSize:
                                                                          18,
                                                                    ),

                                                            alignment: Alignment
                                                                .center,

                                                            actions: [
                                                              // TextFormField(
                                                              //   style: Theme.of(
                                                              //     context,
                                                              //   ).textTheme.titleMedium,
                                                              //
                                                              //   controller: groupNameController,
                                                              // ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),

                                                              Row(
                                                                children: [
                                                                  CWidget.commonELBTNG(
                                                                    context,
                                                                    gradient:
                                                                        AppColors
                                                                            .gradient,
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                        context,
                                                                      );
                                                                    },

                                                                    text:
                                                                        "Cancel",

                                                                    width: 85,
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                  Spacer(),

                                                                  CWidget.commonELBTNG(
                                                                    context,
                                                                    gradient:
                                                                        AppColors
                                                                            .gradient,
                                                                    onTap: () async {
                                                                      final removedUserId =
                                                                          user["docId"];
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                            "Users",
                                                                          )
                                                                          .doc(
                                                                            removedUserId,
                                                                          )
                                                                          .collection(
                                                                            "Groups",
                                                                          )
                                                                          .doc(
                                                                            widget.groupID,
                                                                          )
                                                                          .delete();
                                                                      for (var i
                                                                          in members) {
                                                                        if (i ==
                                                                            removedUserId)
                                                                          continue;
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection(
                                                                              "Users",
                                                                            )
                                                                            .doc(
                                                                              i,
                                                                            )
                                                                            .collection(
                                                                              "Groups",
                                                                            )
                                                                            .doc(
                                                                              widget.groupID,
                                                                            )
                                                                            .update({
                                                                              "members": FieldValue.arrayRemove(
                                                                                [
                                                                                  removedUserId,
                                                                                ],
                                                                              ),
                                                                            });
                                                                      }
                                                                      membersData.removeWhere(
                                                                        (e) =>
                                                                            e["docId"] ==
                                                                            removedUserId,
                                                                      );
                                                                      setState(
                                                                        () {},
                                                                      );
                                                                      CWidget.showLoader(
                                                                        context,
                                                                      );
                                                                      await Future.delayed(
                                                                        Duration(
                                                                          seconds:
                                                                              2,
                                                                        ),
                                                                      );
                                                                      Navigator.pop(
                                                                        context,
                                                                      );
                                                                      Navigator.pop(
                                                                        context,
                                                                      );
                                                                    },

                                                                    text: "Yes",

                                                                    width: 85,
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },

                                                    userImage: user["userPic"],

                                                    boolValue: true,

                                                    crossImage: isDark
                                                        ? "assets/icons/darkCross.png"
                                                        : "assets/icons/lightCross.png",

                                                    admin:
                                                        widget.adminID ==
                                                        globalDocID,
                                                  );
                                                },
                                              ),
                                            ),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10,
                                                  ),

                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,

                                                children: [
                                                  Row(
                                                    children: [
                                                      CWidget.commonELBTN(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },

                                                        text: "Back",

                                                        width: 160,

                                                        color: AppColors
                                                            .pinSkipBtnLight,

                                                        textColor: AppColors
                                                            .blueTextClr,
                                                      ),
                                                      SizedBox(width: 20),
                                                      adminAccess
                                                          ? CWidget.commonELBTN(
                                                              onPressed: () async {
                                                                addMembers
                                                                    .clear();

                                                                final usersSnap =
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                          "Users",
                                                                        )
                                                                        .get();

                                                                for (var doc
                                                                    in usersSnap
                                                                        .docs) {
                                                                  final user =
                                                                      doc.data();

                                                                  if (doc.id !=
                                                                          globalDocID &&
                                                                      !members
                                                                          .contains(
                                                                            doc.id,
                                                                          )) {
                                                                    addMembers.add({
                                                                      ...user,
                                                                      "docId":
                                                                          doc.id,
                                                                    });
                                                                  }
                                                                }

                                                                showModalBottomSheet(
                                                                  isScrollControlled:
                                                                      true,

                                                                  context:
                                                                      context,

                                                                  builder: (context) {
                                                                    return StatefulBuilder(
                                                                      builder:
                                                                          (
                                                                            context,
                                                                            setState,
                                                                          ) {
                                                                            return Padding(
                                                                              padding: EdgeInsets.only(
                                                                                bottom: MediaQuery.of(
                                                                                  context,
                                                                                ).viewInsets.bottom,
                                                                              ),

                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,

                                                                                children: [
                                                                                  const SizedBox(
                                                                                    height: 10,
                                                                                  ),

                                                                                  Container(
                                                                                    width: 61,
                                                                                    height: 4,

                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors.black12,

                                                                                      borderRadius: BorderRadius.circular(
                                                                                        11,
                                                                                      ),
                                                                                    ),
                                                                                  ),

                                                                                  const SizedBox(
                                                                                    height: 16,
                                                                                  ),

                                                                                  Text(
                                                                                    "Add Members",

                                                                                    style: Theme.of(
                                                                                      context,
                                                                                    ).textTheme.titleMedium,
                                                                                  ),

                                                                                  const SizedBox(
                                                                                    height: 16,
                                                                                  ),

                                                                                  SizedBox(
                                                                                    height: 400,

                                                                                    child: ListView.builder(
                                                                                      itemCount: addMembers.length,

                                                                                      itemBuilder:
                                                                                          (
                                                                                            context,
                                                                                            index,
                                                                                          ) {
                                                                                            final user = addMembers[index];

                                                                                            return memberData(
                                                                                              userName: user["userName"],

                                                                                              mobileNumber: user["MobileNumber"],

                                                                                              userImage: user["userPic"],

                                                                                              boolValue: true,

                                                                                              crossImage: "assets/icons/plus_icon_chat_light.png",

                                                                                              admin: true,

                                                                                              onTap: () async {
                                                                                                final newUserId = user["docId"];

                                                                                                final updatedMembers = [
                                                                                                  ...members,
                                                                                                  newUserId,
                                                                                                ];

                                                                                                // add group to new user
                                                                                                await FirebaseFirestore.instance
                                                                                                    .collection(
                                                                                                      "Users",
                                                                                                    )
                                                                                                    .doc(
                                                                                                      newUserId,
                                                                                                    )
                                                                                                    .collection(
                                                                                                      "Groups",
                                                                                                    )
                                                                                                    .doc(
                                                                                                      widget.groupID,
                                                                                                    )
                                                                                                    .set(
                                                                                                      {
                                                                                                        ...data,

                                                                                                        "members": updatedMembers,
                                                                                                      },
                                                                                                    );

                                                                                                // update old users
                                                                                                for (var i in members) {
                                                                                                  await FirebaseFirestore.instance
                                                                                                      .collection(
                                                                                                        "Users",
                                                                                                      )
                                                                                                      .doc(
                                                                                                        i,
                                                                                                      )
                                                                                                      .collection(
                                                                                                        "Groups",
                                                                                                      )
                                                                                                      .doc(
                                                                                                        widget.groupID,
                                                                                                      )
                                                                                                      .update(
                                                                                                        {
                                                                                                          "members": updatedMembers,
                                                                                                        },
                                                                                                      );
                                                                                                }

                                                                                                // instant remove from UI
                                                                                                addMembers.removeAt(
                                                                                                  index,
                                                                                                );

                                                                                                setState(
                                                                                                  () {},
                                                                                                );

                                                                                                CWidget.toast(
                                                                                                  msg: "Member Added",

                                                                                                  backgroundColor: AppColors.primary,
                                                                                                );
                                                                                                Navigator.pop(
                                                                                                  context,
                                                                                                );
                                                                                                Navigator.pop(
                                                                                                  context,
                                                                                                );
                                                                                              },
                                                                                            );
                                                                                          },
                                                                                    ),
                                                                                  ),

                                                                                  const SizedBox(
                                                                                    height: 20,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          },
                                                                    );
                                                                  },
                                                                );
                                                              },

                                                              text:
                                                                  "add members",

                                                              width: 160,

                                                              color: AppColors
                                                                  .pinSkipBtnLight,

                                                              textColor: AppColors
                                                                  .blueTextClr,
                                                            )
                                                          : SizedBox(),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },

                          child: Container(
                            width: 345,
                            height: 58,

                            decoration: BoxDecoration(
                              color: AppColors.primary,

                              borderRadius: BorderRadius.circular(8),
                            ),

                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),

                              child: Row(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,

                                    children: [
                                      OverlappingImages(
                                        images: List<ImageProvider>.from(
                                          visibleImages.map(
                                            (e) => AssetImage(e),
                                          ),
                                        ),

                                        imageRadius: 20,
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

                                  const SizedBox(width: 16),

                                  const Text(
                                    "See all members",

                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  Image.asset(
                                    "assets/icons/arrow_grp_edit.png",

                                    width: 8,
                                    height: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        CWidget.commonELBTNG(
                          context,

                          onTap: () {
                            Navigator.pop(context);
                          },

                          text: "Back",

                          width: 345,

                          fontSize: 16,

                          gradient: AppColors.gradient,
                        ),

                        const SizedBox(height: 20),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),

                          child: SizedBox(
                            width: double.infinity,

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline_outlined,
                                      color: Colors.red,
                                    ),

                                    const SizedBox(width: 12),

                                    const Text(
                                      "Report",

                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 13),

                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/logout_icon.png",

                                      width: 20,
                                      height: 20,
                                    ),

                                    const SizedBox(width: 12),

                                    const Text(
                                      "Leave Group",

                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 35),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
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
    required String crossImage,
    required bool admin,
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
                  child: admin
                      ? Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            // border: Border.all(color: cs.secondary.withOpacity(0.5)),
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: boolValue ? Image.asset(crossImage) : null,
                        )
                      : SizedBox(),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  // Future<void> getGroupName() async {
  //
  //   final snap = await FirebaseFirestore.instance
  //       .collection("Users")
  //       .doc(globalDocID)
  //       .collection("Groups")
  //       .doc(widget.groupID)
  //       .get();
  //
  //   final data = snap.data();
  //
  //   if (data != null) {
  //
  //     groupNameController.text =
  //         data["groupName"] ?? "";
  //   }
  // }
}
