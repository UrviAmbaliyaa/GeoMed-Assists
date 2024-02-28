import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Authentication/SignUpAsShopkeeper.dart';
import 'package:geomed_assist/Firebase/firebase_quaries.dart';
import 'package:geomed_assist/Models/categoryModel.dart';
import 'package:geomed_assist/Models/product.dart';
import 'package:geomed_assist/Store_flow/addProducts.dart';
import 'package:geomed_assist/Store_flow/productRequests.dart';
import 'package:geomed_assist/User_flow/requests.dart';
import 'package:geomed_assist/User_flow/shopDetailScreen.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:geomed_assist/constants/dataFile.dart';
import 'package:geomed_assist/constants/rattingBar.dart';
import 'package:geomed_assist/privacy_Policy.dart';
import 'package:geomed_assist/productDetail.dart';
import 'package:geomed_assist/terms&conditions.dart';

class products extends StatefulWidget {
  const products({super.key});

  @override
  State<products> createState() => _productsState();
}

class _productsState extends State<products> {
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
              onChanged: (value) => setState(() {}),
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
                  stream: Firebase_Quires().getProductDocuments(
                      shopRef: currentUserDocument!.reference, available: true,forCategories: false),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData &&
                          snapshot.data!.products.length != 0) {
                        List<Product> dataSN = serachingController.text.isEmpty
                            ? snapshot.data!.products
                            : snapshot.data!.products
                                .where((element) => (element.name
                                        .toUpperCase()
                                        .contains(serachingController.text
                                            .toUpperCase()) ||
                                    element.category.toUpperCase().contains(
                                        serachingController.text
                                            .toUpperCase()) ||
                                    element.price
                                        .toString()
                                        .toUpperCase()
                                        .contains(serachingController.text
                                            .toUpperCase())))
                                .toList();
                        return GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(left: 20, right: 20),
                            physics: BouncingScrollPhysics(),
                            itemCount: dataSN.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                    childAspectRatio: 0.7),
                            itemBuilder: (context, index) {
                              var data = dataSN[index];
                              return Stack(
                                children: [
                                  Container(
                                    height: double.infinity,
                                    width: double.infinity,
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
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context, rootNavigator: true).push(
                                                CupertinoPageRoute<bool>(
                                                  fullscreenDialog: true,
                                                  builder: (BuildContext context) =>
                                                  new productDetail(data: data),
                                                ),
                                              );
                                            },
                                            child: Image.network(data.image,
                                                height: width * 0.3,
                                                fit: BoxFit.cover,
                                                width: double.infinity),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(data.name,
                                                    style: TextStyle(
                                                        color:
                                                            AppColor.textColor,
                                                        fontSize: 16),
                                                    maxLines: 2),
                                                Text("Diseas: ${data.category}",
                                                    style: TextStyle(
                                                        color:
                                                            AppColor.greycolor,
                                                        fontSize: 13),
                                                    maxLines: 2),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                          "Price: ${data.price}\$",
                                                          style: TextStyle(
                                                              color: AppColor
                                                                  .greycolor,
                                                              fontSize: 13),
                                                          maxLines: 2),
                                                    ),
                                                    InkWell(
                                                        onTap: () async {
                                                          List<categoryModel>? categories2 = [];
                                                          Stream<List<categoryModel>?> datas = await Firebase_Quires().getCategory();
                                                          await for (List<categoryModel>? event in datas) {
                                                            categories2 = event;
                                                          }
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .push(
                                                            CupertinoPageRoute<
                                                                bool>(
                                                              fullscreenDialog:
                                                                  true,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  new addProduct(
                                                                      edit:
                                                                          true,
                                                                      product:
                                                                          data,
                                                                  categories: categories2,
                                                                  ),
                                                            ),
                                                          );
                                                        },
                                                        child: Icon(Icons.edit,
                                                            color: AppColor
                                                                .textColor,
                                                            size: 25)),
                                                    SizedBox(width: 10),
                                                    InkWell(
                                                        onTap: () async {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                content:
                                                                    Container(
                                                                  height: 200,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              25),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                          "Are you sure, You want to Delete the \"${data.name}\" Product.",
                                                                          style: TextStyle(
                                                                              color: AppColor.backgroundColor,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w500),
                                                                          textAlign: TextAlign.center),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Expanded(
                                                                            child: ElevatedButton(
                                                                                style: ButtonStyle(shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), backgroundColor: MaterialStatePropertyAll(AppColor.primaryColor)),
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Text("Cancel", style: TextStyle(color: AppColor.textColor, fontSize: 18))),
                                                                          ),
                                                                          SizedBox(
                                                                              width: 30),
                                                                          Expanded(
                                                                            child: ElevatedButton(
                                                                                style: ButtonStyle(shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), backgroundColor: MaterialStatePropertyAll(AppColor.primaryColor)),
                                                                                onPressed: () async {
                                                                                  await Firebase_Quires().crudOperations(available: true, categoryReferance: data.categoryRef, crudType: "del", image: data.image, description: data.description, name: data.name, price: data.price.toString(), productID: data.referenace.id,status: data.status);
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Text("Delete", style: TextStyle(color: AppColor.textColor, fontSize: 18))),
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                            size: 25)),
                                                  ],
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
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      } else {
                        return constWidget()
                            .circularProgressInd(nodatafound: true);
                      }
                    } else {
                      return constWidget()
                          .circularProgressInd(nodatafound: false);
                    }
                  })),
        ],
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
                                      new SignUpAsShopkeeper(editdcreen: true),
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
                            onTap: () async {
                              drawerKey.currentState?.closeDrawer();
                              var category =
                              await FirebaseFirestore.instance.collection("category").get();
                              List<categoryModel> categorytList = [];
                              for (var doc in category.docs) {
                                Map<String, dynamic> docdata = doc.data();
                                docdata.addAll({"refereance":doc.reference});
                                categorytList
                                    .add(categoryModel.fromJson(docdata));
                              }
                              print("=============================>${categorytList.length}");
                              Navigator.of(context, rootNavigator: true).push(
                                CupertinoPageRoute<bool>(
                                  fullscreenDialog: true,
                                  builder: (BuildContext context) =>
                                      new addProduct(edit: false,categories: categorytList),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Text(
                                    'Add Product',
                                    style: TextStyle(
                                        color: AppColor.textColor,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.of(context, rootNavigator: true).push(
                                CupertinoPageRoute<bool>(
                                  fullscreenDialog: true,
                                  builder: (BuildContext context) =>
                                      ProductRequest(),
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
                                      requests(),
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
