import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Firebase/firebase_quaries.dart';
import 'package:geomed_assist/Models/user_model.dart';
import 'package:geomed_assist/User_flow/HomePage.dart';
import 'package:geomed_assist/User_flow/doctoreDetail.dart';
import 'package:geomed_assist/User_flow/favorites.dart';
import 'package:geomed_assist/User_flow/shopDetailScreen.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:geomed_assist/constants/dataFile.dart';
import 'package:geomed_assist/constants/rattingBar.dart';

class favorits extends StatefulWidget {
  const favorits({super.key});

  @override
  State<favorits> createState() => _favoritsState();
}

class _favoritsState extends State<favorits> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColor.backgroundColor,
          elevation: 0,
          primary: true,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "Favorite",
            style: TextStyle(
                color: AppColor.textColor,
                fontSize: 23,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          bottom: TabBar(
            indicatorColor: AppColor.textColor,
            indicatorWeight: 2,
            automaticIndicatorColorAdjustment: true,
            dividerColor: AppColor.greycolor,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: TextStyle(color: AppColor.textColor, fontSize: 20),
            tabs: [
              Tab(text: 'Shops'),
              Tab(text: 'Doctor'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            favoriteShopes(),
            favoriteDoctor(),
          ],
        ),
      ),
    );
  }
}

class favoriteShopes extends StatefulWidget {
  const favoriteShopes({super.key});

  @override
  State<favoriteShopes> createState() => _favoriteShopesState();
}

class _favoriteShopesState extends State<favoriteShopes> {
  List favorite = [];

  Future<List<UserModel>> dataFavoriteShopes(maindata) async {
    List<UserModel> userdata = [];
    for (var doc in maindata.favoriteReference!) {
      var value = await doc.get();
      if (value.data() != null) {
        Map<String, dynamic> data = value.data() as Map<String, dynamic>;
        data.addAll({'reference': value.reference});
        var docdata = UserModel.fromJson(data);
        docdata.type == "ShopKeeper" && docdata.approve == "Accepted"
            ? userdata.add(docdata)
            : null;
      }
    }
    return userdata;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder(
          stream: currentUserDocument!.reference.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData &&
                  snapshot.data!.get('favoriteReference') != null) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                data.addAll({'reference': snapshot.data!.reference});
                var maindata = UserModel.fromJson(data);
                return FutureBuilder<List<UserModel>>(
                  future: dataFavoriteShopes(maindata),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var userdata = snapshot.data;
                      return GridView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: userdata!.length,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  childAspectRatio: 0.77),
                          itemBuilder: (context, index) {
                            var data = userdata[index];
                            return Stack(
                              alignment: Alignment.topRight,
                              children: [
                                InkWell(
                                  splashColor: Colors.transparent,
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
                                    child: SingleChildScrollView(
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(data.name,
                                                    style: TextStyle(
                                                        color: AppColor.textColor,
                                                        fontSize: 14),
                                                    maxLines: 2),
                                                Text(data.address!,
                                                    style: TextStyle(
                                                        color: AppColor.greycolor,
                                                        fontSize: 13),
                                                    maxLines: 2),
                                                Row(
                                                  children: [
                                                    rattingBar(
                                                        tapOnly: true,
                                                        initValue: 2.5),
                                                    Expanded(
                                                      child: Text(
                                                          "${calculateDistance(currentUserDocument!.latLong, currentUserDocument!.longitude, data.latLong, data.longitude)} mile",
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: TextStyle(
                                                              color: AppColor
                                                                  .greycolor,
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
                                  ),
                                ),
                                Favorites(
                                    reference: data.reference,
                                    action: () => setState(() {})),
                              ],
                            );
                          });
                    } else {
                      return Center(
                        child: constWidget()
                            .circularProgressInd(nodatafound: false),
                      );
                    }
                  },
                );
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

class favoriteDoctor extends StatefulWidget {
  const favoriteDoctor({super.key});

  @override
  State<favoriteDoctor> createState() => _favoriteDoctorState();
}

class _favoriteDoctorState extends State<favoriteDoctor> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder(
          stream: currentUserDocument!.reference.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data != null) {
                Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
                data.addAll({'reference': snapshot.data!.reference});
                var maindata = UserModel.fromJson(data);
                return ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: maindata.favoriteReference!.length,
                    itemBuilder: (context, index) {
                      var data = maindata.favoriteReference![index];
                        return StreamBuilder(
                          stream: data.snapshots(),
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              Map<String, dynamic> data1 =
                              snapshot.data!.data() as Map<String, dynamic>;
                              data1.addAll({'reference': snapshot.data!.reference});
                              var data = UserModel.fromJson(data1);
                              return Visibility(
                                visible: data.type == "Doctore",
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () =>
                                      Navigator.of(context, rootNavigator: true).push(
                                        CupertinoPageRoute<bool>(
                                          fullscreenDialog: true,
                                          builder: (BuildContext context) =>
                                              doctoreDetail(doctor: data),
                                        ),
                                      ),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: 10, left: 20, bottom: 10, right: 20),
                                    padding:
                                    EdgeInsets.only(top: 10, left: 10, bottom: 10),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: AppColor.backgroundColor,
                                      borderRadius: BorderRadius.circular(50),
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
                                    child: SingleChildScrollView(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage:
                                            NetworkImage(data.imagePath!),
                                            radius: 35,
                                          ),
                                          SizedBox(width: 15),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(data.name,
                                                  style: TextStyle(
                                                      color: AppColor.textColor,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w400)),
                                              SizedBox(
                                                width: width * 0.54,
                                                child: Text(data.address!,
                                                    style: TextStyle(
                                                        color: AppColor.greycolor,
                                                        fontSize: 13),
                                                    maxLines: 2),
                                              ),
                                              SizedBox(
                                                width: width * 0.54,
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    rattingBar(
                                                        tapOnly: true, initValue: 2.5),
                                                    Text(
                                                        "${calculateDistance(currentUserDocument!.latLong, currentUserDocument!.longitude, data.latLong, data.longitude)} mile",
                                                        textAlign: TextAlign.end,
                                                        style: TextStyle(
                                                            color: AppColor.greycolor,
                                                            fontSize: 13),
                                                        maxLines: 2),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Favorites(
                                              reference: data.reference,
                                              action: () => setState(() {})),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }else {
                              return SizedBox.shrink();
                            }
                          }
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
    );
  }
}
