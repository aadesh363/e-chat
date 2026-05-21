import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_chat/Group_chat_page/group_chat_page.dart';
import 'package:e_chat/utilities/commonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_overlap/flutter_image_overlap.dart';

import '../utilities/Fire_base_manager.dart';
import '../utilities/commonColors.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(globalDocID)
            .collection("Groups")
            .where("members", arrayContains: globalDocID)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No messages yet"));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,

            itemBuilder: (context, index) {
              final data = docs[index].data();
              final ts = data['createdAt'];
              String formattedTime = "";

              if (ts != null && ts is Timestamp) {
                final time = ts.toDate();
                formattedTime =
                    "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
              }

              final count =
                  int.tryParse((data['pendingCount'] ?? 0).toString()) ?? 0;
              final pics = List<String>.from(data["groupPic"]);

              final visibleImages = pics.take(2).toList();

              final remainingCount = pics.length - visibleImages.length;

              return Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                child: InkWell(
                  onTap: () {
                    final isProtected = data["protected"] ?? false;
                    final parentContext = context;

                    if (isProtected) {

                      showDialog(
                        context: context,
                        builder: (context) {
                          final passwordController = TextEditingController();


                          return AlertDialog(
                            title: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Enter your group password",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isDark
                                          ? AppColors.textPrimaryDark
                                          : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  CWidget.commonPinCodeField(
                                    context,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "enter Pin";
                                      }

                                      if (val.length != 4) {
                                        return "Enter 4 digit Pin";
                                      }

                                      return null;
                                    },
                                    controller: passwordController,
                                  ),

                                  SizedBox(height: 10),
                                  bottomBtn(
                                    context: context,
                                    controller: passwordController,
                                    groupID: data["groupId"],
                                      onSave: () async {

                                        if(passwordController.text ==
                                            data["passWord"]) {

                                          Navigator.pop(context);

                                          await Future.delayed(
                                            const Duration(milliseconds: 200),
                                          );

                                          if(parentContext.mounted){

                                            Navigator.push(
                                              parentContext,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    GroupChatPage(
                                                      groupID: data["groupId"],
                                                    ),
                                              ),
                                            );
                                          }

                                        } else {

                                          CWidget.toast(
                                            msg: "Wrong Password",
                                          );
                                        }
                                      },                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );

                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GroupChatPage(groupID: data["groupId"]),
                      ),
                    );
                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(globalDocID)
                        .collection("Groups")
                        .doc(data["groupId"])
                        .update({"pendingCount": 0});
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        OverlappingImages(
                          images: List<ImageProvider>.from(
                            visibleImages.map((e) => AssetImage(e)),
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
                    title: Text(
                      data["groupName"],
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.backgroundLight
                            : AppColors.backgroundDark,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      data["lastMessage"],
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
                              horizontal: 6,
                              vertical: 2,
                            ),
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
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget bottomBtn({
    required BuildContext context,
    required TextEditingController controller,
    required VoidCallback onSave,
    required String groupID,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        CWidget.commonELBTN(
          onPressed: () async {

            var b = await FireBaseManager.getData();

            showDialog(
              context: context,

              builder: (context) {

                final passwordController =
                TextEditingController();
                return AlertDialog(

                  title: SingleChildScrollView(

                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [

                        const Text(
                          "Enter your App password",
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),

                        CWidget.commonPinCodeField(

                          context,

                          validator: (val) {

                            if (val == null || val.isEmpty) {
                              return "enter Pin";
                            }

                            if (val.length != 4) {
                              return "Enter 4 digit Pin";
                            }

                            return null;
                          },

                          controller: passwordController,

                          onCompleted: (p0) async {

                            if (b[FireBaseManager.userPin] ==
                                passwordController.text) {

                              CWidget.showLoader(context);

                              await Future.delayed(
                                const Duration(seconds: 1),
                              );
                              if(context.mounted){
                                Navigator.pop(context); // close loader
                              }
                              showDialog(
                                context: context,

                                builder: (context) {

                                  final newPasswordController =
                                  TextEditingController();


                                  return AlertDialog(

                                    title: SingleChildScrollView(

                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,

                                        children: [

                                          const Text(
                                            "Enter your new group password",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 18,),
                                          ),

                                          const SizedBox(height: 12),

                                          CWidget.commonPinCodeField(

                                            context,

                                            validator: (val) {

                                              if (val == null ||
                                                  val.isEmpty) {
                                                return "enter Pin";
                                              }

                                              if (val.length != 4) {
                                                return "Enter 4 digit Pin";
                                              }

                                              return null;
                                            },

                                            controller:
                                            newPasswordController,
                                            onCompleted: (p0) {
                                              FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .doc(globalDocID)
                                                  .collection("Groups")
                                                  .doc(groupID)
                                                  .update({
                                                "passWord":
                                                newPasswordController
                                                    .text
                                                    .toString(),
                                              });

                                              if(context.mounted){
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              }

                                              CWidget.toast(
                                                msg: "Password Updated",
                                                backgroundColor: Colors.green,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );

                            } else {

                              CWidget.toast(
                                msg: "Wrong pin",
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },

          text: "Forgot?",

          width: 100,

          color: AppColors.pinSkipBtnLight,

          textColor: AppColors.blueTextClr,
        ),
        const SizedBox(width: 24),

        CWidget.commonELBTNG(
          context,

          onTap: () {
            if (controller.text.length != 4) {
              CWidget.toast(msg: "Enter 4 digit pin");

              return;
            }

            onSave();
          },

          text: "Continue",

          width: 100,

          fontSize: 18,

          gradient: AppColors.gradient,

          color: AppColors.backgroundLight,

          height: 60,
        ),
      ],
    );
  }
}
