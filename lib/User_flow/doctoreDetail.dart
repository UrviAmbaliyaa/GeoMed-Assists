import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';
import 'package:geomed_assist/User_flow/HomePage.dart';
import 'package:geomed_assist/User_flow/doctorSlot.dart';
import 'package:geomed_assist/User_flow/message.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/dataFile.dart';
import 'package:geomed_assist/constants/rattingBar.dart';

class doctoreDetail extends StatefulWidget {
  final int index;

  const doctoreDetail({super.key, required this.index});

  @override
  State<doctoreDetail> createState() => _doctoreDetailState();
}

class _doctoreDetailState extends State<doctoreDetail> {

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: constWidget().appbar(context,
          Name: Datas().doctores[widget.index]['name'], backbutton: true),
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    image: DecorationImage(
                      image:
                          NetworkImage(Datas().doctores[widget.index]['image']),
                      fit: BoxFit.cover,
                    )),
              ),
              SizedBox(height: 10),
              Text(
                Datas().doctores[widget.index]['name'],
                style: TextStyle(
                    color: AppColor.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      rattingBar(tapOnly: true, initValue: 3.5, size: 25),
                    ],
                  )),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute<bool>(
                        fullscreenDialog: true,
                        builder: (BuildContext context) => messageScreen(),
                      ),
                    ),
                    child: Icon(CupertinoIcons.chat_bubble,
                        size: 30, color: AppColor.primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 5),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          favoriteItems.contains(
                                  Datas().doctores[widget.index]['name'])
                              ? favoriteItems.remove(
                                  Datas().doctores[widget.index]['name'])
                              : favoriteItems
                                  .add(Datas().doctores[widget.index]['name']);
                        });
                      },
                      child: Icon(
                        favoriteItems.contains(
                                Datas().doctores[widget.index]['name'])
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 30,
                        color: AppColor.textColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text("contact Number: +91 12345 56789",
                  style: TextStyle(color: AppColor.textColor, fontSize: 13)),
              Text("Education: Bachelor of Technology",
                  style: TextStyle(color: AppColor.textColor, fontSize: 13)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Working : 10:00 Am to 6:00 Pm",
                      style:
                          TextStyle(color: AppColor.textColor, fontSize: 13)),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            contentPadding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            content: SizedBox(
                              height: MediaQuery.of(context).size.height*0.6,
                                width: width,
                                child: doctorSlot()),
                          );
                        },
                      );
                    },
                    child: Text("Working Slot",
                        style: TextStyle(
                            color: AppColor.primaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColor.primaryColor)),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                  "A one-stop destination for healthcare needs, our medical shop provides a wide range of prescription medications, over-the-counter drugs, and essential medical supplies. With a dedicated and knowledgeable staff, we ensure a seamless and reliable experience for all your health-related requirements. Conveniently located with flexible hours, we prioritize your well-being.",
                  style: TextStyle(color: AppColor.textColor, fontSize: 13)),
              SizedBox(height: 10),
              ElevatedButton(
                  style: ButtonStyle(
                      minimumSize: MaterialStatePropertyAll(Size(width, 45)),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                      backgroundColor:
                          MaterialStatePropertyAll(AppColor.primaryColor)),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          contentPadding: EdgeInsets.zero,
                          content: RattingPopUp(),
                        );
                      },
                    );
                  },
                  child: Text("Ratting",
                      style:
                          TextStyle(color: AppColor.textColor, fontSize: 18))),
              ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                      color: AppColor.greycolor.withOpacity(0.5),
                      height: 0,
                      thickness: 2),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: Datas().doctores.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
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
                            child: Image.network(
                                Datas().doctores[index]['image'],
                                fit: BoxFit.cover),
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
                                width: width * 0.75,
                                child: Text(
                                    "Thank you, Neethi. Your medician has been very helpful for me.",
                                    style: TextStyle(
                                        color: AppColor.greycolor,
                                        fontSize: 14),
                                    maxLines: 2),
                              ),
                              SizedBox(
                                width: width * 0.75,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    rattingBar(
                                        tapOnly: true,
                                        initValue: index.toDouble()),
                                    Text(
                                      "7 Jan",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: AppColor.greycolor,
                                          fontSize: 13),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class RattingPopUp extends StatefulWidget {
  const RattingPopUp({Key? key}) : super(key: key);

  @override
  State<RattingPopUp> createState() => _RattingPopUpState();
}

class _RattingPopUpState extends State<RattingPopUp> {
  TextEditingController rattingMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: 275,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          rattingBar(tapOnly: false, initValue: 0, size: 50),
          SizedBox(height: 10),
          TextFormField(
            controller: rattingMessage,
            keyboardType: TextInputType.multiline,
            cursorColor: AppColor.primaryColor,
            maxLines: 4,
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 13, left: 13, right: 2),
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
              hintText: "Enter your message here..",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size(width, 45)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(AppColor.primaryColor),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Submit",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
