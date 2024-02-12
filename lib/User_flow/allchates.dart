import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/dataFile.dart';
import 'package:geomed_assist/constants/rattingBar.dart';
import 'package:hive/hive.dart';

import 'message.dart';

class allChates extends StatefulWidget {
  const allChates({super.key});

  @override
  State<allChates> createState() => _allChatesState();
}

class _allChatesState extends State<allChates> {
  TextEditingController serachingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar:constWidget().appbar(context,Name: "Chat",backbutton: false),
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
              onChanged: (value) {
                setState(() {
                });
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
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(color: AppColor.greycolor.withOpacity(0.5),height: 0,thickness: 2),
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: Datas().doctores.length,
                itemBuilder: (context, index) {
                  return (serachingController.text
                      .trim()
                      .isNotEmpty &&
                      Datas().doctores[index]['name'].toString().toUpperCase().contains(
                          serachingController.text.toUpperCase())) || serachingController.text
                      .trim()
                      .isEmpty ?
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: InkWell(
                      onTap: () =>
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute<bool>(
                              fullscreenDialog: true,
                              builder: (BuildContext context) =>
                              new messageScreen(),
                            ),
                          ),
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
                            child: Image.network(Datas().doctores[index]['image'],fit: BoxFit.cover),
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(Datas().doctores[index]['name'],
                                  style: TextStyle(
                                      color: AppColor.textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400)),
                              SizedBox(
                                width: width * 0.64,
                                child: Text(
                                    "Anisha : Good Morning, Have a Nice day sir",
                                    style: TextStyle(
                                        color: AppColor.greycolor,
                                        fontSize: 14),
                                    maxLines: 2),
                              ),

                            ],
                          ),
                          Text("5.23 km",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: AppColor.greycolor,
                                fontSize: 13),)
                        ],
                      ),
                    ),
                  ) : SizedBox.shrink();
                }),
          ),
        ],
      ),
    );
  }
}
