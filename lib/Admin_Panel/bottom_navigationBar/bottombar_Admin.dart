import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:geomed_assist/Admin_Panel/products_admin.dart';
import 'package:geomed_assist/Admin_Panel/requests.dart';
import 'package:geomed_assist/User_flow/allCategories.dart';
import 'package:geomed_assist/User_flow/allchates.dart';
import 'package:geomed_assist/User_flow/favorites_shopes_&_doctores.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/privacy_Policy.dart';
import 'package:geomed_assist/terms&conditions.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class admin_bottomTabBar extends StatefulWidget {
  const admin_bottomTabBar({super.key});

  @override
  State<admin_bottomTabBar> createState() => _admin_bottomTabBarState();
}

class _admin_bottomTabBarState extends State<admin_bottomTabBar> {
  List icons = [
    CupertinoIcons.person_crop_circle,
    Icons.fact_check_outlined,
    CupertinoIcons.plus_rectangle_fill_on_rectangle_fill,
  ];
  int selectedIndex = 0;
  List manuIconsPages = [userRequests(), product_admin(), allCategories()];
  List manuIconsName = ["Request", "Product", "Disease"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
