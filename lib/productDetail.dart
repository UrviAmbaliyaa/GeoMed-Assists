import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Firebase/firebase_quaries.dart';
import 'package:geomed_assist/Models/product.dart';
import 'package:geomed_assist/Models/user_model.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:geomed_assist/constants/dataFile.dart';

class productDetail extends StatefulWidget {
  final Product data;

  const productDetail({super.key, required this.data});

  @override
  State<productDetail> createState() => _productDetailState();
}

class _productDetailState extends State<productDetail> {
  bool sendRequest = false;
  var formKey = GlobalKey<FormState>();
  TextEditingController description = TextEditingController();
  ScrollController scrollController = ScrollController();

  void scrollToTextField() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.textColor,
      body: Container(
        width: width,
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
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
                      image: NetworkImage(widget.data.image),
                      fit: BoxFit.cover,
                    )),
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data.name,
                        style: TextStyle(
                            color: AppColor.backgroundColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      currentUserDocument!.type == "ShopKeeper"
                          ? InkWell(
                              onTap: () {
                                widget.data.referenace.update(
                                    {'available': !widget.data.available});
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: Text(
                                  widget.data.available
                                      ? "Make it Unavailable"
                                      : "Make it Available",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationColor: widget.data.available
                                          ? Colors.red
                                          : Colors.green,
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                      color: widget.data.available
                                          ? Colors.red
                                          : Colors.green,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                  Text(
                    "Diseas: ${widget.data.category}",
                    style: TextStyle(
                        color: AppColor.backgroundColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Price: ${widget.data.price.toString()} \$",
                    style: TextStyle(
                        color: AppColor.backgroundColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  currentUserDocument!.type == "Admin" ||
                          currentUserDocument!.type == "Doctore"
                      ? StreamBuilder<UserModel?>(
                          stream: Firebase_Quires()
                              .getuserInfo(refId: widget.data.shopReference),
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Shop Name: ${snapshot.data!.name}",
                                        style: TextStyle(
                                            color: AppColor.backgroundColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "Address: ${snapshot.data!.address}",
                                        style: TextStyle(
                                            color: AppColor.backgroundColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                          "contact Number: ${snapshot.data!.contact}",
                                          style: TextStyle(
                                              color: AppColor.textColor,
                                              fontSize: 13)),
                                      Text(
                                          "Working time: ${snapshot.data!.startTime} to ${snapshot.data!.endTime}",
                                          style: TextStyle(
                                              color: AppColor.textColor,
                                              fontSize: 13)),
                                    ],
                                  )
                                : SizedBox.shrink();
                          })
                      : SizedBox.shrink(),
                  SizedBox(height: 5),
                  Text(widget.data.description,
                      style: TextStyle(
                          color: AppColor.backgroundColor, fontSize: 13)),
          
                  SizedBox(height: 30),
                  currentUserDocument!.type != "Admin" &&
                      currentUserDocument!.type != "ShopKeeper"
                      ? Column(
                    children: [
                      Form(
                        key: formKey,
                        child: TextFormField(
                          controller: description,
                          keyboardType: TextInputType.multiline,
                          cursorColor: AppColor.primaryColor,
                          maxLines: 5,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Please write your request message.";
                            }
                            return null;
                          },
                          onTap: () {
                            scrollToTextField();
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
                            hintText: "Enter your message here..",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            backgroundColor: MaterialStateProperty.all(
                                AppColor.primaryColor),
                          ),
                          onPressed: () async {
                            print("sendRequest ---->$sendRequest");
                            var validation = formKey.currentState!.validate();
                            if (validation) {
                              var mapData = {
                                'userReference': currentUserDocument!.reference,
                                'productReference': widget.data.referenace,
                                'shopReference': widget.data.shopReference,
                                'description': description.text,
                                'time': DateTime.now(),
                                'status': "Pending",
                              };
                              await FirebaseFirestore.instance
                                  .collection("ProductRequest")
                                  .doc()
                                  .set(mapData);
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            "Send Request",
                            style: TextStyle(
                                color: AppColor.textColor, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  )
                      : SizedBox.shrink(),
                  SizedBox(height: 80),
                ],
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}
