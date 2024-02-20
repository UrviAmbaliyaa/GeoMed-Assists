import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Authentication/sign_up.dart';
import 'package:geomed_assist/Firebase/firebase_quaries.dart';
import 'package:geomed_assist/Models/categoryModel.dart';
import 'package:geomed_assist/Models/user_model.dart';
import 'package:geomed_assist/User_flow/CategoryDetail.dart';
import 'package:geomed_assist/User_flow/allCategories.dart';
import 'package:geomed_assist/User_flow/allDoctores.dart';
import 'package:geomed_assist/User_flow/allShopes.dart';
import 'package:geomed_assist/User_flow/doctoreDetail.dart';
import 'package:geomed_assist/User_flow/favorites.dart';
import 'package:geomed_assist/User_flow/requests.dart';
import 'package:geomed_assist/User_flow/shopDetailScreen.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:geomed_assist/constants/dataFile.dart';
import 'package:geomed_assist/constants/rattingBar.dart';
import 'package:geomed_assist/privacy_Policy.dart';
import 'package:geomed_assist/terms&conditions.dart';
import 'dart:developer';

List favoriteItems = [];

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  TextEditingController serachingController = TextEditingController();
  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  double width = 0.0;
  double height = 0.0;
  TextStyle title = TextStyle(color: AppColor.textColor, fontSize: 20);

  diseases() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(right: 20, left: 20, top: 10),
      child: StreamBuilder<List<categoryModel>?>(
          stream: Firebase_Quires().getCategory(),
          builder: (context, snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Disease", style: title),
                    snapshot.hasData && snapshot.data!.length > 10
                        ? InkWell(
                            onTap: () =>
                                Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute<bool>(
                                fullscreenDialog: true,
                                builder: (BuildContext context) =>
                                    new allCategories(
                                        categories: snapshot.data!),
                              ),
                            ),
                            child: Text("See All",
                                style: TextStyle(
                                    color: AppColor.textColor, fontSize: 13)),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: width * 0.38,
                  margin: EdgeInsets.only(top: 5),
                  child: (snapshot.connectionState == ConnectionState.done ||
                              snapshot.connectionState ==
                                  ConnectionState.active) &&
                          snapshot.hasData &&
                          snapshot.data!.length != 0
                      ? ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                                width: 15,
                              ),
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var data = snapshot.data![index];
                            var isvisible = serachingController.text.isNotEmpty?(data.name.toUpperCase().contains(serachingController.text.toUpperCase())): true;
                            return Visibility(
                              visible: isvisible,
                              child: InkWell(
                                onTap: () =>
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                  CupertinoPageRoute<bool>(
                                    fullscreenDialog: true,
                                    builder: (BuildContext context) =>
                                        categoryDetail(category: data),
                                  ),
                                ),
                                child: Container(
                                  width: width * 0.32,
                                  height: width * 0.32,
                                  margin: const EdgeInsets.only(
                                      bottom: 5, left: 5, top: 5),
                                  padding: EdgeInsets.all(2),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: AppColor.backgroundColor,
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 8,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.network(data.imageUrl,
                                          height: width * 0.26,
                                          fit: BoxFit.cover,
                                          width: double.infinity),
                                      Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Text(data.name,
                                            style: TextStyle(
                                                color: AppColor.textColor,
                                                fontSize: 16),
                                            maxLines: 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                      : snapshot.connectionState == ConnectionState.waiting
                          ? Center(
                              child: constWidget()
                                  .circularProgressInd(nodatafound: false),
                            )
                          : Center(
                              child: constWidget()
                                  .circularProgressInd(nodatafound: true),
                            ),
                ),
              ],
            );
          }),
    );
  }

  shopWidget() {
    return StreamBuilder<List<UserModel>?>(
        stream: Firebase_Quires().getShopKeepe_Doctore(shopkeeper: true),
        builder: (context, snapshot) {
          return Container(
            width: double.infinity,
            margin: EdgeInsets.only(right: 20, left: 20, top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Shops", style: title),
                    snapshot.hasData && snapshot.data!.length < 10
                        ? InkWell(
                            onTap: () =>
                                Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute<bool>(
                                fullscreenDialog: true,
                                builder: (BuildContext context) =>
                                    allShopes(shopKeppers: snapshot.data!),
                              ),
                            ),
                            child: Text("See All",
                                style: TextStyle(
                                    color: AppColor.textColor, fontSize: 13)),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: width * 0.53,
                  margin: EdgeInsets.only(top: 5),
                  child: (snapshot.connectionState == ConnectionState.active ||
                              snapshot.connectionState ==
                                  ConnectionState.done) &&
                          snapshot.hasData &&
                          snapshot.data!.length != 0
                      ? ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var data = snapshot.data![index];
                            var visiblity = serachingController.text.isNotEmpty?
                                    (data.name.toUpperCase().contains(serachingController.text.toUpperCase()) ||
                                        data.address.toUpperCase().contains(serachingController.text.toUpperCase()) ||
                                        data.distanc.toString().contains(serachingController.text)
                                    ): true;
                            return Visibility(
                              visible: visiblity,
                              child: InkWell(
                                onTap: () =>
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                  CupertinoPageRoute<bool>(
                                    fullscreenDialog: true,
                                    builder: (BuildContext context) =>
                                        shopDetailScreen(data: data),
                                  ),
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        width: width * 0.5,
                                        margin: EdgeInsets.only(
                                            bottom: 5, left: 5, top: 5),
                                        padding: EdgeInsets.all(2),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          color: AppColor.backgroundColor,
                                          borderRadius: BorderRadius.circular(15.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 8,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.network(data.imagePath!,
                                                height: width * 0.28,
                                                fit: BoxFit.cover,
                                                width: double.infinity),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 6, left: 6, right: 6),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(data.name,
                                                      style: TextStyle(
                                                          color: AppColor.textColor,
                                                          fontSize: 16),
                                                      maxLines: 1),
                                                  Text(data.address,
                                                      style: TextStyle(
                                                          color: AppColor.greycolor,
                                                          fontSize: 13),
                                                      maxLines: 2),
                                                  StreamBuilder<UserModel?>(
                                                      stream: Firebase_Quires().getuserInfo(refId: data.reference),
                                                      builder: (context, snapshot) {
                                                        return Row(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            rattingBar(
                                                                tapOnly: true,
                                                                initValue: (snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.waiting) && snapshot.hasData ? (snapshot.data!.rate! /snapshot.data!.ratedUser!):0,
                                                                size: 15),
                                                            Text(
                                                                "${calculateDistance(currentUserDocument!.latLong, currentUserDocument!.longitude, data.latLong, data.longitude)} km",
                                                                style: TextStyle(
                                                                    color: AppColor.greycolor,
                                                                    fontSize: 13,
                                                                    fontWeight: FontWeight.w500))
                                                          ],
                                                        );
                                                      }
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Favorites(reference: data.reference, action: () {}),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : snapshot.connectionState == ConnectionState.waiting
                          ? Center(
                              child: constWidget()
                                  .circularProgressInd(nodatafound: false),
                            )
                          : Center(
                              child: constWidget()
                                  .circularProgressInd(nodatafound: true),
                            ),
                )
              ],
            ),
          );
        });
  }

  doctorWidget() {
    return StreamBuilder<List<UserModel>?>(
        stream: Firebase_Quires().getShopKeepe_Doctore(shopkeeper: false),
        builder: (context, snapshot) {
          print(snapshot.connectionState);
          return Container(
            width: double.infinity,
            margin: EdgeInsets.only(right: 20, left: 20, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Doctors", style: title),
                    snapshot.hasData && snapshot.data!.length < 10
                        ? InkWell(
                            onTap: () =>
                                Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute<bool>(
                                fullscreenDialog: true,
                                builder: (BuildContext context) =>
                                    allDoctores(doctores: snapshot.data!),
                              ),
                            ),
                            child: Text("See All",
                                style: TextStyle(
                                    color: AppColor.textColor, fontSize: 13)),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: width * 0.53,
                  margin: EdgeInsets.only(top: 5, bottom: 20),
                  child: (snapshot.connectionState == ConnectionState.active ||
                              snapshot.connectionState ==
                                  ConnectionState.done) &&
                          snapshot.hasData &&
                          snapshot.data!.length != 0
                      ? ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var data = snapshot.data![index];
                            var visiblity = serachingController.text.isNotEmpty?
                            (data.name.toUpperCase().contains(serachingController.text.toUpperCase()) ||
                                data.address.toUpperCase().contains(serachingController.text.toUpperCase()) ||
                                data.degree!.toUpperCase().contains(serachingController.text.toUpperCase()) ||
                                data.distanc.toString().contains(serachingController.text) ||
                                data.exp!.toUpperCase().contains(serachingController.text.toUpperCase())
                            ): true;
                            return Visibility(
                              visible: visiblity,
                              child: Container(
                                margin: EdgeInsets.only(right: 15),
                                child: InkWell(
                                  onTap: () =>
                                      Navigator.of(context, rootNavigator: true)
                                          .push(
                                    CupertinoPageRoute<bool>(
                                      fullscreenDialog: true,
                                      builder: (BuildContext context) =>
                                          doctoreDetail(doctor: data),
                                    ),
                                  ),
                                  child: Container(
                                    width: width * 0.5,
                                    margin:
                                        EdgeInsets.only(bottom: 5, left: 5, top: 5),
                                    padding: EdgeInsets.all(2),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: AppColor.backgroundColor,
                                      borderRadius: BorderRadius.circular(15.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 8,
                                          offset: Offset(
                                              0, 3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Image.network(data.imagePath!,
                                                height: width * 0.3,
                                                fit: BoxFit.cover,
                                                width: double.infinity),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 6, left: 6, right: 6),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(data.name,
                                                      style: TextStyle(
                                                          color: AppColor.textColor,
                                                          fontSize: 16),
                                                      maxLines: 1),
                                                  SizedBox(height: 3),
                                                  Text("Education : ${data.degree}",
                                                      style: TextStyle(
                                                          color: AppColor.greycolor,
                                                          fontSize: 13),
                                                      maxLines: 2),
                                                  SizedBox(height: 3),
                                                  StreamBuilder<UserModel?>(
                                                      stream: Firebase_Quires().getuserInfo(refId: data.reference),
                                                      builder: (context, snapshot) {
                                                        return Row(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            rattingBar(
                                                                tapOnly: true,
                                                                initValue: (snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.waiting) && snapshot.hasData ? (snapshot.data!.rate! /snapshot.data!.ratedUser!):0,
                                                                size: 15),
                                                            Text(
                                                                "${calculateDistance(currentUserDocument!.latLong, currentUserDocument!.longitude, data.latLong, data.longitude)} km",
                                                                style: TextStyle(
                                                                    color: AppColor.greycolor,
                                                                    fontSize: 13,
                                                                    fontWeight: FontWeight.w500))
                                                          ],
                                                        );
                                                      }
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Favorites(reference: data.reference, action: () {}),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : snapshot.connectionState == ConnectionState.waiting
                          ? Center(
                              child: constWidget()
                                  .circularProgressInd(nodatafound: false),
                            )
                          : Center(
                              child: constWidget()
                                  .circularProgressInd(nodatafound: true),
                            ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: drawerKey,
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        leadingWidth: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 150,
        title: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                          style: TextStyle(
                              color: AppColor.textColor, fontSize: 20)),
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
                    Icons.menu_sharp,
                    color: AppColor.textColor,
                  ),
                  tooltip: "Drawer",
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: 20, left: 20, top: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: TextField(
                controller: serachingController,
                style: TextStyle(color: AppColor.textColor, fontSize: 15),
                onChanged: (value) {
                  Future.delayed(Duration(seconds: 1),() => setState(() {}));
                },
                decoration: InputDecoration(
                  hintText: "Search here..",
                  hintStyle: TextStyle(color: AppColor.greycolor, fontSize: 15),
                  isDense: true,
                  fillColor: AppColor.backgroundColor,
                  filled: true,
                  contentPadding:
                      EdgeInsets.only(left: 15, top: 5, bottom: 5, right: 15),
                  suffixIcon:
                      Icon(Icons.search, color: AppColor.greycolor, size: 29),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide:
                        BorderSide(color: AppColor.greycolor.withOpacity(0.3)),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(
                        color: AppColor.greycolor,
                      )),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide:
                        BorderSide(color: AppColor.textColor.withOpacity(0.5)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              diseases(),
              shopWidget(),
              doctorWidget(),
            ],
          ),
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
                            currentUserDocument!.address,
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
                            onTap: () {
                              drawerKey.currentState?.closeDrawer();
                              Navigator.of(context, rootNavigator: true).push(
                                CupertinoPageRoute<bool>(
                                  fullscreenDialog: true,
                                  builder: (BuildContext context) =>
                                      new SignUp(editdcreen: true),
                                ),
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
                            onTap: () {
                              drawerKey.currentState?.closeDrawer();
                              Navigator.of(context, rootNavigator: true).push(
                                CupertinoPageRoute<bool>(
                                  fullscreenDialog: true,
                                  builder: (BuildContext context) =>
                                      requests(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Text(
                                    'Product Request',
                                    style: TextStyle(
                                        color: AppColor.textColor,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
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
