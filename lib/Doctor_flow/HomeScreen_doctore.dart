import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';
import 'package:geomed_assist/Authentication/SignUpAsDoctor.dart';
import 'package:geomed_assist/User_flow/requests.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:geomed_assist/privacy_Policy.dart';
import 'package:geomed_assist/terms&conditions.dart';
import 'package:intl/intl.dart';

class homeScreen_doctor extends StatefulWidget {
  const homeScreen_doctor({super.key});

  @override
  State<homeScreen_doctor> createState() => _homeScreen_doctorState();
}

class _homeScreen_doctorState extends State<homeScreen_doctor> {
  TextEditingController serachingController = TextEditingController();
  final _calendarControllerToday = AdvancedCalendarController.today();
  final events = <DateTime>[
    DateTime.now(),
    DateTime(2022, 10, 10),
  ];
  List slots = [];
  List slot2 = [];
  List selectSlotTime = [];

  DateTime parseDateTime(String dateTimeString) {
    return DateFormat("HH:mm").parse(dateTimeString);
  }
  Future<void> calculateSlotTime() async {
    var data = await currentUserDocument!.reference.get();
    selectSlotTime = data['availableSlot'];
    DateTime startDateTime = DateFormat("HH:mm").parse(currentUserDocument!.startTime!);
    DateTime breakStartDateTime = DateFormat("HH:mm").parse(currentUserDocument!.breckstartTime!);
    DateTime breakEndDateTime = DateFormat("HH:mm").parse(currentUserDocument!.breckendTime!);
    DateTime endDateTime = DateFormat("HH:mm").parse(currentUserDocument!.endTime!);
    List<DateTime> firstList = generateTimeList(startDateTime, breakStartDateTime, 30);
    List<DateTime> secondList = generateTimeList(breakEndDateTime, endDateTime, 30);
    firstList.forEach((time) {
      slots.add(DateFormat("h:mm a").format(time));
    });
    secondList.forEach((time) {
      slot2.add(DateFormat("h:mm a").format(time));
    });
    setState(() {
    });
  }

  List<DateTime> generateTimeList(DateTime startTime, DateTime endTime, int intervalMinutes) {
    List<DateTime> timeList = [];
    DateTime currentTime = startTime;
    while (currentTime.isBefore(endTime)) {
      timeList.add(currentTime);
      currentTime = currentTime.add(Duration(minutes: intervalMinutes));
    }
    currentTime = currentTime.add(Duration(minutes: (currentTime.minute - endTime.minute)));
    timeList.add(currentTime);
    return timeList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateSlotTime();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: constWidget().appbar(context, Name: "Slot", backbutton: true),
      backgroundColor: AppColor.backgroundColor,
      body:  Column(
        children: [
          // AdvancedCalendar(
          //   controller: _calendarControllerToday,
          //   events: events,
          //   calendarTextStyle: TextStyle(
          //       color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          //   headerStyle: TextStyle(
          //       color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          //   todayStyle: TextStyle(
          //       color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          //   innerDot: true,
          //   keepLineSize: true,
          //   startWeekDay: 2,
          // ),
          Text(DateFormat("dd MMM yyyy").format(DateTime.now()),style: TextStyle(color: AppColor.textColor,fontSize: 20,fontWeight: FontWeight.w500)),
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
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectSlotTime.contains(slots[index]) ? selectSlotTime.remove(slots[index]) : selectSlotTime.add(slots[index]);
                          });
                        },
                        splashColor: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              color: selectSlotTime.contains(slots[index])?AppColor.primaryColor : AppColor.textColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          child: Text(slots[index],
                              style: TextStyle(
                                  color: AppColor.textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                        ),
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
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectSlotTime.contains(slot2[index]) ? selectSlotTime.remove(slot2[index]) : selectSlotTime.add(slot2[index]);
                          });
                        },
                        splashColor: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              color:  selectSlotTime.contains(slot2[index]) ? AppColor.primaryColor : AppColor.textColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          child: Text(slot2[index],
                              style: TextStyle(
                                  color: AppColor.textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Container(width: width,
                    height: 50,
                    margin: EdgeInsets.only(bottom: 100,right: 20,left: 20),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        currentUserDocument!.reference.update({"availableSlot":selectSlotTime});
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(AppColor.primaryColor)
                      ),
                      child: Text("Save",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
