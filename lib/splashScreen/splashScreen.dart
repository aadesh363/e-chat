import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../login_page/login_page.dart';
import '../login_page/pin_secuirity.dart';
import '../utilities/Fire_base_manager.dart';
import '../utilities/commonWidget.dart';
import '../utilities/pref_keys.dart';
import '../utilities/prefrence_file.dart';
import 'onboarding_page.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () async {
      bool isLoggedIn =
          SharedPref.getBool(key: PrefKeys.logInKey) ?? false;

      String docId =
          SharedPref.prefs.getString("globalDocID") ?? "";

      if (isLoggedIn && docId.isNotEmpty) {
        try {
          var doc = await FirebaseFirestore.instance
              .collection("Users")
              .doc(docId)
              .get();

          if (doc.exists) {
            globalDocID = docId;

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PINSecurity()),
            );
          } else {
            SharedPref.setBool(key: PrefKeys.logInKey, value: false);
            SharedPref.setString(key: "globalDocID", value: "");

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OnboardingPage()),
            );
          }
        } catch (e) {
          SharedPref.setBool(key: PrefKeys.logInKey, value: false);
          SharedPref.setString(key: "globalDocID", value: "");

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OnboardingPage()),
          );
        }
      } else if (isLoggedIn && docId.isEmpty) {
        SharedPref.setBool(key: PrefKeys.logInKey, value: false);
        SharedPref.setString(key: "globalDocID", value: "");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String themeNow = SharedPref.getString(action: "theme");
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
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
    );
  }
}