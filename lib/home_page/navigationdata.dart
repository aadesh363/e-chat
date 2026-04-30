import 'package:e_chat/utilities/commonColors.dart';
import 'package:e_chat/utilities/commonWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationData {
  int activeIndex = 0;


  static List<BottomNavigationBarItem>  getNavItems(BuildContext context){
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color colorBG = isDark?AppColors.backgroundDark: AppColors.backgroundLight;
    Color textClr = Color(0xff9A9BB1);

    return [
      BottomNavigationBarItem(
      icon: CWidget.iconContainer(image: "assets/icons/cat_inactive_icon.png",label: "Chats",colorBG: colorBG,colorText:textClr ) ,
      activeIcon: CWidget.iconContainer(image: "assets/icons/chat_icon_light.png",label: "Chats", ) ,
      label: "",

    ),
      BottomNavigationBarItem(
        icon: CWidget.iconContainer(image: "assets/icons/group_icon_inactive.png",label: "Groups",colorBG: colorBG,colorText:textClr ) ,
        activeIcon: CWidget.iconContainer(image: "assets/icons/group_icon_active.png",label: "Groups", ) ,
        label: "",

      ),
      BottomNavigationBarItem(
        icon: CWidget.iconContainer(image: "assets/icons/profile_icon_inactive.png",label: "Profile",colorBG: colorBG,colorText:textClr ) ,
        activeIcon: CWidget.iconContainer(image: "assets/icons/profile_icon_active.png",label: "Profile", ) ,
        label: "",

      ),
      BottomNavigationBarItem(
        icon: CWidget.iconContainer(image: "assets/icons/more_icon_inactive.png",label: "Profile",colorBG: colorBG,colorText:textClr ) ,
        activeIcon: CWidget.iconContainer(image: "assets/icons/more_icon_active.png",label: "Profile", ) ,
        label: "",

      ),

    ];
  }














}
