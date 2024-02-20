import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geomed_assist/User_flow/HomePage.dart';
import 'package:geomed_assist/User_flow/allchates.dart';
import 'package:geomed_assist/User_flow/favorites_shopes_&_doctores.dart';
import 'package:geomed_assist/User_flow/map.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:permission_handler/permission_handler.dart';
int selectedIndex = 0;
class bottomTabBar extends StatefulWidget {
  const bottomTabBar({super.key});

  @override
  State<bottomTabBar> createState() => _bottomTabBarState();
}

class _bottomTabBarState extends State<bottomTabBar> {
  List icons = [
    CupertinoIcons.home,
    Icons.map_outlined,
    CupertinoIcons.chat_bubble,
    Icons.favorite_border,
  ];

  List manuIconsPages = [homePage(), MapScreen(), allChates(), favorits()];
  List manuIconsName = ["Home", "Map", "Chat", "Favorites"];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
        body: manuIconsPages[selectedIndex],
        extendBody: true,
        bottomSheet: KeyboardVisibilityBuilder(
          builder: (p0, isKeyboardVisible) {
            return !isKeyboardVisible ? SafeArea(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: AppColor.backgroundColor,
                color: Colors.black,
                tabs: List.generate(
                  icons.length,
                  (index) => GButton(
                    icon: icons[index],
                    text: manuIconsName[index],
                  ),
                ),
                selectedIndex: selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            )) : SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
