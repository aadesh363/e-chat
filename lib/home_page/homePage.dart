import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_chat/home_page/ChatsHomePage.dart';
import 'package:e_chat/utilities/Fire_base_manager.dart';
import 'package:e_chat/utilities/commonColors.dart';
import 'package:e_chat/utilities/pref_keys.dart';
import 'package:e_chat/utilities/prefrence_file.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
var a;
File? img;
@override
  void initState() {
  super.initState();
    SharedPref.setBool(key: PrefKeys.registeredUser, value: true);
    getData();

  }
Future<void> getData() async {
  var data = await FireBaseManager.getData();

  setState(() {
    a = data;
  });
}
  @override

  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: ListView(children: [SafeArea(child: Center(child: headerSection())),]
    ));
  }


  Widget headerSection()  {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        SizedBox(),
        Text(
          "welcome",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: isDark ? AppColors.primary : AppColors.secondary,
          ),
        ),

        ClipOval(
          child: SizedBox(
            height: 200,
            width: 200,
            child: buildImage(),
          ),
        ),
        ElevatedButton(
          onPressed: () {
          FireBaseManager.addCollection(data: {"User":"Aadesh"});
            // SharedPref.setBool(key: PrefKeys.logInKey, value: false);
          },
          child: Text("add"),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            FireBaseManager.updateData(data: {"No":"8382349827"});
            // SharedPref.setBool(key: PrefKeys.logInKey, value: false);
          },
          child: Text("update"),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            DocumentSnapshot<Map<String, dynamic>> data =
                await FireBaseManager.getData();
            // SharedPref.setBool(key: PrefKeys.logInKey, value: false);

            print(data["Surname"]);
          },
          child: Text("Read"),
        ),

        SizedBox(height: 20),
        ElevatedButton(
          onPressed: ()  {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatsHomePage(),));
            // SharedPref.setBool(key: PrefKeys.logInKey, value: false);


          },
          child: Text("Homechat"),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: ()  {
              FireBaseManager.deleteFieldData(key: "Surname");
            // SharedPref.setBool(key: PrefKeys.logInKey, value: false);

            // print(data["User"]);
          },
          child: Text("Delete"),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: ()  {

            SharedPref.setBool(key: PrefKeys.logInKey, value: false);
            SharedPref.setBool(key: PrefKeys.registeredUser, value: false);


            // print(data["User"]);
          },
          child: Text("logot"),
        ),
        SizedBox(height: 20),



        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<String>>[

            const PopupMenuItem<String>(
            value: "LLL",
            child: Text('Item 1'),
            ),





              const PopupMenuItem<String>(
                value: "LLL",
                child: Text('Item 12'),
              ),



            ];
          },
          child: Text("popup"),
        ),



        SizedBox(height: 20),




        ElevatedButton(
          onPressed: ()  async {

            _showMyDialog(context);
await Future.delayed(Duration(seconds: 2));
Navigator.of(context).pop();

            // print(data["User"]);
          },
          child: Text("ahjahsj"),
        ),
      ],
    );
  }
  void _showMyDialog(BuildContext context) {

    showDialog(barrierDismissible: false,

      context: context,
      builder: (BuildContext context) {
        return AlertDialog(backgroundColor: Colors.transparent,

          scrollable: false,

          content: Center(child: CircularProgressIndicator())

        );
      },
    );
  }
Widget buildImage() {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  String defaultImage = isDark
      ? "assets/images/user_icon_dark.png"
      : "assets/images/user_icon_light.png";

  if (a == null || a[FireBaseManager.userPic] == null) {
    return Image.asset(defaultImage, fit: BoxFit.cover);
  }

  String path = a[FireBaseManager.userPic];

  if (path.startsWith("assets/")) {
    return Image.asset(path, fit: BoxFit.cover);
  } else {
    return Image.file(File(path), fit: BoxFit.cover);
  }
}




}
