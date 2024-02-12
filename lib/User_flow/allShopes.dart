import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/User_flow/HomePage.dart';
import 'package:geomed_assist/User_flow/shopDetailScreen.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/dataFile.dart';
import 'package:geomed_assist/constants/rattingBar.dart';

class allShopes extends StatefulWidget {
  const allShopes({super.key});

  @override
  State<allShopes> createState() => _allShopesState();
}

class _allShopesState extends State<allShopes> {
  TextEditingController serachingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: constWidget().appbar(context,Name: "Shopes",backbutton: true),
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
            child: GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: Datas().shopes.length,
                padding: EdgeInsets.only(left: 20, right: 20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
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
                              Image.network(Datas().shopes[index]['image'],
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
                                    Text(Datas().shopes[index]['name'],
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
                                      .contains(Datas().shopes[index]['name'])
                                  ? favoriteItems
                                      .remove(Datas().shopes[index]['name'])
                                  : favoriteItems
                                      .add(Datas().shopes[index]['name']);
                            });
                          },
                          child: Icon(
                            favoriteItems
                                    .contains(Datas().shopes[index]['name'])
                                ? Icons.favorite
                                : Icons.favorite_border,
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
