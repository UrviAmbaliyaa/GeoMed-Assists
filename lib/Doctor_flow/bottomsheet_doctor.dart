import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:geomed_assist/Doctor_flow/HomeScreen_doctore.dart';
import 'package:geomed_assist/Store_flow/rattings_shop.dart';
import 'package:geomed_assist/User_flow/allchates.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class bottomSheet_doctor extends StatefulWidget {
  const bottomSheet_doctor({super.key});

  @override
  State<bottomSheet_doctor> createState() => _bottomSheet_doctorState();
}

class _bottomSheet_doctorState extends State<bottomSheet_doctor> {
  List icons = [
    CupertinoIcons.home,
    CupertinoIcons.chat_bubble,
    CupertinoIcons.star_fill,
  ];
  int _selectedIndex = 0;
  List manuIconsPages = [homeScreen_doctor(), allChates(),shop_rattings(),];
  List manuIconsName = ["Home", "Chat","Rate"];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
        body: manuIconsPages[_selectedIndex],
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
                    selectedIndex: _selectedIndex,
                    onTabChange: (index) {
                      setState(() {
                        _selectedIndex = index;
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