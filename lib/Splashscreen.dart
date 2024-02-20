import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Doctor_flow/HomeScreen_doctore.dart';
import 'package:geomed_assist/Doctor_flow/bottomsheet_doctor.dart';
import 'package:geomed_assist/Firebase/firebaseAuthentications.dart';
import 'package:geomed_assist/Store_flow/bottomNavigationBar_Shop.dart';
import 'package:geomed_assist/User_flow/BottonTabbar.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:hive/hive.dart';

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
    var userdata = await Hive.box("User");
    var Screens;
    if (userdata != null && userdata.length != 0) {
      String id = await userdata.get('refID');
      if(id != null){
        await firebase_auth().getUserInfo(id: id);
        switch (currentUserDocument!.type) {
          case "User":
            Screens = bottomTabBar();
          case "ShopKeeper":
            Screens = shop_bottomNavigationbar();
          case "Doctore":
            Screens = bottomSheet_doctor();
        }
      }
    }

    Future.delayed(
      Duration(seconds: userdata.length == 0 ? 3 : 0), // Correct the typo here
      () => Navigator.of(context, rootNavigator: true).push(
        CupertinoPageRoute<bool>(
          fullscreenDialog: true,
          builder: (BuildContext context) =>
          Screens == null ? SignIn() : Screens,
        ),
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
