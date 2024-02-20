import 'package:geomed_assist/Firebase/firebaseAuthentications.dart';
import 'package:geomed_assist/User_flow/favorites.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Firebase/firebase_quaries.dart';
import 'package:geomed_assist/Models/product.dart';
import 'package:geomed_assist/Models/rateModel.dart';
import 'package:geomed_assist/Models/user_model.dart';
import 'package:geomed_assist/User_flow/HomePage.dart';
import 'package:geomed_assist/User_flow/message.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:geomed_assist/constants/dataFile.dart';
import 'package:geomed_assist/constants/rattingBar.dart';
import 'package:geomed_assist/productDetail.dart';
import 'package:hive/hive.dart';

class shopDetailScreen extends StatefulWidget {
  final UserModel data;

  const shopDetailScreen({super.key, required this.data});

  @override
  State<shopDetailScreen> createState() => _shopDetailScreenState();
}

class _shopDetailScreenState extends State<shopDetailScreen> {
  PageController pgcontrolles = PageController(initialPage: 0);
  bool isload = false;
  List page = [];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: constWidget()
          .appbar(context, Name: widget.data.name, backbutton: true),
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
                      image: NetworkImage(widget.data.imagePath!),
                      fit: BoxFit.cover,
                    )),
              ),
              SizedBox(height: 10),
              Text(
                widget.data.name,
                style: TextStyle(
                    color: AppColor.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<UserModel?>(
                          stream: Firebase_Quires().getuserInfo(refId: widget.data.reference),
                          builder: (context, snapshot) {
                            return rattingBar(
                                tapOnly: true,
                                initValue: (snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.waiting) && snapshot.hasData ? (snapshot.data!.rate! /snapshot.data!.ratedUser!):0,
                                size: 25);
                          }
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on_outlined,
                              color: AppColor.primaryColor, size: 25),
                          SizedBox(
                            width: width*0.63,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.data.address,
                                    style:
                                    TextStyle(color: AppColor.greycolor, fontSize: 15)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding:  EdgeInsets.all(5.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              onTap: () async {
                                setState(() {
                                  isload = true;
                                });
                                var chatRef = await FirebaseFirestore.instance
                                    .collection("chat")
                                    .where("user", isEqualTo: currentUserDocument!.reference)
                                    .where("otherUser", isEqualTo: widget.data.reference)
                                    .get();
                                var chatrefereance2;
                                if(chatRef.docs.length != 0){
                                  chatrefereance2 = chatRef.docs.first.reference;
                                }else{
                                  Map<String, dynamic> mapdata = {
                                    "user" : currentUserDocument!.reference,
                                    "otherUser" : widget.data.reference,
                                    "messageList" : [],
                                    "userMessageList":[]
                                  };
                                  await FirebaseFirestore.instance
                                      .collection("chat").doc().set(mapdata);
                                  var chatRef2 = await FirebaseFirestore.instance
                                      .collection("chat")
                                      .where("user", isEqualTo: currentUserDocument!.reference)
                                      .where("otherUser", isEqualTo: widget.data.reference)
                                      .get();
                                  chatrefereance2 = chatRef2.docs.first.reference;
                                }
                                setState(() {
                                  isload = false;
                                });
                                Navigator.of(context, rootNavigator: true).push(
                                  CupertinoPageRoute<bool>(
                                    fullscreenDialog: true,
                                    builder: (BuildContext context) => messageScreen(chatrefe: chatrefereance2,user: widget.data),
                                  ),
                                );
                              },
                              child: !isload ? Icon(CupertinoIcons.chat_bubble,
                                  size: 30, color: AppColor.primaryColor):
                              constWidget().circularProgressInd(nodatafound: false),
                            ),
                          ),
                          Favorites(reference: widget.data.reference, action: () => setState(() {})),
                        ],
                      ),
                      Text(
                          "${calculateDistance(currentUserDocument!.latLong, currentUserDocument!.longitude, widget.data.latLong, widget.data.longitude)} mile",
                          style: TextStyle(
                              color: AppColor.greycolor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500))
                    ],
                  ),


                ],
              ),
              SizedBox(height: 5),
              Text("contact Number: ${widget.data.contact}",
                  style: TextStyle(color: AppColor.textColor, fontSize: 13)),
              Text(
                  "Working time: ${widget.data.startTime} to ${widget.data.endTime}",
                  style: TextStyle(color: AppColor.textColor, fontSize: 13)),
              SizedBox(height: 5),
              Text(widget.data.aboutUs!,
                  style: TextStyle(color: AppColor.textColor, fontSize: 13)),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          pgcontrolles.jumpToPage(0);
                        });
                      },
                      child: Text(
                        "Products",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          pgcontrolles.jumpToPage(1);
                        });
                      },
                      child: Text("Rates",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
              Divider(thickness: 2, color: AppColor.greycolor.withOpacity(0.5)),
              Container(
                height: MediaQuery.of(context).size.height * 0.83,
                child: PageView.builder(
                  itemCount: 2,
                  scrollDirection: Axis.horizontal,
                  controller: pgcontrolles,
                  itemBuilder: (context, index) {
                    return index == 0
                        ? productsPage(refShopkeeper: widget.data.reference)
                        : rattibgPage(refShopkeeper: widget.data.reference,rate: widget.data.rate!,rateUsers: widget.data.ratedUser!);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class productsPage extends StatefulWidget {
  final DocumentReference refShopkeeper;

  const productsPage({super.key, required this.refShopkeeper});

  @override
  State<productsPage> createState() => _productsPageState();
}

class _productsPageState extends State<productsPage> {
  TextEditingController serachingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20,bottom: 20,left: 5,right: 5),
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
              Future.delayed(Duration(seconds: 3),() => setState(() {}));
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
        StreamBuilder<ProductList?>(
            stream: Firebase_Quires().getProductDocuments(
                shopRef: widget.refShopkeeper, available: true,forCategories: false),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data!.products.length != 0) {
                  var maindata = serachingController.text.trim().length != 0 ?
                      snapshot.data!.products.where((element) {
                         return (element.name.toUpperCase().contains(serachingController.text.toUpperCase())) ||
                             (element.category.toUpperCase().contains(serachingController.text.toUpperCase())) ||
                             (element.price.toString().contains(serachingController.text.toUpperCase())) ||
                             (serachingController.text.toUpperCase().contains("AVAILABLE") && element.available);
                      }).toList()
                      : snapshot.data!.products;
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: maindata.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.66),
                      itemBuilder: (context, index) {
                        var data = maindata[index];
                        return InkWell(
                          onTap: () {
                            showBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        topRight: Radius.circular(50))),
                                builder: (context2) {
                                  return productDetail(data: data);
                                });
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 5, left: 5, top: 5),
                            padding: EdgeInsets.only(bottom: 5),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: AppColor.backgroundColor,
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset:
                                      Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.network(data.image,
                                    height: width * 0.3,
                                    fit: BoxFit.cover,
                                    width: double.infinity),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(data.name,
                                      style: TextStyle(
                                          color: AppColor.textColor,
                                          fontSize: 16),
                                      maxLines: 2),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text("Category: ${data.category}",
                                      style: TextStyle(
                                          color: AppColor.greycolor,
                                          fontSize: 13),
                                      maxLines: 2),
                                ),

                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text("Price: ${data.price}\$",
                                      style: TextStyle(
                                          color: AppColor.greycolor,
                                          fontSize: 13),
                                      maxLines: 2),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        margin: EdgeInsets.only(right: 5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: data.available ? Colors.green : Colors.red
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(data.available ? "Available" : "Not Available",
                                              style: TextStyle(
                                                  color: data.available ? Colors.green : Colors.red,
                                                  fontSize: 13),
                                              maxLines: 2),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
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
      ],
    );
  }
}

class rattibgPage extends StatefulWidget {
  final DocumentReference refShopkeeper;
  final double rate;
  final int rateUsers;

  const rattibgPage({super.key, required this.refShopkeeper, required this.rate, required this.rateUsers});

  @override
  State<rattibgPage> createState() => _rattibgPageState();
}

class _rattibgPageState extends State<rattibgPage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: Column(
        children: [
          ElevatedButton(
              style: ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(Size(width, 45)),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
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
                      content:
                          RattingPopUp(refShopkeeper: widget.refShopkeeper,rate: widget.rate,rateUsers: widget.rateUsers),
                    );
                  },
                );
              },
              child: Text("Ratting",
                  style: TextStyle(color: AppColor.textColor, fontSize: 18))),
          Expanded(
            child: StreamBuilder<RateList?>(
                stream: Firebase_Quires()
                    .getRateDocuments(shopRef: widget.refShopkeeper),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData && snapshot.data!.rate.length != 0) {
                      var maindata = snapshot.data!.rate;
                      return ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                              color: AppColor.greycolor.withOpacity(0.5),
                              height: 0,
                              thickness: 2),
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: maindata.length,
                          itemBuilder: (context, index) {
                            var data = maindata[index];
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
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
                                              color: AppColor.textColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400)),
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
                                              MainAxisAlignment.spaceBetween,
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
                                                  color: AppColor.greycolor,
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

class RattingPopUp extends StatefulWidget {
  final DocumentReference refShopkeeper;
  final double rate;
  final int rateUsers;

  const RattingPopUp({Key? key, required this.refShopkeeper, required this.rate, required this.rateUsers}) : super(key: key);

  @override
  State<RattingPopUp> createState() => _RattingPopUpState();
}

class _RattingPopUpState extends State<RattingPopUp> {
  TextEditingController rattingMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
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
                  'userReference': widget.refShopkeeper,
                };
                widget.refShopkeeper.update({'rate':(widget.rate + ratebarValue),'ratedUser':(widget.rateUsers + 1)});
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
