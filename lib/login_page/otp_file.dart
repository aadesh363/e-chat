import 'dart:async';

import 'package:e_chat/home_page/homePage.dart';
import 'package:e_chat/login_page/login_page.dart';
import 'package:e_chat/login_page/pin_secuirity.dart';
import 'package:e_chat/registration_page/registration.dart';
import 'package:e_chat/registration_page/user_information.dart';
import 'package:e_chat/utilities/pref_keys.dart';
import 'package:e_chat/utilities/prefrence_file.dart';
import 'package:flutter/material.dart';

import '../utilities/Fire_base_manager.dart';
import '../utilities/commonColors.dart';
import '../utilities/commonWidget.dart';
import 'package:timer_widget/timer_widget.dart';
import 'dart:math';

class OtpFile extends StatefulWidget {
  const OtpFile({super.key});

  @override
  State<OtpFile> createState() => _OtpFileState();
}

class _OtpFileState extends State<OtpFile> {
  int timeLeft = 30;
  bool requested = false;
  bool typingComplete = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController otpEditingController = TextEditingController();

  void startTimer() {

    setState(() {
      timeLeft = 30;
    });
    Timer.periodic(Duration(seconds: 1), (timer) {

      if(timeLeft > 0){
        setState(() {
          timeLeft--;
        });
      }else{
        setState(() {
          timeLeft = 0;

        });
        timer.cancel();
      }

    });

  }
  late int otp;

  int generateFourDigit() {

    otp = 1000 + Random().nextInt(9000);

    FireBaseManager.updateData(
      data: {
        FireBaseManager.otp: otp.toString(),
      },
    );

    return otp;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    generateFourDigit();

    startTimer();

    CWidget.toast(
      msg: otp.toString(),
    );
    print(otp);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              headerSection(context),
              SizedBox(height: 51),

              middleSection(),
              SizedBox(height: 24),
              Row(children: [SizedBox(width: 270), bottomBtn(context)]),
            ],
          ),
        ),
      ),
    );
  }

  //////

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

  ////Header///////////
  Widget headerSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Image.asset(
          isDark
              ? "assets/images/on_type_rectangle_dark.png"
              : "assets/images/on_type_rectangle.png",
        ),

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Login",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 35,
                        color: isDark
                            ? AppColors.primary
                            : AppColors.backgroundLight,
                      ),
                    ),
                    SizedBox(width: 122),
                    CWidget.commonELBTN(
                      onPressed: () {
                        // print(typeNotStart);
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return Registration();
                        },));
                      },
                      text: "Register",
                      width: 112,
                      color: cs.surface,
                      textColor: cs.primary,

                      /// Fix ///done
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  "Enter OTP code  ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.primary
                        : AppColors.backgroundLight,
                  ),
                ),
                Text(
                  "Sent to : (${SharedPref.getString(action: PrefKeys.countryCode)}) ${SharedPref.getString(action: PrefKeys.userPhone)}",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isDark
                        ? AppColors.primary
                        : AppColors.backgroundLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget middleSection() {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Image.asset(
                "assets/images/timer_image.png",
                width: 17,
                height: 17,
              ),
              SizedBox(width: 5),
              Text(
                "00 : ${timeLeft < 10 ? "0$timeLeft" : timeLeft}",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(width: 12),
              InkWell(
                onTap: timeLeft == 0
                    ? () {

                  startTimer();

                  generateFourDigit();

                  CWidget.toast(
                    msg: otp.toString(),
                  );

                }
                    : null,
                child: Text(
                  "Resend Code",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    decorationColor: timeLeft == 0
                        ? (isDark
                              ? AppColors.backgroundLight
                              : AppColors.onboardingNextBtnText)
                        : (isDark
                              ? AppColors.backgroundLight.withOpacity(0.4)
                              : AppColors.onboardingNextBtnText.withOpacity(
                                  0.4,
                                )),
                    decoration: TextDecoration.underline,
                    color: timeLeft == 0
                        ? (isDark
                              ? AppColors.backgroundLight
                              : AppColors.onboardingNextBtnText)
                        : (isDark
                              ? AppColors.backgroundLight.withOpacity(0.4)
                              : AppColors.onboardingNextBtnText.withOpacity(
                                  0.4,
                                )),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          CWidget.commonPinCodeField(
            context,
            validator: (val) {
              if (val == null || val.isEmpty) {
                return "enter OTP";
              }
              // if(SharedPref.getBool(key: PrefKeys.logInKey)){
              //   return "Not registered yet";
              // }
              if (val.length != 4) {
                return "Enter 4 digit OTP";
              }

              return null;
            },

            onCompleted: (value) {
              setState(() {
                typingComplete = _formKey.currentState?.validate() ?? false;
              });
            },
            onChanged: (val) {
              setState(() {
                typingComplete = val == otp.toString();
              });
            },

            controller: otpEditingController,
          ),
        ],
      ),
    );
  }

  Widget bottomBtn(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),

      onTap: () async {

        try{
          setState(() {
            requested =true;
          });
          var data = await FireBaseManager.getData();

          if (_formKey.currentState!.validate()) {
            SharedPref.setBool(key: PrefKeys.registeredUser, value: true);

            if(data[FireBaseManager.otp]==otpEditingController.text){
              await Future.delayed(Duration(seconds: 2));
              SharedPref.setBool(key: PrefKeys.registeredUser, value: true);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PINSecurity()),
              );
            }
            else{
              CWidget.toast(msg: "Incorrect otp");
            }
          }
        }
        catch(e){
          print("Exception in registration OTP ::::$e");
        }finally{
         setState(() {
           requested = false;
         });
        }
      }
      ,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          gradient: typingComplete
              ? AppColors.gradient
              : AppColors.gradient.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: requested?CircularProgressIndicator():Image.asset("assets/images/arrow_image.png", width: 29),
        ),
      ),
    );
  }
}
