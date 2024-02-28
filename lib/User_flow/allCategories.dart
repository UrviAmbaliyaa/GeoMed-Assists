import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Models/categoryModel.dart';
import 'package:geomed_assist/User_flow/CategoryDetail.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';
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
      backgroundColor: currentUserDocument!.type == "Admin"
          ? Colors.white
          : AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: currentUserDocument!.type == "Admin"
            ? Colors.transparent
            : AppColor.backgroundColor,
        elevation: currentUserDocument!.type == "Admin" ? 3 : 0,
        primary: true,
        leadingWidth: 70,
        automaticallyImplyLeading: false,
        leading: currentUserDocument!.type != "Admin"
            ? Align(
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back,
                        color: AppColor.textColor, size: 30)),
              )
            : SizedBox.shrink(),
        centerTitle: true,
        title: Text(
          "Diseases",
          style: TextStyle(
              color: currentUserDocument!.type == "Admin"
                  ? Colors.black
                  : AppColor.textColor,
              fontSize: 20,
              fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("category").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                var maindata = snapshot.data!.docs;
                return SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: maindata.length,
                      padding: const EdgeInsets.all(20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 1),
                      itemBuilder: (context, index) {
                        Map<String, dynamic> categories =
                            maindata[index].data() as Map<String, dynamic>;
                        categories
                            .addAll({"refereance": maindata[index].reference});
                        var data = categoryModel.fromJson(categories);
                        return InkWell(
                          onTap: () =>
                              Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute<bool>(
                              fullscreenDialog: true,
                              builder: (BuildContext context) =>
                                  categoryDetail(category: data),
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 5, left: 5),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: currentUserDocument!.type == "Admin"
                                  ? Colors.white
                                  : AppColor.backgroundColor,
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(data.imageUrl,
                                    height: width * 0.3,
                                    fit: BoxFit.cover,
                                    width: double.infinity),
                                Expanded(
                                  child: Center(
                                    child: Text(data.name,
                                        style: TextStyle(
                                            color: currentUserDocument!.type ==
                                                    "Admin"
                                                ? Colors.black
                                                : AppColor.textColor,
                                            fontSize: 16),
                                        maxLines: 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                );
              } else {
                return Center(
                  child: constWidget().circularProgressInd(nodatafound: true),
                );
              }
            } else {
              return Center(
                child: constWidget().circularProgressInd(nodatafound: false),
              );
            }
          }),
    );
  }
}
