import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/User_flow/HomePage.dart';
import 'package:geomed_assist/User_flow/doctoreDetail.dart';
import 'package:geomed_assist/User_flow/shopDetailScreen.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var favorites = Datas().shopes.where((element) => favoriteItems.contains(element['name'])).toList();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: favorites.length,
                padding: EdgeInsets.only(left: 20, right: 20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.77),
                itemBuilder: (context, index) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      InkWell(
                        onTap: () =>
                            Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute<bool>(
                                fullscreenDialog: true,
                                builder: (BuildContext context) =>
                                new shopDetailScreen(index: index),
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
                                offset:
                                Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(favorites[index]['image'],
                                  height: width * 0.28,
                                  fit: BoxFit.cover,
                                  width: double.infinity),
                              Padding(
                                padding:
                                EdgeInsets.only(top: 6, left: 6, right: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(favorites[index]['name'],
                                        style: TextStyle(
                                            color: AppColor.textColor,
                                            fontSize: 14),
                                        maxLines: 2),
                                    Text(
                                        "Simada Naka, Shiv Darshan Society, Yoginagar Society, Surat, Gujarat 395006",
                                        style: TextStyle(
                                            color: AppColor.greycolor,
                                            fontSize: 13),
                                        maxLines: 2),
                                    Row(
                                      children: [
                                        rattingBar(
                                            tapOnly: true, initValue: 2.5),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              favoriteItems
                                  .remove(favorites[index]['name']);
                            });
                          },
                          child: Icon(
                            Icons.favorite,
                            size: 28,
                            color: AppColor.backgroundColor,
                          ),
                        ),
                      )
                    ],
                  );
                }),
          ),
        ],
      ),
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
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var favorites = Datas().doctores.where((element) => favoriteItems.contains(element['name'])).toList();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute<bool>(
                  fullscreenDialog: true,
                  builder: (BuildContext context) => new doctoreDetail(index: index),
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(top: 10,left: 20,bottom: 10,right:20),
                padding: EdgeInsets.only(top: 10,left: 10,bottom: 10),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColor.backgroundColor,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(favorites[index]['image']),
                      radius: 35,
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(favorites[index]['name'],style: TextStyle(color: AppColor.textColor,fontSize: 18,fontWeight: FontWeight.w400)),
                        SizedBox(
                          width: width*0.55,
                          child: Text("Simada Naka, Shiv Darshan Society, Yoginagar Society, Surat, Gujarat 395006",
                              style: TextStyle(
                                  color: AppColor.greycolor,
                                  fontSize: 13),
                              maxLines: 2),
                        ),
                        SizedBox(
                          width: width*0.55,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              rattingBar(tapOnly: true, initValue: 2.5),
                              Text("5.23 km",
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            favoriteItems
                                .remove(favorites[index]['name']);
                          });
                        },
                        child: Icon(
                          Icons.favorite,
                          size: 28,
                          color: AppColor.textColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}


