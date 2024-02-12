import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';
import 'package:geomed_assist/Authentication/SignUpAsDoctor.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:geomed_assist/privacy_Policy.dart';
import 'package:geomed_assist/terms&conditions.dart';

class homeScreen_doctor extends StatefulWidget {
  const homeScreen_doctor({super.key});

  @override
  State<homeScreen_doctor> createState() => _homeScreen_doctorState();
}

class _homeScreen_doctorState extends State<homeScreen_doctor> {
  TextEditingController serachingController = TextEditingController();
  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  final _calendarControllerToday = AdvancedCalendarController.today();
  final _calendarControllerCustom =
      AdvancedCalendarController(DateTime(2022, 10, 23));
  final events = <DateTime>[
    DateTime.now(),
    DateTime(2022, 10, 10),
  ];
  List slots = [
    "9:00 AM",
    "9:30 AM",
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
    "11:30 AM",
    "12:00 PM"
  ];
  List slot2 = [
    "2:00 PM",
    "2:30 PM",
    "3:00 PM",
    "3:30 pM",
    "4:00 pM",
    "5:00 pM",
    "5:30 pM",
    "6:00 pM"
  ];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
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
                    currentUserDocument!.address,
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
          AdvancedCalendar(
            controller: _calendarControllerToday,
            events: events,
            calendarTextStyle: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            headerStyle: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            todayStyle: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            innerDot: true,
            keepLineSize: true,
            startWeekDay: 2,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: slots.length,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 2.3),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            color: AppColor.textColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: Text(slots[index],
                            style: TextStyle(
                                color: AppColor.textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w500)),
                      );
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: AppColor.primaryColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.center,
                    child: Text("Lunch Brack",
                        style: TextStyle(
                            color: AppColor.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: slot2.length,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 2.3),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            color: AppColor.textColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: Text(slot2[index],
                            style: TextStyle(
                                color: AppColor.textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w500)),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
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
                            currentUserDocument!.address,
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
