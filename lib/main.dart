import 'package:device_preview/device_preview.dart';
import  'package:e_chat/splashScreen/splashScreen.dart';
import 'package:e_chat/utilities/AppTheme.dart';
import 'package:e_chat/utilities/pref_keys.dart';
import 'package:e_chat/utilities/prefrence_file.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
ValueNotifier<ThemeMode> themeNotify = ValueNotifier(ThemeMode.system);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  await SharedPref.initialize();
  String saved = SharedPref.getString(action: PrefKeys.themeKey);

  if (saved == "light") {
    themeNotify.value = ThemeMode.light;
  } else if (saved == "dark") {
    themeNotify.value = ThemeMode.dark;
  } else {
    themeNotify.value = ThemeMode.system;
  }
  runApp(
      DevicePreview(
        enabled: true,

        builder: (context) => const MyApp(),
      ),

      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotify,
      builder: (context, themeMode, child) {
        return MaterialApp(
          home: Splashscreen(),
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: themeMode,
        );
      },
    );
  }
}
