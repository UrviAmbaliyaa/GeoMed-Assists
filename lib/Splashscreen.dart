import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Admin_Panel/bottom_navigationBar/bottombar_Admin.dart';
import 'package:geomed_assist/Doctor_flow/HomeScreen_doctore.dart';
import 'package:geomed_assist/Doctor_flow/bottomsheet_doctor.dart';
import 'package:geomed_assist/Firebase/firebaseAuthentications.dart';
import 'package:geomed_assist/Store_flow/bottomNavigationBar_Shop.dart';
import 'package:geomed_assist/UnAuthorized.dart';
import 'package:geomed_assist/User_flow/BottonTabbar.dart';
import 'package:geomed_assist/User_flow/map.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'Authentication/sign_in.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    managScreen();
  }

  managScreen() async {
    var Screens;
    print("FirebaseAuth.instance.currentUser ----->${FirebaseAuth.instance.currentUser}");
    if (FirebaseAuth.instance.currentUser != null) {
        await firebase_auth().getUserInfo(id: FirebaseAuth.instance.currentUser!.uid);
        switch (currentUserDocument!.type) {
          case "User":
            Screens = currentUserDocument!.approve == "Accepted" ? MapScreen() :unAuthorized();
          case "ShopKeeper":
            Screens = currentUserDocument!.approve == "Accepted" ? shop_bottomNavigationbar() :unAuthorized();
          case "Doctore":
            Screens = currentUserDocument!.approve == "Accepted" ? bottomSheet_doctor() :unAuthorized();
          case "Admin":
            Screens = admin_bottomTabBar();
        }
    }

    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute<bool>(
        fullscreenDialog: true,
        builder: (BuildContext context) =>
        FirebaseAuth.instance.currentUser == null ? SignIn() : Screens,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.purplecolor,
      body: Center(
        child: Image.asset("assets/logo/Logo.png", color: Colors.white),
      ),
    );
  }
}
