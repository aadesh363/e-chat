import 'dart:io';
import 'package:e_chat/login_page/login_page.dart';
import 'package:e_chat/utilities/Fire_base_manager.dart';
import 'package:e_chat/utilities/commonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();

  TextEditingController phoneEditingController = TextEditingController();
  String? selectedValue;
  DateTime? selectedDate;
  bool requested = false;


  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
        initialDate: selectedDate ?? DateTime.now()    ,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    setState(() {
      selectedDate = pickedDate;
    });
  }

  File? selectedImage;
  final ImagePicker picker = ImagePicker();
  String dialCode = "+91";

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

      nameEditingController.text = userData?[FireBaseManager.userName] ?? "";
      emailEditingController.text = userData?[FireBaseManager.email] ?? "";

      phoneEditingController.text = userData?["number"] ?? "";
      dialCode = userData?[FireBaseManager.dialCOde] ?? "+91";
      selectedDate =
          userData?["birthDate"]?.toDate();
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

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: SingleChildScrollView(
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
                          Spacer(),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(const ClipboardData(text: "Your text to copy"));

                            CWidget.toast(msg: "Phone Number copied",backgroundColor: AppColors.primary);
                            },
                          )
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
                          Spacer(),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(const ClipboardData(text: "Your text to copy"));

                              CWidget.toast(msg: "Gender copied",backgroundColor: AppColors.primary);
                            },
                          )
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
                              "${selectedDate?.day.toString().padLeft(2, '0')}/"
                                  "${selectedDate?.month.toString().padLeft(2, '0')}/"
                                  "${selectedDate?.year}",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Spacer(),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(const ClipboardData(text: "Your text to copy"));

                              CWidget.toast(msg: "Birthdate copied",backgroundColor: AppColors.primary);
                            },
                          )
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
                          Spacer(),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(const ClipboardData(text: "Your text to copy"));

                              CWidget.toast(msg: "Email copied",backgroundColor: AppColors.primary);
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 16),

                      CWidget.commonELBTNG(
                        context,
                        isIconReq: true,
                        iconImage: "assets/icons/Pen.png",
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return Padding(

                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).viewInsets.bottom,),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
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
                                      SizedBox(height: 8),
                                      Text(
                                        "Edit Profile",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                      SizedBox(height: 16),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Name",
                                              style: TextStyle(
                                                color: isDark
                                                    ? Color(0xffD0D1DB)
                                                    : Color(0xff686A8A),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              height: 56,
                                              child: TextFormField(
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.titleMedium,
                                                showCursor: false,
                                                controller:
                                                    nameEditingController,
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                decoration: InputDecoration(
                                                  hintText: "Enter your name",
                                                  hintStyle: Theme.of(
                                                    context,
                                                  ).textTheme.titleMedium,
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 0,
                                                        horizontal: 12,
                                                      ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Phone Number",
                                              style: TextStyle(
                                                color: isDark
                                                    ? Color(0xffD0D1DB)
                                                    : Color(0xff686A8A),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),

                                            CWidget.commonTextField(
                                              isBorder: true,
                                              context,
                                              controller:
                                                  phoneEditingController,
                                              onCountryChanged: (p0) {
                                                setState(() {
                                                  dialCode=p0;
                                                });
                                              },
                                              dialCode: dialCode,
                                              dialogBackgroundColor: isDark
                                                  ? AppColors.backgroundDark
                                                  : AppColors.backgroundLight,
                                            ),
                                            Text(
                                              "Gender",
                                              style: TextStyle(
                                                color: isDark
                                                    ? Color(0xffD0D1DB)
                                                    : Color(0xff686A8A),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            DropdownButtonFormField<String>(
                                              icon: Image.asset(
                                                "assets/icons/arrow_down.png",
                                                width: 6,
                                                height: 6,
                                              ),
                                              iconSize: 20,
                                              isExpanded: true,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        5,
                                                      ),
                                                ),
                                              ),
                                              value: "Male",
                                              // 2. Current selected value
                                              items: [
                                                DropdownMenuItem(
                                                  value: 'Male',
                                                  // The actual value returned
                                                  child: Text(
                                                    'Male',
                                                  ), // What the user sees
                                                ),
                                                DropdownMenuItem(
                                                  value: 'Female',
                                                  child: Text('Female'),
                                                ),
                                              ],
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedValue =
                                                      newValue; // 3. Update the state
                                                });
                                              },
                                            ),

                                            // Text(
                                            //   selectedDate != null
                                            //       ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                            //       : 'No date selected',
                                            // ),
                                            Text(
                                              "Birthday",
                                              style: TextStyle(
                                                color: isDark
                                                    ? Color(0xffD0D1DB)
                                                    : Color(0xff686A8A),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _selectDate();
                                                print(userData);
                                                print(userData?["birthDate"]);
                                              },
                                              child: Container(
                                                height: 65,

                                                decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.black26)

                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                  "${selectedDate?.day.toString().padLeft(2, '0')}/"
                                                "${selectedDate?.month.toString().padLeft(2, '0')}/"
                                              "${selectedDate?.year}",
                                                        style: Theme.of(
                                                          context,
                                                        ).textTheme.titleMedium,
                                                      ),
                                                      Spacer(),
                                                      Icon(Icons.calendar_today)

                                                    ],

                                                  ),

                                                ),

                                              ),
                                            ),
                                            Text(
                                              "Email",
                                              style: TextStyle(
                                                color: isDark
                                                    ? Color(0xffD0D1DB)
                                                    : Color(0xff686A8A),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              height: 56,
                                              child: TextFormField(
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.titleMedium,
                                                showCursor: false,
                                                controller:
                                                emailEditingController,
                                                textAlignVertical:
                                                TextAlignVertical.center,
                                                decoration: InputDecoration(
                                                  hintText: "Enter your email",
                                                  hintStyle: Theme.of(
                                                    context,
                                                  ).textTheme.titleMedium,
                                                  contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 12,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                      8,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                            ),
                                            SizedBox(height: 20,),
                                            bottonBtn(),
                                            SizedBox(height: 50,)

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
                          SharedPref.setBool(
                            key: PrefKeys.logInKey,
                            value: false,
                          );
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
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
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
        ),
      ),
    );
  }




  Widget bottonBtn() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

            ? CWidget.commonELBTN(
          onPressed: () {
            print("lll");
            Navigator.pop(context);

          },
          text: "cancel`",
          width: 160,
          color: AppColors.pinSkipBtnLight,
          textColor: AppColors.blueTextClr,
        )

       , Spacer(),
        CWidget.commonELBTNG(


          context,
          boxShadow: [],
          onTap: () async {
            FireBaseManager.updateData(data: {
              FireBaseManager.userName:nameEditingController.text,
              FireBaseManager.mobileNumber:dialCode+" "+phoneEditingController.text,
              FireBaseManager.gender:selectedValue,
              FireBaseManager.birthDate:selectedDate,
              FireBaseManager.email:emailEditingController.text,
              FireBaseManager.dialCOde:dialCode,
              "number":phoneEditingController.text
            });


            Navigator.pop(context);
            CWidget.showLoader2(context);





          }
         ,
          text: "Save",
          width: 160,
          fontSize: 18,
          gradient:
               AppColors.gradient,

          color: AppColors.backgroundLight,
          height: 60,
        ),
      ],
    );
  }





}
