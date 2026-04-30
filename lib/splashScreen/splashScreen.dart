import 'package:e_chat/home_page/homePage.dart';
import 'package:e_chat/main.dart';
import 'package:e_chat/login_page/pin_secuirity.dart';
import 'package:e_chat/splashScreen/onboarding_page.dart';
import 'package:e_chat/utilities/commonColors.dart';
import 'package:e_chat/utilities/pref_keys.dart';
import 'package:e_chat/utilities/prefrence_file.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login_page/login_page.dart';
import '../utilities/commonWidget.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
// SharedPref.setBool(key: PrefKeys.logInKey, value: false);
//     SharedPref.setBool(key: PrefKeys.registeredUser, value: false);

    Future.delayed(Duration(seconds: 3)).then((value) async {
      if (SharedPref.getBool(key: PrefKeys.logInKey)) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PINSecurity()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OnboardingPage()),
        );
      }
      //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(),));
    });
  }

  Widget build(BuildContext context) {
    //  bool isLight = SharedPref.getBool(key: "isLight");
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String themeNow = SharedPref.getString(action: "theme");
    final cs = Theme.of(context).colorScheme;

    return  Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),

              Image.asset(
                !isDark
                    ? "assets/images/main_e_chat_logo.png"
                    : "assets/images/main_e_chat_dark.png",
                width: 235.21,
                height: 80,
              ),

              const Spacer(),

              Image.asset(
                !isDark
                    ? "assets/images/combine_logo_with_text.png"
                    : "assets/images/combine_logo_with_text_dark.png",
                width: 268.75,
                height: 268.75,
              ),

              const Spacer(),

              CWidget.commonELBTN(
                onPressed: () async {
                  CWidget.toggleTheme();
                },
                text: themeNow,
                width: 100,
                color: cs.primary,
                textColor: Colors.white,
              ),

              const SizedBox(height: 20),

              Text(
                "Version 2.1.0",
                style: TextStyle(
                  color: cs.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );;
  }
}
