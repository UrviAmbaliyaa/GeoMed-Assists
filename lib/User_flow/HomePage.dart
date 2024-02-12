import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Authentication/sign_up.dart';
import 'package:geomed_assist/User_flow/CategoryDetail.dart';
import 'package:geomed_assist/User_flow/allCategories.dart';
import 'package:geomed_assist/User_flow/allDoctores.dart';
import 'package:geomed_assist/User_flow/allShopes.dart';
import 'package:geomed_assist/User_flow/doctoreDetail.dart';
import 'package:geomed_assist/User_flow/shopDetailScreen.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:geomed_assist/constants/dataFile.dart';
import 'package:geomed_assist/constants/rattingBar.dart';
import 'package:geomed_assist/privacy_Policy.dart';
import 'package:geomed_assist/terms&conditions.dart';

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Disease", style: title),
              InkWell(
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute<bool>(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => new allCategories(),
                  ),
                ),
                child: Text("See All",
                    style: TextStyle(color: AppColor.textColor, fontSize: 13)),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: width * 0.38,
            margin: EdgeInsets.only(top: 5),
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                width: 15,
              ),
              physics: BouncingScrollPhysics(),
              itemCount: Datas().category.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => InkWell(
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute<bool>(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => new categoryDetail(index: index ),
                  ),
                ),
                child: Container(
                  width: width * 0.32,
                  height: width * 0.32,
                  margin: EdgeInsets.only(bottom: 5, left: 5, top: 5),
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
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(Datas().category[index]['image'],
                          height: width * 0.26,
                          fit: BoxFit.cover,
                          width: double.infinity),
                      Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Text(Datas().category[index]['name'],
                            style: TextStyle(
                                color: AppColor.textColor, fontSize: 16),
                            maxLines: 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  shopWidget() {
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
              InkWell(
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute<bool>(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => new allShopes(),
                  ),
                ),
                child: Text("See All",
                    style: TextStyle(color: AppColor.textColor, fontSize: 13)),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: width * 0.53,
            margin: EdgeInsets.only(top: 5),
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                width: 15,
              ),
              physics: BouncingScrollPhysics(),
              itemCount: Datas().shopes.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => InkWell(
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute<bool>(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => new shopDetailScreen(index: index),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      width: width * 0.5,
                      margin: EdgeInsets.only(bottom: 5, left: 5, top: 5),
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
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(Datas().shopes[index]['image'],
                              height: width * 0.28,
                              fit: BoxFit.cover,
                              width: double.infinity),
                          Padding(
                            padding: EdgeInsets.only(top: 6, left: 6, right: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(Datas().shopes[index]['name'],
                                    style: TextStyle(
                                        color: AppColor.textColor,
                                        fontSize: 16),
                                    maxLines: 1),
                                Text(
                                    "Simada Naka, Shiv Darshan Society, Yoginagar Society, Surat, Gujarat 395006",
                                    style: TextStyle(
                                        color: AppColor.greycolor,
                                        fontSize: 13),
                                    maxLines: 2),
                                Row(
                                  children: [
                                    rattingBar(tapOnly: true, initValue: 2.5),
                                    Expanded(
                                      child: Text("5.23 km",
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: AppColor.greycolor,
                                              fontSize: 13),
                                          maxLines: 2),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            favoriteItems
                                    .contains(Datas().shopes[index]['name'])
                                ? favoriteItems
                                    .remove(Datas().shopes[index]['name'])
                                : favoriteItems
                                    .add(Datas().shopes[index]['name']);
                          });
                        },
                        child: Icon(
                          favoriteItems.contains(Datas().shopes[index]['name'])
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 28,
                          color: AppColor.backgroundColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  doctorWidget() {
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
              InkWell(
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute<bool>(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => new allDoctores(),
                  ),
                ),
                child: Text("See All",
                    style: TextStyle(color: AppColor.textColor, fontSize: 13)),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: width * 0.53,
            margin: EdgeInsets.only(top: 5,bottom: 20),
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                width: 15,
              ),
              physics: BouncingScrollPhysics(),
              itemCount: Datas().doctores.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => InkWell(
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute<bool>(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => new doctoreDetail(index: index),
                  ),
                ),
                child: Container(
                  width: width * 0.5,
                  margin: EdgeInsets.only(bottom: 5, left: 5, top: 5),
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
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.network(Datas().doctores[index]['image'],
                              height: width * 0.3,
                              fit: BoxFit.cover,
                              width: double.infinity),
                          Padding(
                            padding: EdgeInsets.only(top: 6, left: 6, right: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(Datas().doctores[index]['name'],
                                    style: TextStyle(
                                        color: AppColor.textColor,
                                        fontSize: 16),
                                    maxLines: 1),
                                SizedBox(height: 3),
                                Text("Education : BCA",
                                    style: TextStyle(
                                        color: AppColor.greycolor,
                                        fontSize: 13),
                                    maxLines: 2),
                                SizedBox(height: 3),
                                Row(
                                  children: [
                                    rattingBar(tapOnly: true, initValue: 0),
                                    Expanded(
                                      child: Text("5.23 km",
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: AppColor.greycolor,
                                              fontSize: 13),
                                          maxLines: 2),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              favoriteItems
                                      .contains(Datas().doctores[index]['name'])
                                  ? favoriteItems
                                      .remove(Datas().doctores[index]['name'])
                                  : favoriteItems
                                      .add(Datas().doctores[index]['name']);
                            });
                          },
                          child: Icon(
                            favoriteItems
                                    .contains(Datas().doctores[index]['name'])
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 28,
                            color: AppColor.backgroundColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
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
                    Icons.menu_sharp,
                    color: AppColor.textColor,
                  ),
                  tooltip: "Drawer",
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                  right: 20, left: 20,top: 20),
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
                decoration: InputDecoration(
                  hintText: "Search here..",
                  hintStyle:
                  TextStyle(color: AppColor.greycolor, fontSize: 15),
                  isDense: true,
                  fillColor: AppColor.backgroundColor,
                  filled: true,
                  contentPadding: EdgeInsets.only(
                      left: 15, top: 5, bottom: 5, right: 15),
                  suffixIcon: Icon(Icons.search,
                      color: AppColor.greycolor, size: 29),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide(
                        color: AppColor.greycolor.withOpacity(0.3)),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(
                        color: AppColor.greycolor,
                      )),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide(
                        color: AppColor.textColor.withOpacity(0.5)),
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
                                  builder: (BuildContext context) => new SignUp(editdcreen: true),
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
                                  builder: (BuildContext context) => new terms_conditions(),
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
                                  builder: (BuildContext context) => new privacy_Policy(),
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
