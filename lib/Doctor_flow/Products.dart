import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Authentication/SignUpAsDoctor.dart';
import 'package:geomed_assist/Doctor_flow/HomeScreen_doctore.dart';
import 'package:geomed_assist/Doctor_flow/bottomsheet_doctor.dart';
import 'package:geomed_assist/Firebase/firebase_quaries.dart';
import 'package:geomed_assist/Models/product.dart';
import 'package:geomed_assist/User_flow/requests.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:geomed_assist/privacy_Policy.dart';
import 'package:geomed_assist/productDetail.dart';
import 'package:geomed_assist/terms&conditions.dart';

class allProducts extends StatefulWidget {
  const allProducts({super.key});

  @override
  State<allProducts> createState() => _allProductsState();
}

class _allProductsState extends State<allProducts> {
  TextEditingController serachingController = TextEditingController();
  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        key: drawerKey,
      backgroundColor: AppColor.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColor.backgroundColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          leadingWidth: 0,
          centerTitle: true,
          toolbarHeight: 75,
          title: Row(
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
        ),
      body: Padding(
        padding: EdgeInsets.only(left: 20,right: 20,bottom: 20),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 5,right: 5,bottom: 20),
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
            Expanded(
              child: StreamBuilder<ProductList?>(
                  stream: Firebase_Quires().getAllProducts(),
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
                            padding: EdgeInsets.only(bottom: 70),
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
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(50),
                                              topRight: Radius.circular(50))),
                                      builder: (context) {
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
            ),
          ],
        ),
      ),
      drawerEnableOpenDragGesture: false,
      extendBody: true,
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
                            currentUserDocument!.address!,
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
                                  new SignUpAsDoctor(editdcreen: true),
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
                                  new requests(),
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
                                  new homeScreen_doctor(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Text(
                                    'Manage Working Slots',
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
