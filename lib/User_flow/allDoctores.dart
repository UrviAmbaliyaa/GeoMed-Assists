import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/User_flow/HomePage.dart';
import 'package:geomed_assist/User_flow/doctoreDetail.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/dataFile.dart';
import 'package:geomed_assist/constants/rattingBar.dart';

class allDoctores extends StatefulWidget {
  const allDoctores({super.key});

  @override
  State<allDoctores> createState() => _allDoctoresState();
}

class _allDoctoresState extends State<allDoctores> {
  TextEditingController serachingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: constWidget().appbar(context,Name: "Doctor",backbutton: true),
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
            child: ListView.builder(
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
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, left: 20, bottom: 10, right: 35),
                        padding: EdgeInsets.all(10),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: AppColor.backgroundColor,
                          borderRadius: BorderRadius.circular(50),
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
                        child: InkWell(
                          onTap: () =>
                              Navigator.of(context, rootNavigator: true).push(
                                CupertinoPageRoute<bool>(
                                  fullscreenDialog: true,
                                  builder: (BuildContext context) =>
                                  new doctoreDetail(index: index),
                                ),
                              ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    Datas().doctores[index]['image']),
                                radius: 35,
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
                                    width: width * 0.57,
                                    child: Text(
                                        "Simada Naka, Shiv Darshan Society, Yoginagar Society, Surat, Gujarat 395006",
                                        style: TextStyle(
                                            color: AppColor.greycolor,
                                            fontSize: 13),
                                        maxLines: 2),
                                  ),
                                  SizedBox(
                                    width: width * 0.57,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        rattingBar(
                                            tapOnly: true, initValue: 2.5),
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
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Icon(CupertinoIcons.phone_circle_fill,
                              size: 45, color: AppColor.textColor))
                    ],
                  ) : SizedBox.shrink();
                }),
          ),
        ],
      ),
    );
  }
}
