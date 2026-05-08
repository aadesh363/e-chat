import 'package:cloud_firestore/cloud_firestore.dart';
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
            .collection("Groups")
            .where(Filter.or(Filter("members", arrayContains: globalDocID), Filter("adminId", isEqualTo: globalDocID)))
        
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
              return Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading:OverlappingImages(
                    images: List<ImageProvider>.from(
                      (data["groupPic"] as List).map(
                            (e) => AssetImage(e),
                      ),
                    ),
                    imageRadius: 24.0,
                  ) ,
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
              );
            },
          );
        },
      ),
    );
  }
}
