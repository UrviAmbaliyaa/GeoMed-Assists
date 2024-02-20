import 'package:flutter/material.dart';
import 'package:geomed_assist/Firebase/firebase_quaries.dart';
import 'package:geomed_assist/Models/rateModel.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:geomed_assist/constants/dataFile.dart';
import 'package:geomed_assist/constants/rattingBar.dart';
import 'package:intl/intl.dart';

class shop_rattings extends StatefulWidget {
  const shop_rattings({super.key});

  @override
  State<shop_rattings> createState() => _shop_rattingsState();
}

class _shop_rattingsState extends State<shop_rattings> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColor.backgroundColor,
          elevation: 0,
          primary: true,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "Rates",
            style: TextStyle(
                color: AppColor.textColor,
                fontSize: 18,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
        body: Container(
          child: StreamBuilder<RateList?>(
            stream: Firebase_Quires().getRateDocuments(shopRef: currentUserDocument!.reference),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData && snapshot.data!.rate.length != 0){
                  return ListView.separated(
                      separatorBuilder: (context, indexSt) => Divider(
                          color: AppColor.greycolor.withOpacity(0.5),
                          height: 0,
                          thickness: 2),
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data!.rate.length,
                      itemBuilder: (context, index) {
                        var rateData = snapshot.data!.rate[index];
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          margin: EdgeInsets.only(left: 20, right: 20),
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
                                child: Image.network(rateData.image,
                                    fit: BoxFit.cover),
                              ),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(rateData.name,
                                      style: TextStyle(
                                          color: AppColor.textColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400)),
                                  SizedBox(
                                    width: width * 0.75,
                                    child: Text(
                                        rateData.description,
                                        style: TextStyle(
                                            color: AppColor.greycolor, fontSize: 14),
                                        maxLines: 2),
                                  ),
                                  SizedBox(
                                    width: width * 0.75,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        rattingBar(
                                            tapOnly: true, initValue: 0.toDouble()),
                                        Text(
                                          DateFormat('dd MMM', 'en_US').format(rateData.date),
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: AppColor.greycolor, fontSize: 13),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      });
                }else{
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: constWidget()
                        .circularProgressInd(nodatafound: true),
                  );
                }

              }else{
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: constWidget()
                      .circularProgressInd(nodatafound: false),
                );
              }

            }
          ),
        ));
  }
}
