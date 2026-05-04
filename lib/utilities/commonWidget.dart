import 'dart:io';
import 'package:e_chat/utilities/prefrence_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import 'commonColors.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:pin_code/pin_code.dart';

class CWidget {
  static void toggleTheme() async {
    if (themeNotify.value == ThemeMode.light) {
      themeNotify.value = ThemeMode.dark;
      await SharedPref.setString(key: "theme", value: "dark");
    } else if (themeNotify.value == ThemeMode.dark) {
      themeNotify.value = ThemeMode.system;
      await SharedPref.setString(key: "theme", value: "system");
    } else {
      themeNotify.value = ThemeMode.light;
      await SharedPref.setString(key: "theme", value: "light");
    }
  }

  static Widget commonELBTN({
    required void Function() onPressed,
    required String text,
    required double width,
    required Color color,
    required Color textColor,
    bool iconReq = false,
    String? imagePath,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 53,
        width: width,

        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconReq) ...[
                Image.asset(imagePath!, height: 24, width: 24),
                SizedBox(width: 6),
              ],

              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          /// Fix
        ),
      ),
    );
  }

  static Widget commonELBTNG(
    BuildContext context, {
    required void Function() onTap,
    required String text,
    required double width,
    required double fontSize,
    Color? color,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
    double? height,
        Color? bgColor,
        bool gradiantReq=true,

    bool requested = false,
    bool isFirstTime = false,
        bool isIconReq =false,
        BorderRadiusGeometry? borderRadius,
        String?iconImage,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(

        height: height ?? 60,
        width: width,
        decoration: BoxDecoration(
          borderRadius:borderRadius?? BorderRadius.all(Radius.circular(30)),

          color: bgColor,
          gradient: gradient ,
          boxShadow: boxShadow ?? [BoxShadow(color: AppColors.secondary)],
        ),
        child: Center(
          child: (requested && isFirstTime)
              ? CircularProgressIndicator()

              :isIconReq?Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconImage!,width: 24,height: 24,),
              SizedBox(width: 16,),
              Text(
                text,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                  fontSize: fontSize,
                ),
              )

            ],
          ): Text(
                  text,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                    fontSize: fontSize,
                  ),
                ),
        ),
      ),
    );
  }

  static Widget iconContainer({
    Color? colorText,
    Color? colorBG,
    required String image,
    required String label,

  }) {
    return Center(
      child: Container(
        width: 76,
        height: 70,
        decoration: BoxDecoration(
          color: colorBG,
          gradient: colorBG == null ? AppColors.gradient : null,
          borderRadius: BorderRadiusGeometry.circular(12),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(image, height: 24, width: 24),
            SizedBox(height: 10),

            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorText ?? AppColors.backgroundLight,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<dynamic?> toast({required String msg}) {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: AppColors.backgroundLight,
      fontSize: 16.0,
    );
  }

  static Widget commonTextField(
    BuildContext context, {
     Function(bool) ?onTyping,
        Function(String)? onChanges,
     Function(bool) ?typeComplete,
    required TextEditingController controller,
    String? Function(String?)? validator,
    required Function(String) onCountryChanged,
    required String dialCode,
        required Color dialogBackgroundColor,
        bool isBorder = false,
  }) {
    return TextFormField(
      validator: validator,

      onTap: () {
        onTyping?.call(false);
        typeComplete?.call(true);
      },

      onChanged:onChanges?? (value) {
        onTyping?.call(false);
        typeComplete?.call(true);

      },
      onEditingComplete: () {
        print(typeComplete);
        //onTyping(true);
      },
      onTapUpOutside: (event) {
        onTyping?.call(true);
      },

      controller: controller,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      keyboardType: TextInputType.phone,

      textAlignVertical: TextAlignVertical.center,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
      decoration: InputDecoration(
        enabledBorder: isBorder?OutlineInputBorder(borderSide: BorderSide(color: AppColors.borderClr)):UnderlineInputBorder(borderSide: BorderSide.none),
        focusedBorder:isBorder?OutlineInputBorder(borderSide: BorderSide(color: AppColors.borderClr)): UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 3,
          ),
        ),
        hintText: "00 0000 0000 ",
        hintStyle: TextStyle(
          fontSize: 24,

          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),

        prefixIcon: StatefulBuilder(
          builder: (context, setState) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CountryCodePicker(dialogBackgroundColor: dialogBackgroundColor,

                  onChanged: (country) {


                    setState(() {
                      onCountryChanged(country.dialCode ?? "+91");
                    });
                  },

                  initialSelection: 'IN',

                  pickerStyle: PickerStyle.bottomSheet,
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,

                  textStyle: Theme.of(context).textTheme.titleSmall,
                  searchStyle: Theme.of(context).textTheme.titleSmall,
                  dialogTextStyle: Theme.of(context).textTheme.titleSmall,

                  // Ensure flag is visible
                  builder: (code) => Row(
                    children: [
                      SizedBox(width: 10,),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.asset(
                          code!.flagUri!,
                          package: 'country_code_picker',
                          width: 33.0,
                          height: 24,
                        ),
                      ),
                      SizedBox(width: 6),

                      Image.asset(
                        "assets/icons/arrow_down.png",
                        width: 12,
                        height: 6,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  "($dialCode)",
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 18,
                  ),
                ),

                SizedBox(width: 20),
              ],
            );
          },
        ),
      ),
    );
  }

  static Widget commonPinCodeField(
    BuildContext context, {
    required String? Function(String?)? validator,
    required TextEditingController? controller,
    void Function(String)? onCompleted,
    void Function(String)? onChanged,
    PinCodeTheme? pinTheme,
    TextStyle? textStyle,
  }) {
    final cs = Theme.of(context).colorScheme;

    final defaultTheme = PinCodeTheme(
      shape: PinCodeFieldShape.underline,
      fieldHeight: 60,
      selectedColor: cs.onSurface,
      selectedBorderWidth: 3,
      activeColor: cs.onSurface,
      activeBorderWidth: 3,
      inactiveBorderWidth: 3,
      inactiveColor: cs.primary,
      fieldWidth: 40,
      errorBorderColor: Colors.red,
      errorBorderWidth: 3,
    );

    return SizedBox(
      width: 240,
      child: PinCode(
        controller: controller,
        validator: validator,
        appContext: context,
        length: 4,
        onCompleted: onCompleted,
        onChanged: onChanged,
        separatorBuilder: (context, index) => SizedBox(width: 16),
        showCursor: false,
        pinTheme: pinTheme ?? defaultTheme,
        autoFocus: true,
        textStyle:
            textStyle ??
            Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
      ),
    );
  }

  static Widget commonNameField(
    BuildContext context, {
    String? Function(String?)? validator,
    TextStyle? style,
    required TextEditingController? controller,
    String? iconImage,
    required Function(bool) onTyping,
    required Function(bool) typeComplete,
  }) {
    return TextFormField(
      onChanged: (value) {
        typeComplete(value.isNotEmpty);
      },
      onTapUpOutside: (event) {
        typeComplete(false);
      },
      style: style,
      autofocus: true,

      controller: controller,

      showCursor: true,
      decoration: InputDecoration(
        hintText: "Your name",
        hintStyle: TextStyle(
          fontSize: 24,

          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        prefixIcon: Image.asset(iconImage!, height: 32, width: 32),
      ),
    );
  }

  static Future<void> showLoader(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Center(child: CircularProgressIndicator()),
        );
      },
    );

    await Future.delayed(const Duration(milliseconds: 100));

    //Navigator.pop(context);
  }
}

class Data {
  String title;
  String caption;
  String image;

  Data({required this.caption, required this.title, required this.image});
}
