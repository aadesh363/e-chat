import 'dart:io';
import 'package:e_chat/login_page/login_page.dart';
import 'package:e_chat/utilities/Fire_base_manager.dart';
import 'package:e_chat/utilities/commonWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utilities/commonColors.dart';
import '../utilities/pref_keys.dart';
import '../utilities/prefrence_file.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  var userData;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var data = await FireBaseManager.getData();
    setState(() {
      userData = data;
    });
  }

  Future<void> pickFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> pickFromCamera() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  void showImagePicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pick a profile picture"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                pickFromGallery();
              },
              child: const Text("Gallery"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                pickFromCamera();
              },
              child: const Text("Camera"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Stack(
              children: [
                ClipOval(
                  child: Container(
                    width: 150,
                    height: 150,
                    color: isDark ? Colors.grey : Colors.grey.shade300,
                    child: selectedImage != null
                        ? Image.file(selectedImage!, fit: BoxFit.cover)
                        : Image.asset("assets/images/user_icon_dark.png"),
                  ),
                ),

                Positioned(
                  right: 0,
                  bottom: 0,
                  child: InkWell(
                    onTap: showImagePicker,
                    child: Image.asset(
                      "assets/images/picker_icon.png",
                      width: 45,
                      height: 45,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              userData != null
                  ? userData![FireBaseManager.userName] ?? ""
                  : "Loading...",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(
              width: 345,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Phone : ",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        userData != null
                            ? userData![FireBaseManager.mobileNumber] ?? ""
                            : "Loading...",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        "Gender : ",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "Male",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        "Birthday : ",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "12/01/1997",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        "Email : ",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        userData != null
                            ? userData!["e-mail"] ?? ""
                            : "Loading...",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  CWidget.commonELBTNG(
                    context,
                    isIconReq: true,
                    iconImage: "assets/icons/Pen.png",
                    onTap: () {},
                    text: "Edit profile",
                    gradient: AppColors.gradient,
                    width: 345,
                    fontSize: 20,
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),

                  CWidget.commonELBTNG(
                    context,
                    isIconReq: true,
                    iconImage: "assets/icons/logout_icon.png",
                    onTap: () async {
                      SharedPref.setBool(key: PrefKeys.logInKey, value: false);
                      SharedPref.setBool(
                        key: PrefKeys.registeredUser,
                        value: false,
                      );

                      SharedPref.setString(key: "globalDocID", value: "");
                      globalDocID = "";
                      CWidget.showLoader(context);

                     await Future.delayed(Duration(seconds: 1));

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                            (route) => false,
                      );
                    },
                    text: "Logout",
                    bgColor: Color(0xffFEECEB),
                    width: 345,
                    fontSize: 20,
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
