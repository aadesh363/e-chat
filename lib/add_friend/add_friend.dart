import 'package:cloud_firestore/cloud_firestore.dart';
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

  TextEditingController phoneEditingController = TextEditingController();

  Future<void> searchData() async {
    var result = await FireBaseManager.collection
        .orderBy(FireBaseManager.mobileNumber)
        .startAt([searchController.text])
        .endAt([searchController.text + '\uf8ff'])
        .get();

    user.clear();
    user.addAll(result.docs);
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
                        Image.asset(
                          "assets/images/add_frnd_btn.png",
                          width: 42,
                          height: 42,
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
                   var a = await FireBaseManager.searchUsersByNumber(controller: phoneEditingController);
                    user.clear();
                    user.addAll(a);
                    setState(() {});
                 },

                  isBorder: true,
                  context,


                  controller: phoneEditingController,
                  onCountryChanged: (p0) {},
                  dialCode: "+91",
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
                return Text(user[index][FireBaseManager.userName]);
              },),
            ),
          ],
        ),
      ),
    );
  }
}
