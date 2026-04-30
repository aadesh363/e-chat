import 'package:e_chat/utilities/commonColors.dart';
import 'package:flutter/material.dart';

class OwnTextTheme{

  static TextStyle largeTitle(Color color,{String? fontFamily}){
    return TextStyle(
    fontWeight: FontWeight.w700,
      fontSize: 25,
      color: color,
      inherit: true,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle mediumTitle(Color color,{String? fontFamily}){
    return TextStyle(
      fontWeight:  FontWeight.w500,
      fontSize: 18,
      color: color,
      inherit: true,

      decoration:  TextDecoration.none,
    );
  }
  static TextStyle smallTitle(Color color,{String?fontFamily}){
    return TextStyle(
      fontWeight: FontWeight.w400,
          fontSize: 20,
          color: color,
      inherit: true,
      decoration: TextDecoration.none,
    );
  }
  static TextStyle bodyLargeText(Color color,{String?fontFamily}){
    return TextStyle(
      fontWeight:  FontWeight.w700,
      fontSize: 35,
      color: color,
      inherit: true,
      decoration: TextDecoration.none,
    );
  }
  static TextStyle bodyMediumText(Color color,{String?fontFamily}){
    return TextStyle(
      fontWeight:  FontWeight.w500,
      fontSize: 32,
      color: color,
      inherit: true,
      decoration: TextDecoration.none,
    );
  }
}

class OwnThemeData{
  static TextTheme textTheme({String?fontFamily}){
    return TextTheme(
      titleLarge: OwnTextTheme.largeTitle(AppColors.textPrimaryLight),
      titleMedium: OwnTextTheme.mediumTitle(AppColors.textPrimaryLight),
      titleSmall: OwnTextTheme.smallTitle(AppColors.textSecondaryLight),
      bodyLarge: OwnTextTheme.bodyLargeText(AppColors.textPrimaryLight),
      bodyMedium: OwnTextTheme.bodyMediumText(AppColors.textPrimaryLight),
    );
 }



}

class OwnThemeDataDark {
  static TextTheme textTheme({String?fontFamily}) {
    return TextTheme(
      titleLarge: OwnTextTheme.largeTitle(AppColors.backgroundLight),
      titleMedium: OwnTextTheme.mediumTitle(AppColors.textPrimaryDark),
      titleSmall: OwnTextTheme.smallTitle(AppColors.textSecondaryLight),
      bodyLarge: OwnTextTheme.bodyLargeText(AppColors.textPrimaryDark),
      bodyMedium: OwnTextTheme.bodyMediumText(AppColors.textPrimaryDark),

    );
  }
}
