import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_chat/home_page/homePage.dart';
import 'package:e_chat/utilities/Fire_base_manager.dart';
import 'package:e_chat/utilities/commonColors.dart';
import 'package:e_chat/utilities/commonWidget.dart';
import 'package:e_chat/utilities/pref_keys.dart';
import 'package:e_chat/utilities/prefrence_file.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pin_code/pin_code.dart';

class PINSecurity extends StatefulWidget {
  const PINSecurity({super.key});

  @override
  State<PINSecurity> createState() => _PINSecurityState();
}

class _PINSecurityState extends State<PINSecurity> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController pinEditingController = TextEditingController();
  bool isFirstTime = SharedPref.getBool(key: PrefKeys.registeredUser)
      ? true
      : false;
  bool typeComplete = false;
  var confirmPin = false;
  var heading = "PIN Security";
  bool requested = false;
  String a = "";
  String userPhone = SharedPref.getString(action: PrefKeys.userPhone);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [SizedBox(height: 20), headerSection()],
                ),
              ),
              SizedBox(height: 70),
              (!isFirstTime && requested)
                  ? SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(color: Colors.grey),
                    )
                  : SizedBox(),
              Spacer(),
              !isFirstTime ? bottonBtn() : SizedBox(),

              ////Need to add hear
            ],
          ),
        ),
      ),
    );
  }

  Widget themeBTN() {
    String themeNow = SharedPref.getString(action: PrefKeys.themeKey);
    final cs = Theme.of(context).colorScheme;

    return CWidget.commonELBTN(
      onPressed: () async {
        CWidget.toggleTheme();
      },
      text: themeNow,
      width: 100,
      color: cs.primary,
      textColor: Colors.white,
    );
  }

  Widget headerSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            heading,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          ),
          SizedBox(height: 32),
          Text(
            "Protect your account with a secure PIN",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 32),
          CWidget.commonPinCodeField(
            context,
            onCompleted: (val) async {
              setState(() {
                typeComplete = true;
              });
              try {
                print("is first time $isFirstTime");
                if (isFirstTime) {
                  setState(() {
                    requested = true;
                  });
                  var b = await FireBaseManager.getData();
                  print("is first time ${globalDocID} ");
                  print("is first time ${b.data()} ");
                  if (b[FireBaseManager.userPin] == pinEditingController.text) {
                    SharedPref.setBool(key: PrefKeys.logInKey, value: true);
                    CWidget.showLoader(context);
                    await Future.delayed(Duration(seconds: 2));

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                    );
                  } else {
                    CWidget.toast(msg: "Wrong pin");
                  }
                }
              } catch (e) {
                print("EXP in loginOTP ::::$e");
              } finally {
                setState(() {
                  requested = false;
                });
              }
            },
            onChanged: (p0) {
              setState(() {
                typeComplete = false;
              });
            },

            validator: (val) {
              if (val == null || val.isEmpty) {
                return "enter Pin";
              }

              if (val.length != 4) {
                return "Enter 4 digit Pin";
              }

              return null;
            },
            controller: pinEditingController,
            pinTheme:
                PinCodeTheme(
                  shape: PinCodeFieldShape.underline,
                  fieldHeight: 60,
                  fieldWidth: 40,
                ).copyWith(
                  inactiveColor: isDark
                      ? AppColors.backgroundLight
                      : AppColors.textPrimaryLight,
                  activeColor: isDark
                      ? AppColors.backgroundLight
                      : AppColors.textPrimaryLight,
                  selectedColor: AppColors.primary,
                  activeBorderWidth: 4,
                  inactiveBorderWidth: 4,
                  selectedBorderWidth: 4,
                ),
          ),
        ],
      ),
    );
  }

  Widget bottonBtn() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        !isFirstTime
            ? CWidget.commonELBTN(
                onPressed: () {
                  print("lll");
                },
                text: "Skip`",
                width: 160,
                color: AppColors.pinSkipBtnLight,
                textColor: AppColors.blueTextClr,
              )
            : SizedBox(),
        !isFirstTime ? SizedBox(width: 24) : SizedBox(),
        CWidget.commonELBTNG(

          requested: requested,
          isFirstTime: isFirstTime,
          context,
          boxShadow: [],
          onTap: () async {
            // ;
            try {
              // SharedPref.setString(
              //   key: PrefKeys.userPin,
              //   value: pinEditingController.text,
              // );

              if (!confirmPin) {
                a = pinEditingController.text;

                setState(() {
                  heading = "Confirm Pin";
                  confirmPin = true;
                });
                pinEditingController.clear();
                print(confirmPin);
              } else {
                print(a);
                if (pinEditingController.text == a) {
                  setState(() {
                    requested = false;
                  });
                  FireBaseManager.updateData(
                    data: {FireBaseManager.userPin: pinEditingController.text},
                  );
                  await Future.delayed(Duration(seconds: 2));
                  // CWidget.showLoader(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage()),
                  );
                  SharedPref.setBool(key: PrefKeys.logInKey, value: true);
                  SharedPref.setBool(key: PrefKeys.registeredUser, value: true);
                } else {
                  CWidget.toast(msg: "Wrong Pin entered");
                }
              }
            } catch (e) {
              print("exp in Pin page::::$e");
            } finally {
              setState(() {
                requested = false;
              });
            }
          },
          text: "Continue",
          width: 160,
          fontSize: 18,
          gradient: typeComplete
              ? AppColors.gradient
              : AppColors.gradient.withOpacity(.5),
          color: AppColors.backgroundLight,
          height: 60,
        ),
      ],
    );
  }
}
