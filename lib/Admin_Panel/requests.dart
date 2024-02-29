import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Admin_Panel/categories_add.dart';
import 'package:geomed_assist/Authentication/sign_up.dart';
import 'package:geomed_assist/Models/user_model.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:geomed_assist/privacy_Policy.dart';
import 'package:geomed_assist/terms&conditions.dart';
import 'package:intl/intl.dart';

import '../Firebase/firebaseAuthentications.dart';
import '../User_flow/doctoreDetail.dart';
import '../User_flow/shopDetailScreen.dart';

class userRequests extends StatefulWidget {
  const userRequests({super.key});

  @override
  State<userRequests> createState() => _userRequestsState();
}

class _userRequestsState extends State<userRequests> {
  List switches = ["All", "Pending", 'Accepted', "Rejected"];
  List pages = [allUsers(), pendingUsers(), acceptedUsers(), rejectedUsers()];
  int selected = 0;
  PageController pgControll = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          leadingWidth: 0,
          toolbarHeight: 80,
          automaticallyImplyLeading: false,
          excludeHeaderSemantics: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(currentUserDocument!.imagePath!),
                radius: 30,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome ${currentUserDocument!.name}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w900),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 3),
                      Text(
                        currentUserDocument!.email,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuButton<int>(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.more_vert, size: 30, color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                elevation: 8,
                enabled: true,
                color: Colors.white,
                // Set background color to white
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    height: 50,
                    onTap: () async {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute<bool>(
                          fullscreenDialog: true,
                          builder: (BuildContext context) =>
                              SignUp(editdcreen: true),
                        ),
                      );
                    },
                    child: Text('Edit Profile',
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                  PopupMenuItem(
                    height: 50,
                    onTap: () async {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute<bool>(
                          fullscreenDialog: true,
                          builder: (BuildContext context) => terms_conditions(),
                        ),
                      );
                    },
                    child: Text('Terms & Conditions',
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                  PopupMenuItem(
                    height: 50,
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute<bool>(
                          fullscreenDialog: true,
                          builder: (BuildContext context) => privacy_Policy(),
                        ),
                      );
                    },
                    child: Text('Privacy policy',
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                  PopupMenuItem(
                    height: 50,
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute<bool>(
                          fullscreenDialog: true,
                          builder: (BuildContext context) =>
                              addCategories(edit: false),
                        ),
                      );
                    },
                    child: Text('Add Diseases',
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                  PopupMenuItem(
                      height: 50,
                      onTap: () {
                        constWidget().Logout(context);
                      },
                      child: Text('Log out',
                          style: TextStyle(color: Colors.black, fontSize: 16))),
                ],
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.deepPurple.withOpacity(0.05)),
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(width: 7),
                shrinkWrap: true,
                itemCount: 4,
                padding: EdgeInsets.symmetric(horizontal: 5),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    onTap: () => setState(() {
                      selected = index;
                      pgControll.animateToPage(index,
                          curve: Curves.decelerate,
                          duration: Duration(milliseconds: 300));
                    }),
                    child: Container(
                      height: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: selected == index
                              ? Colors.deepPurple.withOpacity(0.7)
                              : Colors.transparent),
                      child: Text(switches[index],
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: selected != index
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                              color: selected != index
                                  ? Colors.deepPurple.withOpacity(0.7)
                                  : Colors.white)),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: PageView.builder(
                itemCount: 4,
                controller: pgControll,
                onPageChanged: (value) {
                  setState(() {
                    selected = value;
                  });
                },
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return pages[index];
                },
              ),
            )
          ],
        ));
  }
}

alertPopu(
    GlobalKey<FormState> formKey, TextEditingController controller, context,
    {required UserModel user}) {
  return Container(
    width: 350,
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    height: 275,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "Reject Request of ${user.name}",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          maxLines: 2,
        ),
        Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.multiline,
            cursorColor: AppColor.primaryColor,
            maxLines: 5,
            validator: (value) {
              if (value!.trim().isEmpty) {
                return "Please write your request message.";
              }
              return null;
            },
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                bottom: 13,
                left: 13,
                right: 2,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: AppColor.primaryColor,
                  width: 1,
                ),
              ),
              isDense: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                  width: 2,
                ),
              ),
              hintText: "Write your reason here..",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: () {
                var validate = formKey.currentState!.validate();
                if (validate) {
                  user.reference.update(
                      {"cancelReason": controller.text, "approve": "Reject"});
                  Navigator.pop(context);
                }
              },
              style: ButtonStyle(
                  elevation: MaterialStatePropertyAll(0),
                  backgroundColor: MaterialStatePropertyAll(
                      CupertinoColors.systemRed.withOpacity(0.5))),
              child: Text("Reject",
                  style: TextStyle(color: Colors.black, fontSize: 17))),
        )
      ],
    ),
  );
}

class allUsers extends StatefulWidget {
  const allUsers({super.key});

  @override
  State<allUsers> createState() => _allUsersState();
}

class _allUsersState extends State<allUsers> {
  var formKey = GlobalKey<FormState>();
  TextEditingController description = TextEditingController();
  TextEditingController searcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.deepPurple.withOpacity(0.05)),
          child: TextFormField(
            controller: searcontroller,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              Future.delayed(Duration(seconds: 2), () => setState(() {}));
            },
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(top: 15, bottom: 15, left: 13, right: 2),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(
                      color: Colors.deepPurple.withOpacity(0.5), width: 2)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              hintText: "Search here...",
              hintStyle: TextStyle(
                  color: Colors.deepPurple.withOpacity(0.5),
                  fontSize: 17,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User")
                  .orderBy('register', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.connectionState == ConnectionState.active
                    ? snapshot.hasData
                        ? Container(
                            width: double.infinity,
                            height: double.infinity,
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.only(bottom: 80),
                              itemBuilder: (context, index) {
                                Map<String, dynamic> data =
                                    snapshot.data!.docs[index].data();
                                data.addAll({
                                  "reference":
                                      snapshot.data!.docs[index].reference
                                });
                                var userdata = UserModel.fromJson(data);
                                return userdata.type != "Admin" &&
                                        userdata.type != "User" &&
                                        (searcontroller.text.isEmpty ||
                                            (searcontroller.text.isNotEmpty &&
                                                userdata.name
                                                    .toUpperCase()
                                                    .contains(searcontroller
                                                        .text
                                                        .trim()
                                                        .toUpperCase())))
                                    ? InkWell(
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(
                                            CupertinoPageRoute<bool>(
                                              fullscreenDialog: true,
                                              builder: (BuildContext context) =>
                                                  userdata.type == "ShopKeeper"
                                                      ? shopDetailScreen(
                                                          data: userdata)
                                                      : doctoreDetail(
                                                          doctor: userdata),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.deepPurple
                                                        .withOpacity(0.1),
                                                    blurRadius: 10,
                                                    spreadRadius: 3)
                                              ]),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 35,
                                                backgroundColor: Colors.white,
                                                foregroundColor: Colors.white,
                                                backgroundImage: NetworkImage(
                                                  userdata.imagePath!,
                                                ),
                                              ),
                                              Expanded(
                                                  child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5, horizontal: 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${userdata.name}",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      maxLines: 2,
                                                    ),
                                                    Text(
                                                      userdata.email,
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                      maxLines: 1,
                                                    ),
                                                    userdata.approve == "Reject"
                                                        ? Text(
                                                            "Reason: ${userdata.cancelReason!}",
                                                            style: TextStyle(
                                                                fontSize: 15),
                                                          )
                                                        : SizedBox.shrink(),
                                                    Text(
                                                        "Register at ${DateFormat('dd MMM yyyy').format(userdata.register)}",
                                                        style: TextStyle(
                                                            fontSize: 15)),
                                                  ],
                                                ),
                                              )),
                                              userdata.approve == "Accepted"
                                                  ? ElevatedButton(
                                                      onPressed: () {},
                                                      style: ButtonStyle(
                                                          elevation:
                                                              MaterialStatePropertyAll(
                                                                  0),
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  CupertinoColors
                                                                      .systemGreen
                                                                      .withOpacity(
                                                                          0.5))),
                                                      child: Text("Accept",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)))
                                                  : SizedBox.shrink(),
                                              userdata.approve == "Pending"
                                                  ? ElevatedButton(
                                                      onPressed: () {},
                                                      style: ButtonStyle(
                                                          elevation:
                                                              MaterialStatePropertyAll(
                                                                  0),
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  CupertinoColors
                                                                      .systemGrey
                                                                      .withOpacity(
                                                                          0.5))),
                                                      child: Text("Pending",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)))
                                                  : SizedBox.shrink(),
                                              userdata.approve == "Reject"
                                                  ? ElevatedButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                elevation: 0,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                content: alertPopu(
                                                                    formKey,
                                                                    description,
                                                                    context,
                                                                    user:
                                                                        userdata),
                                                              );
                                                            });
                                                      },
                                                      style: ButtonStyle(
                                                          elevation:
                                                              MaterialStatePropertyAll(
                                                                  0),
                                                          backgroundColor:
                                                              MaterialStatePropertyAll(
                                                                  CupertinoColors
                                                                      .systemRed
                                                                      .withOpacity(
                                                                          0.5))),
                                                      child: Text("Reject",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)))
                                                  : SizedBox.shrink()
                                            ],
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink();
                              },
                            ),
                          )
                        : constWidget().circularProgressInd(nodatafound: true)
                    : constWidget().circularProgressInd(nodatafound: false);
              }),
        ),
      ],
    );
  }
}

class pendingUsers extends StatefulWidget {
  const pendingUsers({super.key});

  @override
  State<pendingUsers> createState() => _pendingUsersState();
}

class _pendingUsersState extends State<pendingUsers> {
  var formKey = GlobalKey<FormState>();
  TextEditingController description = TextEditingController();
  TextEditingController searcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.deepPurple.withOpacity(0.05)),
          child: TextFormField(
            controller: searcontroller,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              Future.delayed(Duration(seconds: 2), () => setState(() {}));
            },
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(top: 15, bottom: 15, left: 13, right: 2),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(
                      color: Colors.deepPurple.withOpacity(0.5), width: 2)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              hintText: "Search here...",
              hintStyle: TextStyle(
                  color: Colors.deepPurple.withOpacity(0.5),
                  fontSize: 17,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User")
                  .orderBy('register', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.connectionState == ConnectionState.active
                    ? snapshot.hasData
                        ? Container(
                            width: double.infinity,
                            height: double.infinity,
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.only(bottom: 80),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> data =
                                    snapshot.data!.docs[index].data();
                                data.addAll({
                                  "reference":
                                      snapshot.data!.docs[index].reference
                                });
                                var userdata = UserModel.fromJson(data);
                                return userdata.type != "Admin" &&
                                        userdata.type != "User" &&
                                        userdata.approve == "Pending" &&
                                        (searcontroller.text.isEmpty ||
                                            (searcontroller.text.isNotEmpty &&
                                                userdata.name
                                                    .toUpperCase()
                                                    .contains(searcontroller
                                                        .text
                                                        .trim()
                                                        .toUpperCase())))
                                    ? InkWell(
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(
                                            CupertinoPageRoute<bool>(
                                              fullscreenDialog: true,
                                              builder: (BuildContext context) =>
                                                  userdata.type == "ShopKeeper"
                                                      ? shopDetailScreen(
                                                          data: userdata)
                                                      : doctoreDetail(
                                                          doctor: userdata),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.deepPurple
                                                        .withOpacity(0.1),
                                                    blurRadius: 10,
                                                    spreadRadius: 3)
                                              ]),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 35,
                                                backgroundColor: Colors.white,
                                                foregroundColor: Colors.white,
                                                backgroundImage: NetworkImage(
                                                  userdata.imagePath!,
                                                ),
                                              ),
                                              Expanded(
                                                  child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5, horizontal: 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${userdata.name}",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      maxLines: 2,
                                                    ),
                                                    Text(
                                                      userdata.email,
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                      maxLines: 1,
                                                    ),
                                                    Text(
                                                        "Register at ${DateFormat('dd MMM yyyy').format(userdata.register)}",
                                                        style: TextStyle(
                                                            fontSize: 15)),
                                                  ],
                                                ),
                                              )),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 93,
                                                    height: 35,
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          userdata.reference
                                                              .update({
                                                            "approve":
                                                                "Accepted"
                                                          });
                                                        },
                                                        style: ButtonStyle(
                                                            elevation:
                                                                MaterialStatePropertyAll(
                                                                    0),
                                                            backgroundColor: MaterialStatePropertyAll(
                                                                CupertinoColors
                                                                    .systemGreen
                                                                    .withOpacity(
                                                                        0.5))),
                                                        child: Text("Accept",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black))),
                                                  ),
                                                  SizedBox(height: 5),
                                                  SizedBox(
                                                    width: 93,
                                                    height: 35,
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  elevation: 0,
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  content: alertPopu(
                                                                      formKey,
                                                                      description,
                                                                      context,
                                                                      user:
                                                                          userdata),
                                                                );
                                                              });
                                                        },
                                                        style: ButtonStyle(
                                                            elevation:
                                                                MaterialStatePropertyAll(
                                                                    0),
                                                            backgroundColor:
                                                                MaterialStatePropertyAll(
                                                                    CupertinoColors
                                                                        .systemRed
                                                                        .withOpacity(
                                                                            0.5))),
                                                        child: Text("Reject",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black))),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink();
                              },
                            ),
                          )
                        : constWidget().circularProgressInd(nodatafound: true)
                    : constWidget().circularProgressInd(nodatafound: false);
              }),
        ),
      ],
    );
  }
}

class acceptedUsers extends StatefulWidget {
  const acceptedUsers({super.key});

  @override
  State<acceptedUsers> createState() => _acceptedUsersState();
}

class _acceptedUsersState extends State<acceptedUsers> {
  var formKey = GlobalKey<FormState>();
  TextEditingController description = TextEditingController();
  TextEditingController searcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.deepPurple.withOpacity(0.05)),
          child: TextFormField(
            controller: searcontroller,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              Future.delayed(Duration(seconds: 2), () => setState(() {}));
            },
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(top: 15, bottom: 15, left: 13, right: 2),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(
                      color: Colors.deepPurple.withOpacity(0.5), width: 2)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              hintText: "Search here...",
              hintStyle: TextStyle(
                  color: Colors.deepPurple.withOpacity(0.5),
                  fontSize: 17,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User")
                  .orderBy('register', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.connectionState == ConnectionState.active
                    ? snapshot.hasData
                        ? Container(
                            width: double.infinity,
                            height: double.infinity,
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.only(bottom: 80),
                              itemBuilder: (context, index) {
                                Map<String, dynamic> data =
                                    snapshot.data!.docs[index].data();
                                data.addAll({
                                  "reference":
                                      snapshot.data!.docs[index].reference
                                });
                                var userdata = UserModel.fromJson(data);
                                return userdata.type != "Admin" &&
                                        userdata.type != "User" &&
                                        userdata.approve == "Accepted" &&
                                        (searcontroller.text.isEmpty ||
                                            (searcontroller.text.isNotEmpty &&
                                                userdata.name
                                                    .toUpperCase()
                                                    .contains(searcontroller
                                                        .text
                                                        .trim()
                                                        .toUpperCase())))
                                    ? InkWell(
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(
                                            CupertinoPageRoute<bool>(
                                              fullscreenDialog: true,
                                              builder: (BuildContext context) =>
                                                  userdata.type == "ShopKeeper"
                                                      ? shopDetailScreen(
                                                          data: userdata)
                                                      : doctoreDetail(
                                                          doctor: userdata),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.deepPurple
                                                        .withOpacity(0.1),
                                                    blurRadius: 10,
                                                    spreadRadius: 3)
                                              ]),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 35,
                                                backgroundColor: Colors.white,
                                                foregroundColor: Colors.white,
                                                backgroundImage: NetworkImage(
                                                  userdata.imagePath!,
                                                ),
                                              ),
                                              Expanded(
                                                  child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5, horizontal: 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${userdata.name}",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      maxLines: 2,
                                                    ),
                                                    Text(
                                                      userdata.email,
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                      maxLines: 1,
                                                    ),
                                                    Text(
                                                        "Register at ${DateFormat('dd MMM yyyy').format(userdata.register)}",
                                                        style: TextStyle(
                                                            fontSize: 15)),
                                                  ],
                                                ),
                                              )),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            elevation: 0,
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                            content: alertPopu(
                                                                formKey,
                                                                description,
                                                                context,
                                                                user: userdata),
                                                          );
                                                        });
                                                  },
                                                  style: ButtonStyle(
                                                      elevation:
                                                          MaterialStatePropertyAll(
                                                              0),
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              CupertinoColors
                                                                  .systemRed
                                                                  .withOpacity(
                                                                      0.5))),
                                                  child: Text("Reject",
                                                      style: TextStyle(
                                                          color: Colors.black)))
                                            ],
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink();
                              },
                            ),
                          )
                        : constWidget().circularProgressInd(nodatafound: true)
                    : constWidget().circularProgressInd(nodatafound: false);
              }),
        ),
      ],
    );
  }
}

class rejectedUsers extends StatefulWidget {
  const rejectedUsers({super.key});

  @override
  State<rejectedUsers> createState() => _rejectedUsersState();
}

class _rejectedUsersState extends State<rejectedUsers> {
  var formKey = GlobalKey<FormState>();
  TextEditingController description = TextEditingController();
  TextEditingController searcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.deepPurple.withOpacity(0.05)),
          child: TextFormField(
            controller: searcontroller,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              Future.delayed(Duration(seconds: 2), () => setState(() {}));
            },
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(top: 15, bottom: 15, left: 13, right: 2),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(
                      color: Colors.deepPurple.withOpacity(0.5), width: 2)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              hintText: "Search here...",
              hintStyle: TextStyle(
                  color: Colors.deepPurple.withOpacity(0.5),
                  fontSize: 17,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User")
                  .orderBy('register', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.connectionState == ConnectionState.active
                    ? snapshot.hasData
                        ? Container(
                            width: double.infinity,
                            height: double.infinity,
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.only(bottom: 80),
                              itemBuilder: (context, index) {
                                Map<String, dynamic> data =
                                    snapshot.data!.docs[index].data();
                                data.addAll({
                                  "reference":
                                      snapshot.data!.docs[index].reference
                                });
                                var userdata = UserModel.fromJson(data);
                                return userdata.type != "Admin" &&
                                        userdata.type != "User" &&
                                        userdata.approve == "Reject" &&
                                        (searcontroller.text.isEmpty ||
                                            (searcontroller.text.isNotEmpty &&
                                                userdata.name
                                                    .toUpperCase()
                                                    .contains(searcontroller
                                                        .text
                                                        .trim()
                                                        .toUpperCase())))
                                    ? InkWell(
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(
                                            CupertinoPageRoute<bool>(
                                              fullscreenDialog: true,
                                              builder: (BuildContext context) =>
                                                  userdata.type == "ShopKeeper"
                                                      ? shopDetailScreen(
                                                          data: userdata)
                                                      : doctoreDetail(
                                                          doctor: userdata),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.deepPurple
                                                        .withOpacity(0.1),
                                                    blurRadius: 10,
                                                    spreadRadius: 3)
                                              ]),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 35,
                                                backgroundColor: Colors.white,
                                                foregroundColor: Colors.white,
                                                backgroundImage: NetworkImage(
                                                  userdata.imagePath!,
                                                ),
                                              ),
                                              Expanded(
                                                  child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5, horizontal: 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${userdata.name}",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      maxLines: 2,
                                                    ),
                                                    Text(
                                                      userdata.email,
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                      maxLines: 1,
                                                    ),
                                                    Text(
                                                      "Reason: ${userdata.cancelReason!}",
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                        "Register at ${DateFormat('dd MMM yyyy').format(userdata.register)}",
                                                        style: TextStyle(
                                                            fontSize: 15)),
                                                  ],
                                                ),
                                              )),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    userdata.reference.update({
                                                      "approve": "Accepted"
                                                    });
                                                  },
                                                  style: ButtonStyle(
                                                      elevation:
                                                          MaterialStatePropertyAll(
                                                              0),
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              CupertinoColors
                                                                  .systemGreen
                                                                  .withOpacity(
                                                                      0.5))),
                                                  child: Text("Accept",
                                                      style: TextStyle(
                                                          color: Colors.black)))
                                            ],
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink();
                              },
                            ),
                          )
                        : constWidget().circularProgressInd(nodatafound: true)
                    : constWidget().circularProgressInd(nodatafound: false);
              }),
        ),
      ],
    );
  }
}
