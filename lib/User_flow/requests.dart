import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geomed_assist/Firebase/firebaseAuthentications.dart';
import 'package:geomed_assist/Firebase/firebase_quaries.dart';
import 'package:geomed_assist/Models/ProductRequest.dart';
import 'package:geomed_assist/Models/product.dart';
import 'package:geomed_assist/Models/user_model.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:intl/intl.dart';

class requests extends StatefulWidget {
  const requests({super.key});

  @override
  State<requests> createState() => _requestsState();
}

class _requestsState extends State<requests> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: constWidget().appbar(context, Name: "Request", backbutton: true),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("ProductRequest").where(currentUserDocument!.type == "ShopKeeper"? "shopReference": "userReference",isEqualTo:currentUserDocument!.reference) .orderBy("time",descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<ProductRequest> maindata = [];
                for (var doc in snapshot.data!.docs) {
                  Map<String, dynamic> docdata = doc.data();
                  docdata.addAll({"refereance":doc.reference});
                  maindata
                      .add(ProductRequest.fromJson(docdata));
                }
                return ListView.separated(
                  separatorBuilder: (context, index) => Divider(color: AppColor.greycolor,thickness: 2,height: 0,),
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: maindata!.length,
                    itemBuilder: (context, index) {
                      var data = maindata[index];
                      return StreamBuilder<UserModel?>(
                          stream: Firebase_Quires()
                              .getuserInfo(refId: data.userReference),
                          builder: (context, snapshot2) {
                            if (snapshot2.hasData) {
                              var userinfo = snapshot2.data;
                              return Container(
                                padding: EdgeInsets.only(left: 25,right: 25,top: 15,bottom: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SingleChildScrollView(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 55,
                                            height: 55,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Image.network(userinfo!.imagePath!,fit: BoxFit.cover),
                                          ),
                                          SizedBox(width: 15),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: width*0.52,
                                                    child: Text(userinfo.name,
                                                        style: TextStyle(
                                                            color: AppColor.textColor,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w400)),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(100),
                                                      color: data.status == "Pending"
                                                          ? CupertinoColors.systemGrey
                                                          : data.status == "Accept"
                                                          ? CupertinoColors.activeGreen
                                                          : CupertinoColors.systemRed,
                                                    ),
                                      
                                                    child: Text(data.status,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w500)),
                                                  ),
                                                ],
                                              ),
                                              StreamBuilder(
                                                stream: data.productReference.snapshots(),
                                                builder: (context, snapshot) {
                                                  return Text(snapshot.hasData ?"Product: ${snapshot.data!.get('name')}":'',
                                                      style: TextStyle(
                                                          color: AppColor.textColor,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w400));
                                                }
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: width * 0.68,
                                          child: Text(data.description,
                                              style: TextStyle(
                                                  color: AppColor.greycolor,
                                                  fontSize: 13),
                                              maxLines: 2),
                                        ),
                                        Text(
                                          DateFormat('dd MMM yyyy')
                                              .format(data.time) !=
                                              DateFormat('dd MMM yyyy')
                                                  .format(
                                                  DateTime.now())
                                              ? DateFormat('dd MMM yyyy')
                                              .format(data.time)
                                              : DateFormat('h:mm a')
                                              .format(data.time),
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: AppColor.greycolor,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                    currentUserDocument!.type == "ShopKeeper"
                                        ? Row(
                                      children: [
                                        SizedBox(height: 5),
                                        Expanded(
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStatePropertyAll(AppColor.backgroundColor),
                                                shape: MaterialStatePropertyAll(
                                                    RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            color: Colors.green
                                                        ),
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            10))),
                                              ),
                                              onPressed: () async {
                                                await data.reference.update({"status":"Accept"});
                                                setState(() {
                                                });
                                              },
                                              child: Text("ACCEPT",
                                                  style: TextStyle(
                                                      color: AppColor
                                                          .textColor,
                                                      fontSize: 18))),
                                        ),
                                        SizedBox(width: 15),
                                        Expanded(
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStatePropertyAll(AppColor.backgroundColor),
                                                shape: MaterialStatePropertyAll(
                                                    RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            color: Colors.red
                                                        ),
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            10))),
                                              ),
                                              onPressed: () async {
                                                await data.reference.update({"status":"Reject"});
                                                setState(() {
                                                });
                                              },
                                              child: Text("REJECT",
                                                  style: TextStyle(
                                                      color: AppColor
                                                          .textColor,
                                                      fontSize: 18))),
                                        ),
                                      ],
                                    )
                                        : SizedBox.shrink()
                                  ],
                                ),
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          });
                    });
              } else {
                return Center(
                  child: constWidget().circularProgressInd(nodatafound: true),
                );
              }
            } else {
              return Center(
                child: constWidget().circularProgressInd(nodatafound: false),
              );
            }
          }),
    );
  }
}
