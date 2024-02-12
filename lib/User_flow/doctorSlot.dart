import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';
import 'package:geomed_assist/constants/Appcolors.dart';

class doctorSlot extends StatefulWidget {
  const doctorSlot({super.key});

  @override
  State<doctorSlot> createState() => _doctorSlotState();
}

class _doctorSlotState extends State<doctorSlot> {
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
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        color: AppColor.backgroundColor
      ),
      child: Column(
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
                    padding: EdgeInsets.all(20),
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
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                      );
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
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
                    padding: EdgeInsets.all(20),
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
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
