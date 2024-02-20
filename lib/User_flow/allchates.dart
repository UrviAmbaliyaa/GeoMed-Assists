import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Firebase/firebase_quaries.dart';
import 'package:geomed_assist/Models/ChatModel.dart';
import 'package:geomed_assist/Models/user_model.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:geomed_assist/constants/dataFile.dart';
import 'package:geomed_assist/constants/rattingBar.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'message.dart';

class allChates extends StatefulWidget {
  const allChates({super.key});

  @override
  State<allChates> createState() => _allChatesState();
}

class _allChatesState extends State<allChates> {
  TextEditingController serachingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: constWidget().appbar(context, Name: "Chat", backbutton: false),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(right: 20, left: 20, top: 5, bottom: 17),
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
                setState(() {});
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
          Expanded(
            child: StreamBuilder<List<ChatModel>?>(
                stream: Firebase_Quires().getchatList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData && snapshot.data!.length != 0) {
                      var mainadata = snapshot.data;
                      return ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                              color: AppColor.greycolor.withOpacity(0.5),
                              height: 0,
                              thickness: 2),
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: mainadata!.length,
                          itemBuilder: (context, index) {
                            var visible = true;
                            var data = mainadata[index];
                            return Visibility(
                              visible: visible,
                              child: StreamBuilder<UserModel?>(
                                  stream: Firebase_Quires().getuserInfo(
                                      refId: currentUserDocument!.type != "User"
                                          ? data.user
                                          : data.otherUser),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.active ||
                                        snapshot.connectionState ==
                                            ConnectionState.done) {
                                      var userdata = snapshot.data;
                                      return Container(
                                        margin: EdgeInsets.only(left: 20),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        child: InkWell(
                                          onTap: () => Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(
                                            CupertinoPageRoute<bool>(
                                              fullscreenDialog: true,
                                              builder: (BuildContext context) =>
                                                   messageScreen(chatrefe: data.reference,user: userdata),
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 45,
                                                height: 45,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                child: Image.network(
                                                    userdata!.imagePath!,
                                                    fit: BoxFit.cover),
                                              ),
                                              SizedBox(width: 15),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(userdata.name,
                                                      style: TextStyle(
                                                          color: AppColor
                                                              .textColor,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  SizedBox(
                                                    width: width * 0.64,
                                                    child: Text(
                                                        "${data.lastMessageSender == currentUserDocument!.reference ? "You:" : "${userdata.name}:"} ${data.lastMessage}",
                                                        style: TextStyle(
                                                            color: AppColor
                                                                .greycolor,
                                                            fontSize: 14),
                                                        maxLines: 2),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                     await data.reference.update({"${currentUserDocument!.type == "User" ? "userMessageList" : "messageList"}":[]});
                                                     setState(() {
                                                     });
                                                    },
                                                      child: Icon(Icons.delete,size: 25,color: Colors.red)
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    DateFormat('dd MMM yyyy')
                                                                .format(data
                                                                    .lastMessageTime!) !=
                                                            DateFormat(
                                                                    'dd MMM yyyy')
                                                                .format(
                                                                    DateTime.now())
                                                        ? DateFormat('dd MMM yyyy')
                                                            .format(data
                                                                .lastMessageTime!)
                                                        : DateFormat('h:mm a')
                                                            .format(data
                                                        .lastMessageTime!),
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                        color: AppColor.greycolor,
                                                        fontSize: 13),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  }),
                            );
                          });
                    } else {
                      return Center(
                        child: constWidget()
                            .circularProgressInd(nodatafound: true),
                      );
                    }
                  } else {
                    return Center(
                      child:
                          constWidget().circularProgressInd(nodatafound: false),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
