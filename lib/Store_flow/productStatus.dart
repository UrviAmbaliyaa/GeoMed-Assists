import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Models/product.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';

class productStatus extends StatefulWidget {
  const productStatus({super.key});

  @override
  State<productStatus> createState() => _productStatusState();
}

class _productStatusState extends State<productStatus> {
  TextEditingController searcontroll = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        elevation: 1,
        leadingWidth: 0,
        toolbarHeight: 110,
        automaticallyImplyLeading: false,
        excludeHeaderSemantics: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              "Product status",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
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
                controller: searcontroll,
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
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("product")
                    .where("shopReference",
                        isEqualTo: currentUserDocument!.reference)
                    .snapshots(),
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.connectionState == ConnectionState.active
                      ? snapshot.hasData
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentReference category =
                                    snapshot.data!.docs[index]['categoryRef'];
                                return searcontroll.text.trim().isEmpty ||
                                        (searcontroll.text.trim().isNotEmpty &&
                                            snapshot.data!.docs[index]['name']
                                                .toString()
                                                .toUpperCase()
                                                .trim()
                                                .contains(searcontroll.text
                                                    .toUpperCase()
                                                    .trim()))
                                    ? StreamBuilder(
                                        stream: category.snapshots(),
                                        builder: (context, snapshot1) {
                                          if (snapshot1.hasData) {
                                            Map<String, dynamic> data = snapshot
                                                .data!.docs[index]
                                                .data();
                                            data.addAll({
                                              "referenace": snapshot
                                                  .data!.docs[index].reference,
                                              'category':
                                                  snapshot1.data!['name']
                                            });
                                            var product =
                                                Product.fromJson(data);
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 10,
                                                  bottom: 10),
                                              child: ExpandablePanel(
                                                header: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 35,
                                                      backgroundColor:
                                                          Colors.white,
                                                      foregroundColor:
                                                          Colors.white,
                                                      backgroundImage:
                                                          NetworkImage(
                                                        product.image,
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5,
                                                              horizontal: 5),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            product.name,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: AppColor
                                                                    .textColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            maxLines: 2,
                                                          ),
                                                          Text(
                                                            "Diseases:${product.category}",
                                                            style: TextStyle(
                                                                color: AppColor
                                                                    .textColor,
                                                                fontSize: 15),
                                                            maxLines: 1,
                                                          ),
                                                          Text(
                                                              "Price: ${product.price}\$",
                                                              style: TextStyle(
                                                                  color: AppColor
                                                                      .textColor,
                                                                  fontSize:
                                                                      15)),
                                                        ],
                                                      ),
                                                    )),
                                                    SizedBox(
                                                      width: 93,
                                                      height: 35,
                                                      child: ElevatedButton(
                                                          onPressed: () {},
                                                          style: ButtonStyle(
                                                              elevation:
                                                                  MaterialStatePropertyAll(
                                                                      0),
                                                              backgroundColor: MaterialStatePropertyAll(product.status ==
                                                                      "Accept"
                                                                  ? CupertinoColors
                                                                      .systemGreen
                                                                      .withOpacity(
                                                                          0.5)
                                                                  : product.status ==
                                                                          "Reject"
                                                                      ? CupertinoColors
                                                                          .systemRed
                                                                          .withOpacity(
                                                                              0.5)
                                                                      : CupertinoColors
                                                                          .systemGrey
                                                                          .withOpacity(
                                                                              0.5))),
                                                          child: Text(product.status,
                                                              style: TextStyle(
                                                                  color: Colors.black))),
                                                    ),
                                                  ],
                                                ),
                                                collapsed: SizedBox.shrink(),
                                                expanded: Padding(
                                                  padding: EdgeInsets.all(15),
                                                  child: Column(
                                                    children: [
                                                      Text(product.description,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          softWrap: true)
                                                    ],
                                                  ),
                                                ),
                                                theme: ExpandableThemeData(
                                                  tapHeaderToExpand: true,
                                                  tapBodyToExpand: false,
                                                  tapBodyToCollapse: false,
                                                  headerAlignment:
                                                      ExpandablePanelHeaderAlignment
                                                          .center,
                                                  hasIcon: false,
                                                ),
                                              ),
                                            );
                                          } else {
                                            return SizedBox.shrink();
                                          }
                                        })
                                    : SizedBox.shrink();
                              },
                            )
                          : constWidget().circularProgressInd(nodatafound: true)
                      : constWidget().circularProgressInd(nodatafound: false);
                }),
          ),
        ],
      ),
    );
  }
}
