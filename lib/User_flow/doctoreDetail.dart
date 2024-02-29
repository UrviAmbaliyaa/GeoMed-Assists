import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Firebase/firebase_quaries.dart';
import 'package:geomed_assist/Models/rateModel.dart';
import 'package:geomed_assist/Models/user_model.dart';
import 'package:geomed_assist/User_flow/HomePage.dart';
import 'package:geomed_assist/User_flow/doctorSlot.dart';
import 'package:geomed_assist/User_flow/favorites.dart';
import 'package:geomed_assist/User_flow/message.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:geomed_assist/constants/dataFile.dart';
import 'package:geomed_assist/constants/rattingBar.dart';
import 'package:intl/intl.dart';

class doctoreDetail extends StatefulWidget {
  final UserModel doctor;

  const doctoreDetail({super.key, required this.doctor});

  @override
  State<doctoreDetail> createState() => _doctoreDetailState();
}

class _doctoreDetailState extends State<doctoreDetail> {
  bool isload = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: currentUserDocument!.type == "Admin"
          ? Colors.white
          : AppColor.backgroundColor,
      appBar: constWidget()
          .appbar(context, Name: widget.doctor.name, backbutton: true),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: width * 0.6,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(widget.doctor.imagePath!),
                      fit: BoxFit.cover,
                    )),
              ),
              SizedBox(height: 10),
              Text(
                widget.doctor.name,
                style: TextStyle(
                    color: currentUserDocument!.type == "Admin"
                        ? Colors.black
                        : AppColor.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5),
              StreamBuilder<UserModel?>(
                  stream: Firebase_Quires()
                      .getuserInfo(refId: widget.doctor.reference),
                  builder: (context, snapshot) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        rattingBar(
                            tapOnly: true,
                            initValue: (snapshot.connectionState ==
                                            ConnectionState.done ||
                                        snapshot.connectionState ==
                                            ConnectionState.waiting) &&
                                    snapshot.hasData
                                ? (snapshot.data!.rate! /
                                    snapshot.data!.ratedUser!)
                                : 0,
                            size: 25),
                        Text(
                            "${calculateDistance(currentUserDocument!.latLong, currentUserDocument!.longitude, widget.doctor.latLong, widget.doctor.longitude)} mile",
                            style: TextStyle(
                                color: AppColor.greycolor,
                                fontSize: 13,
                                fontWeight: FontWeight.w500))
                      ],
                    );
                  }),
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      color: AppColor.primaryColor, size: 25),
                  Expanded(
                    child: Text(widget.doctor.address!,
                        style:
                            TextStyle(color: AppColor.greycolor, fontSize: 15)),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () async {
                      setState(() {
                        isload = true;
                      });
                      var chatRef = await FirebaseFirestore.instance
                          .collection("chat")
                          .where("user",
                              isEqualTo: currentUserDocument!.reference)
                          .where("otherUser",
                              isEqualTo: widget.doctor.reference)
                          .get();
                      var chatrefereance2;
                      if (chatRef.docs.length != 0) {
                        chatrefereance2 = chatRef.docs.first.reference;
                      } else {
                        Map<String, dynamic> mapdata = {
                          "user": currentUserDocument!.reference,
                          "otherUser": widget.doctor.reference,
                          "messageList": [],
                          "userMessageList": []
                        };
                        await FirebaseFirestore.instance
                            .collection("chat")
                            .doc()
                            .set(mapdata);
                        var chatRef2 = await FirebaseFirestore.instance
                            .collection("chat")
                            .where("user",
                                isEqualTo: currentUserDocument!.reference)
                            .where("otherUser",
                                isEqualTo: widget.doctor.reference)
                            .get();
                        chatrefereance2 = chatRef2.docs.first.reference;
                      }
                      setState(() {
                        isload = false;
                      });
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute<bool>(
                          fullscreenDialog: true,
                          builder: (BuildContext context) => messageScreen(
                              chatrefe: chatrefereance2, user: widget.doctor),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        !isload
                            ? Icon(CupertinoIcons.chat_bubble,
                                size: 30, color: AppColor.primaryColor)
                            : constWidget()
                                .circularProgressInd(nodatafound: false),
                      ],
                    ),
                  ),
                  Favorites(
                      reference: widget.doctor.reference,
                      action: () => setState(() {})),
                ],
              ),
              SizedBox(height: 10),
              Text("contact Number: ${widget.doctor.contact}",
                  style: TextStyle(
                      color: currentUserDocument!.type == "Admin"
                          ? Colors.black
                          : AppColor.textColor,
                      fontSize: 13)),
              Text("Education: ${widget.doctor.degree}",
                  style: TextStyle(
                      color: currentUserDocument!.type == "Admin"
                          ? Colors.black
                          : AppColor.textColor,
                      fontSize: 13)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "Working : ${widget.doctor.startTime} to ${widget.doctor.endTime}",
                      style: TextStyle(
                          color: currentUserDocument!.type == "Admin"
                              ? Colors.black
                              : AppColor.textColor,
                          fontSize: 13)),
                  widget.doctor.availableSlot!.length != 0
                      ? InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  contentPadding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  content: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      width: width,
                                      child: doctorSlot(doctor: widget.doctor)),
                                );
                              },
                            );
                          },
                          child: Text("Working Slot",
                              style: TextStyle(
                                  color: AppColor.primaryColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColor.primaryColor)),
                        )
                      : SizedBox.shrink(),
                ],
              ),
              SizedBox(height: 5),
              Text(widget.doctor.aboutUs!,
                  style: TextStyle(
                      color: currentUserDocument!.type == "Admin"
                          ? Colors.black
                          : AppColor.textColor,
                      fontSize: 13)),
              SizedBox(height: 10),
              currentUserDocument!.approve == "approve"
                  ? ElevatedButton(
                      style: ButtonStyle(
                          minimumSize:
                              MaterialStatePropertyAll(Size(width, 45)),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          backgroundColor:
                              MaterialStatePropertyAll(AppColor.primaryColor)),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              contentPadding: EdgeInsets.zero,
                              content: RattingPopUp(
                                  refDoctor: widget.doctor.reference,
                                  rate: widget.doctor.rate!,
                                  rateUsers: widget.doctor.ratedUser!),
                            );
                          },
                        );
                      },
                      child: Text("Ratting",
                          style: TextStyle(
                              color: currentUserDocument!.type == "Admin"
                                  ? Colors.black
                                  : AppColor.textColor,
                              fontSize: 18)))
                  : SizedBox.shrink(),
              currentUserDocument!.approve == "approve"
                  ? StreamBuilder<RateList?>(
                      stream: Firebase_Quires()
                          .getRateDocuments(shopRef: widget.doctor.reference),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.active ||
                            snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData &&
                              snapshot.data!.rate!.length != 0) {
                            var maindata = snapshot.data!.rate!;
                            return ListView.separated(
                                separatorBuilder: (context, index) => Divider(
                                    color: AppColor.greycolor.withOpacity(0.5),
                                    height: 0,
                                    thickness: 2),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: maindata.length,
                                itemBuilder: (context, index) {
                                  var data = maindata[index];
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 15),
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
                                                BorderRadius.circular(100),
                                          ),
                                          child: Image.network(data.image,
                                              fit: BoxFit.cover),
                                        ),
                                        SizedBox(width: 15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(data.name,
                                                style: TextStyle(
                                                    color: currentUserDocument!
                                                                .type ==
                                                            "Admin"
                                                        ? Colors.black
                                                        : AppColor.textColor,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            SizedBox(
                                              width: width * 0.75,
                                              child: Text(data.description,
                                                  style: TextStyle(
                                                      color: AppColor.greycolor,
                                                      fontSize: 14),
                                                  maxLines: 2),
                                            ),
                                            SizedBox(
                                              width: width * 0.75,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  rattingBar(
                                                      tapOnly: true,
                                                      initValue: data.rate),
                                                  Text(
                                                    DateFormat('dd MMM yyyy')
                                                        .format(data.date),
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                        color:
                                                            AppColor.greycolor,
                                                        fontSize: 13),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
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
                            child: constWidget()
                                .circularProgressInd(nodatafound: false),
                          );
                        }
                      })
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

class RattingPopUp extends StatefulWidget {
  final DocumentReference refDoctor;
  final double rate;
  final int rateUsers;

  const RattingPopUp(
      {Key? key,
      required this.refDoctor,
      required this.rate,
      required this.rateUsers})
      : super(key: key);

  @override
  State<RattingPopUp> createState() => _RattingPopUpState();
}

class _RattingPopUpState extends State<RattingPopUp> {
  TextEditingController rattingMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    print("widget.rate ----->${widget.rate}");
    print("widget.rate ----->${widget.refDoctor}");
    return Container(
      width: width,
      height: 275,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          rattingBar(tapOnly: false, initValue: 0, size: 50),
          SizedBox(height: 10),
          TextFormField(
            controller: rattingMessage,
            keyboardType: TextInputType.multiline,
            cursorColor: AppColor.primaryColor,
            maxLines: 4,
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 13, left: 13, right: 2),
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
              hintText: "Enter your message here..",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size(width, 45)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(AppColor.primaryColor),
            ),
            onPressed: () async {
              if (ratebarValue != 0) {
                var mapdata = {
                  'image': currentUserDocument!.imagePath,
                  'name': currentUserDocument!.name,
                  'rate': ratebarValue,
                  'description': rattingMessage.text,
                  'date': DateTime.now(),
                  'userReference': widget.refDoctor,
                };
                widget.refDoctor.update({
                  'rate': (widget.rate + ratebarValue),
                  'ratedUser': (widget.rateUsers + 1)
                });
                FirebaseFirestore.instance
                    .collection("rate")
                    .doc()
                    .set(mapdata);

                rattingMessage.clear();
                ratebarValue = 0;
              }
              Navigator.pop(context);
            },
            child: Text(
              "Submit",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
