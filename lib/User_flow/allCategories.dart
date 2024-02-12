import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/User_flow/CategoryDetail.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/dataFile.dart';

class allCategories extends StatefulWidget {
  const allCategories({super.key});

  @override
  State<allCategories> createState() => _allCategoriesState();
}

class _allCategoriesState extends State<allCategories> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: constWidget().appbar(context,Name: "Diseases",backbutton: true),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: GridView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: Datas().category.length,
            padding: EdgeInsets.all(20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute<bool>(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => new categoryDetail(index: index ),
                  ),
                ),
                child: Container(
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
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(Datas().category[index]['image'],
                          height: width * 0.3,
                          fit: BoxFit.cover,
                          width: double.infinity),
                      Expanded(
                        child: Center(
                          child: Text(Datas().category[index]['name'],
                              style: TextStyle(
                                  color: AppColor.textColor, fontSize: 16),
                              maxLines: 1),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
