import 'package:e_chat/login_page/otp_file.dart';
import 'package:e_chat/registration_page/registration.dart';
import 'package:e_chat/utilities/Fire_base_manager.dart';
import 'package:e_chat/utilities/pref_keys.dart';
import 'package:e_chat/utilities/prefrence_file.dart';
import 'package:flutter/material.dart';
import 'package:e_chat/utilities/text_theme.dart';
import 'package:e_chat/utilities/commonColors.dart';
import 'package:e_chat/utilities/commonWidget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool typeNotStart = true;
  bool requested = false;
  bool typeComplete = false;
  bool isChecked = false;
  bool blankPhoneNo = true;
  String dialCode = "+91";
  TextEditingController phoneEditingController = TextEditingController();

  /// Fix//done

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String themeNow = SharedPref.getString(action: PrefKeys.themeKey);

    return Scaffold(
      backgroundColor: cs.surface,

      /// Fix
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          padding: .zero,
          physics: ScrollPhysics(),
          children: [
            headerSection(context),
            SizedBox(height: 50),
            middleSection(context),
          ],
        ),
      ),
    );
  }

  // Widget themeBTN(){
  //   String themeNow = SharedPref.getString(action: PrefKeys.themeKey);
  //   final cs = Theme.of(context).colorScheme;
  //
  //   return  CWidget.commonELBTN(
  //
  //       onPressed: () async {
  //         CWidget.toggleTheme();
  //       },
  //       text: themeNow,
  //       width: 100,
  //       color: cs.primary,
  //       textColor: Colors.white,
  //     );
  // }

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
            typeNotStart == true
                ? (isDark
                      ? "assets/images/corner_circle_dark.png"
                      : "assets/images/corner_circle_light.png")
                : (isDark
                      ? "assets/images/on_type_rectangle_dark.png"
                      : "assets/images/on_type_rectangle.png"),
            key: ValueKey(typeNotStart),
          ),
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
                        print(typeComplete);
                        SharedPref.setBool(
                          key: PrefKeys.logInKey,
                          value: false,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Registration(),
                          ),
                        );
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
                  "Enter your \nmobile phone",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.primary
                        : AppColors.backgroundLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget middleSection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "You will get a code via sms.",
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: cs.onSurface),
              ),
              SizedBox(height: 30),
              CWidget.commonTextField(
              dialogBackgroundColor:   isDark? AppColors.backgroundDark:AppColors.backgroundLight,
                context,
                dialCode: dialCode,
                onCountryChanged: (code) {
                  setState(() {
                    dialCode = code;
                  });
                },
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Enter your mobile number";
                  }

                  return null;
                },
                onTyping: (valueFromKeyboard) {
                  if (phoneEditingController.text.isEmpty) {
                    setState(() {
                      blankPhoneNo = false;
                    });
                    return;
                  }
                  setState(() {
                    typeNotStart = valueFromKeyboard;
                  });
                },
                typeComplete: (typeCompleted) {
                  setState(() {
                    typeComplete = _formKey.currentState?.validate() ?? false;
                  });
                },
                controller: phoneEditingController,
              ),

              SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(

                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

                  children: [

                    Expanded(
                      child: Row(
                      
                        children: [
                      
                          InkWell(
                      
                            onTap: () {
                      
                              setState(() {
                      
                                isChecked = !isChecked;
                      
                                SharedPref.setString(
                      
                                  key: PrefKeys.userPhone,
                      
                                  value:
                                  phoneEditingController.text,
                                );
                              });
                            },
                      
                            child: Container(
                      
                              height:
                              MediaQuery.of(context)
                                  .size
                                  .width *
                                  0.06,
                      
                              width:
                              MediaQuery.of(context)
                                  .size
                                  .width *
                                  0.06,
                      
                              decoration: BoxDecoration(
                      
                                border: Border.all(
                      
                                  color: cs.secondary
                                      .withOpacity(0.5),
                                ),
                      
                                borderRadius:
                                BorderRadius.all(
                                  Radius.circular(6),
                                ),
                              ),
                      
                              child: isChecked
                      
                                  ? Image.asset(
                                "assets/images/tick_checkbox.png",
                              )
                      
                                  : null,
                            ),
                          ),
                      
                          SizedBox(
                      
                            width:
                            MediaQuery.of(context)
                                .size
                                .width *
                                0.03,
                          ),
                      
                          Flexible(
                      
                            child: Text(
                      
                              "Remember me",
                      
                              overflow:
                              TextOverflow.ellipsis,
                      
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                      
                                fontWeight:
                                FontWeight.w700,
                      
                                color:
                                cs.onSurface,
                      
                                fontSize:
                                MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.04,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(

                      width:
                      MediaQuery.of(context)
                          .size
                          .width *
                          0.03,
                    ),

                    InkWell(

                      borderRadius:
                      BorderRadius.circular(30),

                      onTap: () async {

                        try {

                          setState(() {

                            requested = true;
                          });

                          if (_formKey.currentState!
                              .validate() &&
                              !(await FireBaseManager.searchData(

                                target:
                                dialCode +
                                    " " +
                                    phoneEditingController
                                        .text,

                                key:
                                FireBaseManager
                                    .mobileNumber,
                              ))) {

                            if (globalDocID
                                .isNotEmpty) {

                              SharedPref.setString(

                                key: "globalDocID",

                                value: globalDocID,
                              );
                            }

                            Future.delayed(
                              Duration(seconds: 2),
                            );

                            Navigator.push(

                              context,

                              MaterialPageRoute(

                                builder: (context) =>
                                    OtpFile(),
                              ),
                            );

                          } else {

                            CWidget.toast(

                              msg:
                              "Number not registered yet",
                            );
                          }

                        } catch (e) {

                          print(
                            "Exp in Login page:::::$e",
                          );

                        } finally {

                          setState(() {

                            requested = false;
                          });
                        }
                      },

                      child: Container(

                        width:
                        MediaQuery.of(context)
                            .size
                            .width *
                            0.13,

                        height:
                        MediaQuery.of(context)
                            .size
                            .width *
                            0.13,

                        decoration: BoxDecoration(

                          gradient: typeComplete

                              ? AppColors.gradient

                              : AppColors.gradient
                              .withOpacity(.5),

                          shape: BoxShape.circle,
                        ),

                        child: Center(

                          child: requested

                              ? CircularProgressIndicator()

                              : Image.asset(

                            "assets/images/arrow_image.png",

                            width:
                            MediaQuery.of(context)
                                .size
                                .width *
                                0.07,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )            ],
          ),
        ),
      ),
    );
  }
}
