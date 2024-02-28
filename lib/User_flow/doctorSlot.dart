import 'package:flutter/material.dart';
import 'package:geomed_assist/Models/user_model.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:intl/intl.dart';

class doctorSlot extends StatefulWidget {
  final UserModel doctor;
  const doctorSlot({super.key, required this.doctor});

  @override
  State<doctorSlot> createState() => _doctorSlotState();
}

class _doctorSlotState extends State<doctorSlot> {
  TextEditingController serachingController = TextEditingController();
  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  final events = <DateTime>[
    DateTime.now(),
    DateTime(2022, 10, 10),
  ];
  List<String> slot1 = [];
  List<String> slot2 = [];

  manageSlot(){
    var bStart = DateFormat("h:mm").parse(widget.doctor.breckstartTime!);
    for(var slot in widget.doctor.availableSlot!){
      var date = DateFormat("h:mm a").parse(slot);
      date.isBefore(bStart) || date == bStart? slot1.add(DateFormat("h:mm a").format(date)):slot2.add(DateFormat("h:mm a").format(date));
    }
    setState(() {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    manageSlot();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        color: AppColor.backgroundColor
      ),
      child: Column(
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: slot1.length,
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
                        child: Text(slot1[index],
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
