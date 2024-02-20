import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:geomed_assist/Store_flow/ProductsPage.dart';
import 'package:geomed_assist/Store_flow/rattings_shop.dart';
import 'package:geomed_assist/User_flow/allchates.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
int selectedIndex = 0;
class shop_bottomNavigationbar extends StatefulWidget {
  const shop_bottomNavigationbar({super.key});

  @override
  State<shop_bottomNavigationbar> createState() => _shop_bottomNavigationbarState();
}

class _shop_bottomNavigationbarState extends State<shop_bottomNavigationbar> {
  List icons = [
    CupertinoIcons.home,
    CupertinoIcons.chat_bubble,
    CupertinoIcons.star_fill,
  ];

  List manuIconsPages = [products(), allChates(),shop_rattings(),];
  List manuIconsName = ["Home", "Chat","Rate"];
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
