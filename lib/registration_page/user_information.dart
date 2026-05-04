import 'dart:io';

import 'package:e_chat/home_page/homePage.dart';
import 'package:e_chat/login_page/otp_file.dart';
import 'package:e_chat/login_page/pin_secuirity.dart';
import 'package:e_chat/registration_page/registration.dart';
import 'package:e_chat/utilities/Fire_base_manager.dart';
import 'package:e_chat/utilities/pref_keys.dart';
import 'package:e_chat/utilities/prefrence_file.dart';
import 'package:flutter/material.dart';
import 'package:e_chat/utilities/text_theme.dart';
import 'package:e_chat/utilities/commonColors.dart';
import 'package:e_chat/utilities/commonWidget.dart';
import 'package:image_picker/image_picker.dart';

import '../login_page/login_page.dart';
import '../utilities/image_saver.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final _formKey = GlobalKey<FormState>();

  bool typeComplete = false;
  bool isChecked = false;
  bool blankPhoneNo = true;
  bool requested = false;

  final ImagePicker picker = ImagePicker();
  File? selectedImage;

  Future<void> pickFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final savedImage =
      await ImageSaver.saveImagePermanently(image.path);

      setState(() {
        selectedImage = savedImage;
      });
    }
  }

  Future<void> pickFromCamera() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final savedImage =
      await ImageSaver.saveImagePermanently(image.path);

      setState(() {
        selectedImage = savedImage;
      });
    }
  }

  TextEditingController nameEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: cs.surface,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            typeComplete = false;
          });
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              headerSection(context),
              SizedBox(height: 60),
              middleSection(),
              SizedBox(height: 24),
              bottomBtn(context),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerSection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: Duration(microseconds: 400),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeInCirc,
          child: Image.asset(
            typeComplete
                ? (isDark
                ? "assets/images/on_type_rectangle_dark.png"
                : "assets/images/on_type_rectangle.png")
                : (isDark
                ? "assets/images/registration+page_circle_dark.png"
                : "assets/images/registration+page_circle_light.png"),
            key: ValueKey(typeComplete),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CWidget.commonELBTN(
                      iconReq: true,
                      imagePath: "assets/images/login_arrow_light.png",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage()),
                        );
                      },
                      text: "Login",
                      width: 112,
                      color: cs.surface,
                      textColor: cs.primary,
                    ),
                    Spacer(),
                    Text(
                      "Register",
                      style:
                      Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 35,
                        color: isDark
                            ? AppColors.primary
                            : AppColors.backgroundLight,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Center(
                  child: Stack(children: [
                    ClipOval(
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            color:
                            isDark ? Colors.grey : AppColors.border),
                        child: selectedImage != null
                            ? Image.file(selectedImage!,
                            fit: BoxFit.cover)
                            : Image.asset(
                          "assets/images/user_icon_dark.png",
                          width: 77,
                          height: 102,
                        ),
                      ),
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
                                title:
                                Text("Pick a profile picture"),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        pickFromGallery();
                                      },
                                      child: Text("Gallery")),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        pickFromCamera();
                                      },
                                      child: Text("Camera"))
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
                    )
                  ]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget middleSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 42),
      child: CWidget.commonNameField(
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w400,
          color: isDark
              ? AppColors.backgroundLight
              : AppColors.onboardingBgDark,
        ),
        onTyping: (p0) {},
        typeComplete: (p0) {
          setState(() {
            typeComplete = p0;
          });
        },
        validator: (val) {
          if (val == null || val.isEmpty) {
            return "Enter your name";
          }
          return null;
        },
        context,
        controller: nameEditingController,
        iconImage: isDark
            ? "assets/images/user_icon_dark.png"
            : "assets/images/user_icon_light.png",
      ),
    );
  }

  Widget bottomBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 42),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () async {
              try {
                setState(() {
                  requested = true;
                });

                final isDark =
                    Theme.of(context).brightness == Brightness.dark;

                String defaultImage = isDark
                    ? "assets/images/user_icon_dark.png"
                    : "assets/images/user_icon_light.png";

                String finalImagePath = selectedImage != null
                    ? selectedImage!.path
                    : defaultImage;

                FireBaseManager.updateData(data: {
                  FireBaseManager.userName:
                  nameEditingController.text
                });
                FireBaseManager.updateData(data: {
                  "e-mail":
                 nameEditingController.text+"@gmail.com"
                });

                if (globalDocID.isNotEmpty) {
                  SharedPref.setString(
                    key: "globalDocID",
                    value: globalDocID,
                  );
                }

                FireBaseManager.updateData(data: {
                  FireBaseManager.userPic: finalImagePath
                });

                SharedPref.setBool(
                    key: PrefKeys.registeredUser, value: false);

                await Future.delayed(Duration(seconds: 1));

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PINSecurity()),
                );
              } catch (e) {
                print("EXP user profile:::$e");
              } finally {
                setState(() {
                  requested = false;
                });
              }
            },
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                gradient: !typeComplete
                    ? AppColors.gradient
                    : AppColors.gradient.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: requested
                    ? CircularProgressIndicator(
                  color:
                  Theme.of(context).colorScheme.surface,
                )
                    : Image.asset(
                    "assets/images/arrow_image.png",
                    width: 29),
              ),
            ),
          ),
        ],
      ),
    );
  }
}