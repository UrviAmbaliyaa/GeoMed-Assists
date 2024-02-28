import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Admin_Panel/privacyPolicy_add.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';

class privacy_Policy extends StatefulWidget {
  const privacy_Policy({super.key});

  @override
  State<privacy_Policy> createState() => _privacy_PolicyState();
}

class _privacy_PolicyState extends State<privacy_Policy> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        primary: true,
        leadingWidth: 70,
        automaticallyImplyLeading: false,
        leading: Align(
          child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child:
                  Icon(Icons.arrow_back, color: AppColor.textColor, size: 30)),
        ),
        centerTitle: true,
        actions: [
          currentUserDocument!.type == "Admin"
              ? CupertinoButton(
                  child: Stack(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        margin: EdgeInsets.only(top: 5, right: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.6),
                                width: 2)),
                      ),
                      Container(
                          width: 25,
                          height: 25,
                          alignment: Alignment.topRight,
                          child:
                              Icon(Icons.edit, size: 20, color: Colors.white)),
                    ],
                  ),
                  onPressed: () async {
                    var doc = await FirebaseFirestore.instance
                        .collection("privacy_policy")
                        .get();
                    Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute<bool>(
                        fullscreenDialog: true,
                        builder: (BuildContext context) => privacy_policy_add(
                            edit: true,
                            policy: doc.docs.length != 0
                                ? doc.docs[0]['privacy_policy']
                                : null,
                            reference: doc.docs.length != 0 ? doc.docs[0].reference: null),
                      ),
                    );
                  },
                )
              : SizedBox.shrink()
        ],
        title: Text(
          "Privacy Policy",
          style: TextStyle(
              color: AppColor.textColor,
              fontSize: 18,
              fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
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
                height: width * 0.4,
                alignment: Alignment.bottomCenter,
                child: Image.asset("assets/logo/Logo.png", color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "Privacy Policy",
                style: TextStyle(
                    color: AppColor.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("privacy_policy")
                      .snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.connectionState == ConnectionState.active
                        ? snapshot.hasData && snapshot.data!.docs.length != 0
                            ? Text(snapshot.data!.docs[0]['privacy_policy'],
                                style: TextStyle(
                                    color: AppColor.textColor, fontSize: 13))
                            : Container(
                                height: MediaQuery.of(context).size.height / 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: constWidget().circularProgressInd(
                                          nodatafound: true),
                                    ),
                                  ],
                                ),
                              )
                        : Center(
                            child: constWidget()
                                .circularProgressInd(nodatafound: false),
                          );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
