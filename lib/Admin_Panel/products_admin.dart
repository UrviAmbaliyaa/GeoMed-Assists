import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Models/product.dart';
import 'package:geomed_assist/Models/user_model.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';

class product_admin extends StatefulWidget {
  const product_admin({super.key});

  @override
  State<product_admin> createState() => _product_adminState();
}

class _product_adminState extends State<product_admin> {
  TextEditingController searcontroll = TextEditingController();
  var formKey = GlobalKey<FormState>();
  TextEditingController description = TextEditingController();
  String selectedMenu = "All";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                "Products",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.79,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.deepPurple.withOpacity(0.05)),
                    child: TextFormField(
                      controller: searcontroll,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        Future.delayed(
                            Duration(seconds: 2), () => setState(() {}));
                      },
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            top: 15, bottom: 15, left: 13, right: 2),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(
                                color: Colors.deepPurple.withOpacity(0.5),
                                width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        hintText: "Search here...",
                        hintStyle: TextStyle(
                            color: Colors.deepPurple.withOpacity(0.5),
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  PopupMenuButton<int>(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.more_vert, size: 30, color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),

                    elevation: 8,
                    enabled: true,
                    color: Colors.white,
                    // Set background color to white
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        height: 50,
                        onTap: () {
                          setState(() {
                            selectedMenu = "All";
                          });
                        },
                        child: Container(
                          child: Text('All',
                              style: TextStyle(
                                  color: selectedMenu == "All"
                                      ? Colors.deepPurple
                                      : Colors.black,
                                  fontSize: 16)),
                        ),
                      ),
                      PopupMenuItem(
                        height: 50,
                        onTap: () {
                          setState(() {
                            selectedMenu = "Pending";
                          });
                        },
                        child: Text('Pending',
                            style: TextStyle(
                                color: selectedMenu == "Pending"
                                    ? Colors.deepPurple
                                    : Colors.black,
                                fontSize: 16)),
                      ),
                      PopupMenuItem(
                        height: 50,
                        onTap: () {
                          setState(() {
                            selectedMenu = "Accepted";
                          });
                        },
                        child: Text('Accepted',
                            style: TextStyle(
                                color: selectedMenu == "Accepted"
                                    ? Colors.deepPurple
                                    : Colors.black,
                                fontSize: 16)),
                      ),
                      PopupMenuItem(
                        height: 50,
                        onTap: () {
                          setState(() {
                            selectedMenu = "Reject";
                          });
                        },
                        child: Text('Reject',
                            style: TextStyle(
                                color: selectedMenu == "Reject"
                                    ? Colors.deepPurple
                                    : Colors.black,
                                fontSize: 16)),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        body: allUsers(),
      ),
    );
  }

  bool productVisible({required Product pro, String? search}) {
    bool searching = false;
    print("selectedMenu ----->$selectedMenu");
    switch (selectedMenu) {
      case "All":
        searching = true;
        break;
      case "Pending":
        searching = pro.status == "Pending";
        break;
      case "Accepted":
        searching = pro.status == "Accept";
        break;
      case "Reject":
        searching = pro.status == "Reject";
        break;
    }
    print("search ------>$search");
    if (search != null && search.trim().length != 0 && searching == true) {
      searching =
          pro.name.toUpperCase().trim().contains(search.toUpperCase().trim());
    }

    return searching;
  }

  Widget allUsers() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("product").snapshots(),
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
                        return StreamBuilder(
                            stream: category.snapshots(),
                            builder: (context, snapshot1) {
                              if (snapshot1.hasData) {
                                Map<String, dynamic> data =
                                    snapshot.data!.docs[index].data();
                                data.addAll({
                                  "referenace":
                                      snapshot.data!.docs[index].reference,
                                  'category': snapshot1.data!['name']
                                });
                                var product = Product.fromJson(data);
                                return Visibility(
                                  visible: productVisible(
                                      pro: product, search: searcontroll.text),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 20, top: 10,bottom: 10),
                                    child: ExpandablePanel(
                                      header: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 35,
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.white,
                                            backgroundImage: NetworkImage(
                                              product.image,
                                            ),
                                          ),
                                          Expanded(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  product.name,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  maxLines: 2,
                                                ),
                                                Text(
                                                  "Diseases:${product.category}",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                  maxLines: 1,
                                                ),
                                                Text(
                                                    "Price: ${product.price}\$",
                                                    style: TextStyle(
                                                        fontSize: 15)),
                                              ],
                                            ),
                                          )),
                                          SizedBox(
                                            width: 93,
                                            height: 35,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                },
                                                style: ButtonStyle(
                                                    elevation:
                                                    MaterialStatePropertyAll(
                                                        0),
                                                    backgroundColor: MaterialStatePropertyAll(
                                                        product.status == "Accept" ? CupertinoColors
                                                            .systemGreen
                                                            .withOpacity(
                                                            0.5):
                                                        product.status == "Reject" ?
                                                        CupertinoColors
                                                            .systemRed
                                                            .withOpacity(
                                                            0.5) :
                                                        CupertinoColors
                                                            .systemGrey
                                                            .withOpacity(
                                                            0.5)
                                                    )),
                                                child: Text(product.status,
                                                    style: TextStyle(
                                                        color: Colors
                                                            .black))),
                                          ),

                                        ],
                                      ),
                                      collapsed: SizedBox.shrink(),
                                      expanded: Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          children: [
                                            StreamBuilder(
                                              stream: product.shopReference.snapshots(),
                                              builder: (context, snapshot3) {
                                                return snapshot3.hasData ? Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Shop name: ${snapshot3.data!['name']}",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                          FontWeight.w500),
                                                    ),
                                                    Text(
                                                      "Address: ${snapshot3.data!['address']}",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                          FontWeight.w400),
                                                    ),
                                                    Text(
                                                      "cantact: ${snapshot3.data!['cantact']}",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                          FontWeight.w400),
                                                    ),
                                                  ],
                                                ) : SizedBox.shrink();
                                              }
                                            ),

                                              Text(product.description,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500),
                                                softWrap: true),
                                            SizedBox(height: 10),
                                            SizedBox(
                                              width: double.infinity,
                                              height: 45,
                                              child: Row(
                                                children: [
                                                  product.status == "Pending" || product.status == "Reject" ? Expanded(
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          product.referenace
                                                              .update({
                                                            "status":
                                                            "Accept"
                                                          });
                                                        },
                                                        style: ButtonStyle(
                                                            elevation:
                                                            MaterialStatePropertyAll(
                                                                0),
                                                            backgroundColor: MaterialStatePropertyAll(
                                                                CupertinoColors
                                                                    .systemGreen
                                                                    .withOpacity(
                                                                    0.5))),
                                                        child: Text("Accept",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black))),
                                                  ) : SizedBox.shrink(),
                                                  SizedBox(width: product.status == "Pending" || product.status == "Reject" ? 5 : 0),
                                                  product.status == "Pending" || product.status == "Accept" ?  Expanded(
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  backgroundColor:
                                                                  Colors
                                                                      .white,
                                                                  elevation: 0,
                                                                  contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                                  content: alertPopu(
                                                                      formKey,
                                                                      description,
                                                                      context,
                                                                      product: product),
                                                                );
                                                              });
                                                        },
                                                        style: ButtonStyle(
                                                            elevation:
                                                            MaterialStatePropertyAll(
                                                                0),
                                                            backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                CupertinoColors
                                                                    .systemRed
                                                                    .withOpacity(
                                                                    0.5))),
                                                        child: Text("Reject",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black))),
                                                  )  : SizedBox.shrink(),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      theme: ExpandableThemeData(
                                        tapHeaderToExpand: true,
                                        tapBodyToExpand: false,
                                        tapBodyToCollapse: false,
                                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                                        hasIcon: false,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            });
                      },
                    )
                  : constWidget().circularProgressInd(nodatafound: true)
              : constWidget().circularProgressInd(nodatafound: false);
        });
  }

  alertPopu(
      GlobalKey<FormState> formKey, TextEditingController controller, context,
      {required Product product}) {
    return Container(
      width: 350,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: 275,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Reject Request of ${product.name}",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            maxLines: 2,
          ),
          Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.multiline,
              cursorColor: AppColor.primaryColor,
              maxLines: 5,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "Please write your request message.";
                }
                return null;
              },
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  bottom: 13,
                  left: 13,
                  right: 2,
                ),
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
                hintText: "Write your reason here..",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  var validate = formKey.currentState!.validate();
                  if (validate) {
                    product.referenace.update(
                        {"cancelReason": controller.text, "status": "Reject"});
                    Navigator.pop(context);
                  }
                },
                style: ButtonStyle(
                    elevation: MaterialStatePropertyAll(0),
                    backgroundColor: MaterialStatePropertyAll(
                        CupertinoColors.systemRed.withOpacity(0.5))),
                child: Text("Reject",
                    style: TextStyle(color: Colors.black, fontSize: 17))),
          )
        ],
      ),
    );
  }
}
