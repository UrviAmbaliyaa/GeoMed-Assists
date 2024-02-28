import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Models/user_model.dart';
import 'package:geomed_assist/constants/Appcolors.dart';

class product_admin extends StatefulWidget {
  const product_admin({super.key});

  @override
  State<product_admin> createState() => _product_adminState();
}

class _product_adminState extends State<product_admin> {
  List switches = ["All", "Pending", 'Accepted', "Rejected"];
  int selected = 0;
  PageController pgControll = PageController(initialPage: 0);
  TextEditingController searcontroll = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          leadingWidth: 0,
          toolbarHeight: 160,
          automaticallyImplyLeading: false,
          excludeHeaderSemantics: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                "Products",
                style: TextStyle(
                    color: Colors.black, fontSize: 20, fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.deepPurple.withOpacity(0.05)),
                child: TextFormField(
                  controller: searcontroll,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    Future.delayed(Duration(seconds: 2), () => setState(() {}));
                  },
                  style: TextStyle(
                      color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.only(top: 15, bottom: 15, left: 13, right: 2),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(
                            color: Colors.deepPurple.withOpacity(0.5), width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(15)),
                    hintText: "Search here...",
                    hintStyle: TextStyle(
                        color: Colors.deepPurple.withOpacity(0.5),
                        fontSize: 17,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: double.infinity,
                height: 50,
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(width: 7),
                  shrinkWrap: true,
                  itemCount: 4,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashColor: Colors.transparent,
                      onTap: () => setState(() {
                        selected = index;
                        pgControll.animateToPage(index,
                            curve: Curves.decelerate,
                            duration: Duration(milliseconds: 300));
                      }),
                      child: Container(
                        height: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: selected == index
                                ? Colors.deepPurple.withOpacity(0.7)
                                : Colors.transparent),
                        child: Text(switches[index],
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: selected != index
                                    ? FontWeight.w500
                                    : FontWeight.w700,
                                color: selected != index
                                    ? Colors.deepPurple.withOpacity(0.7)
                                    : Colors.white)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: 4,
                controller: pgControll,
                onPageChanged: (value) {
                  setState(() {
                    selected = value;
                  });
                },
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  // Use a builder function to avoid any issues
                  return buildPage(index);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildPage(int index) {
    switch (index) {
      case 0:
        return allUsers();
      case 1:
        return pendingUsers();
      case 2:
        return acceptedUsers();
      case 3:
        return rejectedUsers();
      default:
        return Container(); // You may want to handle other cases
    }
  }

  Widget allUsers() {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: 1,
      itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: 20,right: 20,top: 10),
            child: ExpandablePanel(
              header: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                      "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg",
                    ),
                  ),
                  Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Text(
                              "${"Abc"}",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                  FontWeight.w500),
                              maxLines: 2,
                            ),
                            Text(
                              "Product category",
                              style: TextStyle(
                                  fontSize: 15),
                              maxLines: 1,
                            ),
                            Text(
                                "Product Price}",
                                style: TextStyle(
                                    fontSize: 15)),
                          ],
                        ),
                      )),
                ],
              ),
              collapsed: Text("Collapsed", softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
              expanded: Text("Expanede", softWrap: true, ),
            ),
          );
      },
    );
  }

  Widget pendingUsers() {
    return Container();
  }

  Widget acceptedUsers() {
    return Container();
  }

  Widget rejectedUsers() {
    return Container();
  }

  alertPopu(
      GlobalKey<FormState> formKey, TextEditingController controller, context,
      {required UserModel user}) {
    return Container(
      width: 350,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: 275,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Reject Request of ${user.name}",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            maxLines: 2,
          ),
          Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.multiline,
              cursorColor: AppColor.primaryColor,
              maxLines: 5,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "Please write your request message.";
                }
                return null;
              },
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  bottom: 13,
                  left: 13,
                  right: 2,
                ),
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
                hintText: "Write your reason here..",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  var validate = formKey.currentState!.validate();
                  if (validate) {
                    user.reference.update(
                        {"cancelReason": controller.text, "approve": "Reject"});
                  }
                },
                style: ButtonStyle(
                    elevation: MaterialStatePropertyAll(0),
                    backgroundColor: MaterialStatePropertyAll(
                        CupertinoColors.systemRed.withOpacity(0.5))),
                child: Text("Reject",
                    style: TextStyle(color: Colors.black, fontSize: 17))),
          )
        ],
      ),
    );
  }
}
