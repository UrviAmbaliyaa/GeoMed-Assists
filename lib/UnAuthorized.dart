import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Authentication/SignUpAsDoctor.dart';
import 'package:geomed_assist/Authentication/SignUpAsShopkeeper.dart';
import 'package:geomed_assist/Authentication/sign_up.dart';
import 'package:geomed_assist/Store_flow/bottomNavigationBar_Shop.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:geomed_assist/privacy_Policy.dart';
import 'package:geomed_assist/terms&conditions.dart';

class unAuthorized extends StatefulWidget {
  const unAuthorized({super.key});

  @override
  State<unAuthorized> createState() => _unAuthorizedState();
}

class _unAuthorizedState extends State<unAuthorized> {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      key: drawerKey,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        leadingWidth: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 15),
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                currentUserDocument!.imagePath!,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currentUserDocument!.name,
                      style:
                          TextStyle(color: AppColor.textColor, fontSize: 20)),
                  Text(
                    currentUserDocument!.address!,
                    style: TextStyle(
                      color: AppColor.greycolor,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => drawerKey.currentState?.openDrawer(),
              icon: Icon(
                Icons.menu,
                color: AppColor.textColor,
              ),
              tooltip: "Drawer",
            )
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            currentUserDocument!.approve == "Pending"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network("https://firebasestorage.googleapis.com/v0/b/geomed-assistans.appspot.com/o/pandingAnimation.gif?alt=media&token=af9d36f3-e723-4df3-9834-3c978af6a876",
                          width: 200),
                      SizedBox(height: 30),
                      Text(
                        "Thank you for your request. We're currently reviewing it and will get back to you soon. Your patience is appreciated",
                        style: TextStyle(
                            fontSize: 20, color: AppColor.textColor),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 100)
                    ],
                  )
                : SizedBox.shrink(),
            currentUserDocument!.approve == "Reject"
                ? Column(
                    children: [
                      Image.network("https://firebasestorage.googleapis.com/v0/b/geomed-assistans.appspot.com/o/rejectedUser.gif?alt=media&token=68b8c448-c143-4c91-a0b8-697c55c05856", width: 100),
                      SizedBox(height: 30),
                      Text(
                          "We're unable to proceed with your request. Your understanding means a lot to us, and we sincerely thank you for considering GeoMed Assist.",
                          style: TextStyle(
                              fontSize: 18, color: AppColor.textColor),textAlign: TextAlign.center),
                      SizedBox(height: 15),
                      Text(currentUserDocument!.cancelReason!,
                          style: TextStyle(
                              fontSize: 18, color: AppColor.textColor),textAlign: TextAlign.center),
                    ],
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
      drawerEnableOpenDragGesture: false,
      drawer: Drawer(
        backgroundColor: AppColor.backgroundColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              currentUserDocument!.imagePath!,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(currentUserDocument!.name,
                              style: TextStyle(
                                  color: AppColor.textColor, fontSize: 23)),
                          Text(
                            currentUserDocument!.address!,
                            style: TextStyle(
                              color: AppColor.greycolor,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: AppColor.greycolor.withOpacity(0.5),
                      thickness: 2,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              drawerKey.currentState?.closeDrawer();
                              Navigator.of(context, rootNavigator: true).push(
                                CupertinoPageRoute<bool>(
                                    fullscreenDialog: true,
                                    builder: (BuildContext context) =>
                                        currentUserDocument!.type == "User"
                                            ? SignUp(editdcreen: true)
                                            : currentUserDocument!.type ==
                                                    "ShopKeeper"
                                                ? SignUpAsShopkeeper(
                                                    editdcreen: true)
                                                : SignUpAsDoctor(
                                                    editdcreen: true)),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                        color: AppColor.textColor,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              drawerKey.currentState?.closeDrawer();
                              Navigator.of(context, rootNavigator: true).push(
                                CupertinoPageRoute<bool>(
                                  fullscreenDialog: true,
                                  builder: (BuildContext context) =>
                                      new terms_conditions(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Text(
                                    'Terms & Conditions',
                                    style: TextStyle(
                                        color: AppColor.textColor,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              drawerKey.currentState?.closeDrawer();
                              Navigator.of(context, rootNavigator: true).push(
                                CupertinoPageRoute<bool>(
                                  fullscreenDialog: true,
                                  builder: (BuildContext context) =>
                                      new privacy_Policy(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Text(
                                    'Privacy Policy',
                                    style: TextStyle(
                                        color: AppColor.textColor,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  drawerKey.currentState?.closeDrawer();
                  constWidget().Logout(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RotatedBox(
                          quarterTurns: 2,
                          child: Icon(Icons.logout,
                              color: AppColor.textColor, size: 20)),
                      SizedBox(width: 10),
                      Text(
                        'Logout',
                        style:
                            TextStyle(color: AppColor.textColor, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 100)
            ],
          ),
        ),
      ),
    );
  }
}
