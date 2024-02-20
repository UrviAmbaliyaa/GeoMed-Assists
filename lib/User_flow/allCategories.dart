import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Models/categoryModel.dart';
import 'package:geomed_assist/User_flow/CategoryDetail.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/dataFile.dart';

class allCategories extends StatefulWidget {
  final List<categoryModel> categories;
  const allCategories({super.key, required this.categories});

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
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: GridView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.categories.length,
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1),
            itemBuilder: (context, index) {
              var data = widget.categories[index];
              return InkWell(
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute<bool>(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => categoryDetail(category: data),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 5, left: 5, top: 5),
                  padding: const EdgeInsets.all(2),
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
                      Image.network(data.imageUrl,
                          height: width * 0.3,
                          fit: BoxFit.cover,
                          width: double.infinity),
                      Expanded(
                        child: Center(
                          child: Text(data.name,
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
