import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_chat/Group_chat_page/group_chat_page.dart';
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
        stream: FirebaseFirestore.instance.collection("Users").doc(globalDocID)
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
                  onTap: ()  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  GroupChatPage(groupID: data["groupId"],),));
                     FirebaseFirestore.instance.collection("Users").doc(globalDocID).collection("Groups").doc( data["groupId"]).update(
                        {"pendingCount":0});

                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading:Row(
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
                    title: Text(data["groupName"],style:Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.backgroundLight
                          : AppColors.backgroundDark,
                      fontSize: 16,)),
                    subtitle: Text(data["lastMessage"],maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondaryDark,
                        fontSize: 14,)),

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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
