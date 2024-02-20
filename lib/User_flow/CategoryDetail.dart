import 'package:flutter/material.dart';
import 'package:geomed_assist/Firebase/firebase_quaries.dart';
import 'package:geomed_assist/Models/categoryModel.dart';
import 'package:geomed_assist/Models/product.dart';
import 'package:geomed_assist/User_flow/shopDetailScreen.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/dataFile.dart';

import '../productDetail.dart';

class categoryDetail extends StatefulWidget {
  final categoryModel category;

  const categoryDetail({super.key, required this.category});

  @override
  State<categoryDetail> createState() => _categoryDetailState();
}

class _categoryDetailState extends State<categoryDetail> {
  TextEditingController serachingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: constWidget()
            .appbar(context, Name: widget.category.name, backbutton: true),
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
                        color: AppColor.backgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(widget.category.imageUrl),
                          fit: BoxFit.cover,
                        )),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.category.name,
                    style: TextStyle(
                        color: AppColor.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.category.description,
                    style: TextStyle(
                        color: AppColor.textColor,
                        fontSize: 15,),
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Products",
                          style:
                              TextStyle(color: AppColor.textColor, fontSize: 13)),
                    ],
                  ),
                  SizedBox(height: 3),
                  Divider(color: AppColor.greycolor,thickness: 2),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 20, bottom: 20, left: 5, right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: serachingController,
                          style: TextStyle(
                              color: AppColor.textColor, fontSize: 15),
                          onChanged: (value) {
                            Future.delayed(
                                Duration(seconds: 3), () => setState(() {}));
                          },
                          decoration: InputDecoration(
                            hintText: "Search here..",
                            hintStyle: TextStyle(
                                color: AppColor.greycolor, fontSize: 15),
                            isDense: true,
                            fillColor: AppColor.backgroundColor,
                            filled: true,
                            contentPadding: EdgeInsets.only(
                                left: 15, top: 5, bottom: 5, right: 15),
                            suffixIcon: Icon(Icons.search,
                                color: AppColor.greycolor, size: 29),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(
                                  color: AppColor.greycolor.withOpacity(0.3)),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                  color: AppColor.greycolor,
                                )),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(
                                  color: AppColor.textColor.withOpacity(0.5)),
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder<ProductList?>(
                          stream: Firebase_Quires().getProductDocuments(
                              shopRef: widget.category.refereance,
                              available: true,
                              forCategories: true,
                              cateName: widget.category.name
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.active ||
                                snapshot.connectionState ==
                                    ConnectionState.done) {
                              if (snapshot.hasData &&
                                  snapshot.data!.products.length != 0) {
                                var maindata = serachingController.text
                                            .trim()
                                            .length !=
                                        0
                                    ? snapshot.data!.products.where((element) {
                                        return (element.name
                                                .toUpperCase()
                                                .contains(serachingController
                                                    .text
                                                    .toUpperCase())) ||
                                            (element.price.toString().contains(
                                                serachingController.text
                                                    .toUpperCase())) ||
                                            (serachingController.text
                                                    .toUpperCase()
                                                    .contains("AVAILABLE") &&
                                                element.available);
                                      }).toList()
                                    : snapshot.data!.products;
                                return GridView.builder(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: maindata.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
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
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  50),
                                                          topRight:
                                                              Radius.circular(
                                                                  50))),
                                              builder: (context) {
                                                return Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.7,
                                                    child: productDetail(
                                                        data: data));
                                              });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              bottom: 5, left: 5, top: 5),
                                          padding: EdgeInsets.only(bottom: 5),
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            color: AppColor.backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 8,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.network(data.image,
                                                  height: width * 0.3,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                child: Text(data.name,
                                                    style: TextStyle(
                                                        color:
                                                            AppColor.textColor,
                                                        fontSize: 16),
                                                    maxLines: 2),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                child: Text(
                                                    "Category: ${data.category}",
                                                    style: TextStyle(
                                                        color:
                                                            AppColor.greycolor,
                                                        fontSize: 13),
                                                    maxLines: 2),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                child: Text(
                                                    "Price: ${data.price}\$",
                                                    style: TextStyle(
                                                        color:
                                                            AppColor.greycolor,
                                                        fontSize: 13),
                                                    maxLines: 2),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 10,
                                                      height: 10,
                                                      margin: EdgeInsets.only(
                                                          right: 5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          color: data.available
                                                              ? Colors.green
                                                              : Colors.red),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            data.available
                                                                ? "Available"
                                                                : "Not Available",
                                                            style: TextStyle(
                                                                color: data
                                                                        .available
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red,
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
                          }),
                    ],
                  ),
                ]),
          ),
        ));
  }
}
