import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geomed_assist/Authentication/sign_in.dart';
import 'package:geomed_assist/Firebase/firebaseAuthentications.dart';
import 'package:geomed_assist/User_flow/HomePage.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/ImagePicker.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:geomed_assist/constants/customTextField.dart';

class SignUp extends StatefulWidget {
  final bool editdcreen;
  const SignUp({super.key, required this.editdcreen});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool passwordvisiblity = false;
  bool confirmpasswordvisiblity = false;
  bool isLoading = false;
  RegExp emailRegExp = RegExp(r"^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$");

  initalizeData(){
    setState(() {
      emailController.text = currentUserDocument!.email;
      namecontroller.text = currentUserDocument!.name;
      password.text = "123456";
      confirmpassword.text = "123456";
      currentUserDocument!.contact != null ? contactNumberController.text = currentUserDocument!.contact!:null;
    });
  }

  Future<void> getAddressLatLng() async {
    try {
      setState(() {
        isLoading = true;
      });
      var networkImagepath = imagepath != null
          ? await firebase_auth().uploadImage(File(imagepath!))
          : currentUserDocument!.imagePath;
      Map<String, dynamic> mapdata = {
        "type" :  "User",
        "name" :  namecontroller.text,
        "email" :  emailController.text,
        "imagePath" :  networkImagepath,
        "cantact": contactNumberController.text,
        "approve" :  widget.editdcreen? currentUserDocument!.approve : "Accepted"
      };
      !widget.editdcreen? mapdata.addAll({"favoriteReference": [],"register": DateTime.now()}):null;
      !widget.editdcreen
          ? await firebase_auth().signUpWithEmailAndPassword(
          emailController.text, password.text, mapdata, context)
          : await firebase_auth().updateData(reference: currentUserDocument!.reference,jsondata: mapdata);
      setState(() {
        namecontroller.clear();
        emailController.clear();
        password.clear();
        confirmpassword.clear();
        imagepath = null;
        isLoading = false;
      });
      widget.editdcreen == false
          ? Navigator.of(context,
          rootNavigator: true)
          .push(
        CupertinoPageRoute<bool>(
          fullscreenDialog: true,
          builder:
              (BuildContext context) =>
          new SignIn(),
        ),
      )
          : Navigator.of(context,
          rootNavigator: true)
          .push(
        CupertinoPageRoute<bool>(
          fullscreenDialog: true,
          builder:
              (BuildContext context) =>
          new homePage(),
        ),
      );


    } catch (e) {
      print("Error getting LatLng: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.editdcreen ? initalizeData() :null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    imagepath = null;
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColor.purplecolor,
      body: Stack(
        children: [
          widget.editdcreen == false? Container(
            width: double.infinity,
            height: width * 0.4,
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "assets/logo/Logo.png",
              color: Colors.white,
              height: 130,
            ),
          ):SizedBox.shrink(),
          Container(
            width: width,
            height: height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: width * 0.4,
                    alignment: Alignment.bottomCenter,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(color: AppColor.backgroundColor)),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                      color: AppColor.backgroundColor),
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(widget.editdcreen == false ?"Sign up As User":"Edit Profile",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: AppColor.textColor,
                                              fontWeight: FontWeight.w400)),
                                      SizedBox(height: 23),
                                      InkWell(
                splashColor: Colors.transparent,
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return BottomSheetWidget(
                                                action: () {
                                                  setState(() {});
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              border: Border.all(
                                                  color: AppColor.textColor)),
                                          child: imagepath == null
                                              ? !widget.editdcreen ? Icon(Icons.camera_alt_outlined,
                                              color: AppColor.textColor
                                                  .withOpacity(0.5)):Image.network(currentUserDocument!.imagePath!,fit: BoxFit.cover)
                                              : Image.file(File(imagepath!),
                                              fit: BoxFit.cover,
                                              height: 100,
                                              width: 100),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text("Name",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColor.textColor)),
                                        ],
                                      ),
                                      customeTextFormField(
                                        autofillHint: [AutofillHints.name],
                                        contoller: namecontroller,
                                        hintTest: 'example',
                                        keybordType: TextInputType.name,
                                        password: false,
                                        passwordvisiblity: false,
                                        sufixIcon: SizedBox.shrink(),
                                        validation: (value) {
                                          if (namecontroller.text == '') {
                                            return 'This is a required field';
                                          }
                                        },
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Text("Email",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColor.textColor)),
                                        ],
                                      ),
                                      customeTextFormField(
                                        autofillHint: [AutofillHints.email],
                                        contoller: emailController,
                                        hintTest: 'example@gmail.com',
                                        keybordType: TextInputType.emailAddress,
                                        password: false,
                                        readOnly: widget.editdcreen,
                                        passwordvisiblity: false,
                                        sufixIcon: SizedBox.shrink(),
                                        validation: (value) {
                                          if (emailController.text == '') {
                                            return 'This is a required field';
                                          } else if (!emailRegExp
                                              .hasMatch(emailController.text)) {
                                            return 'Invalide Pattern of the Email.';
                                          }
                                        },
                                      ),
                                      SizedBox(height: 15),
                                      !widget.editdcreen ?Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text("Password",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: AppColor.textColor)),
                                            ],
                                          ),
                                          customeTextFormField(
                                            autofillHint: [AutofillHints.password],
                                            contoller: password,
                                            hintTest: 'Enter Password',
                                            keybordType:
                                            TextInputType.visiblePassword,
                                            password: true,
                                            passwordvisiblity: !passwordvisiblity,
                                            sufixIcon: InkWell(
                splashColor: Colors.transparent,
                                                onTap: () {
                                                  setState(() {
                                                    passwordvisiblity =
                                                    !passwordvisiblity;
                                                  });
                                                },
                                                child: Icon(!passwordvisiblity
                                                    ? CupertinoIcons.eye
                                                    : CupertinoIcons.eye_slash)),
                                            validation: (value) {
                                              if (password.text == '') {
                                                return 'This is a required field.';
                                              } else if (password.text.length < 6) {
                                                return 'Password length should be Greter than 6.';
                                              }
                                            },
                                          ),
                                          SizedBox(height: 15),
                                          Row(
                                            children: [
                                              Text("Confirm Password",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: AppColor.textColor)),
                                            ],
                                          ),
                                          customeTextFormField(
                                            autofillHint: [AutofillHints.password],
                                            contoller: confirmpassword,
                                            hintTest: 'Confirm Password',
                                            keybordType:
                                            TextInputType.visiblePassword,
                                            password: true,
                                            passwordvisiblity:
                                            !confirmpasswordvisiblity,
                                            sufixIcon: InkWell(
                splashColor: Colors.transparent,
                                                onTap: () {
                                                  setState(() {
                                                    confirmpasswordvisiblity =
                                                    !confirmpasswordvisiblity;
                                                  });
                                                },
                                                child: Icon(
                                                    !confirmpasswordvisiblity
                                                        ? CupertinoIcons.eye
                                                        : CupertinoIcons
                                                        .eye_slash)),
                                            validation: (value) {
                                              if (confirmpassword.text == '') {
                                                return 'This is a required field.';
                                              } else if (confirmpassword.text !=
                                                  password.text) {
                                                return "Confirm Password should be match with Password.";
                                              }
                                            },
                                          ),
                                          SizedBox(height: 15),

                                          SizedBox(height: 15),

                                        ],
                                      ):SizedBox.shrink(),
                                      Row(
                                        children: [
                                          Text("Contact",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColor.textColor)),
                                        ],
                                      ),
                                      customeTextFormField(
                                        autofillHint: [
                                          AutofillHints.telephoneNumber
                                        ],
                                        contoller: contactNumberController,
                                        hintTest: 'Contact Number',
                                        keybordType: TextInputType.number,
                                        password: false,
                                        passwordvisiblity: false,
                                        sufixIcon: SizedBox.shrink(),
                                        validation: (value) {
                                          if (contactNumberController.text ==
                                              '') {
                                            return 'This is a required field';
                                          } else if (contactNumberController
                                              .text
                                              .trim()
                                              .length <
                                              10) {
                                            return 'contact Number length should be 10';
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                splashColor: Colors.transparent,
                                  onTap: () {
                                    if(widget.editdcreen || imagepath != null){
                                      var validate =
                                          formKey.currentState!.validate();
                                      if (validate) {
                                        getAddressLatLng();
                                      }
                                    }else{
                                      constWidget().showSnackbar("Profile Pick is required.", context);
                                    }
                                  },
                                  child: Container(
                                    height: width * 0.13,
                                    alignment: Alignment.center,
                                    child: !isLoading
                                        ? Text(widget.editdcreen == false ?"Sign up":"Edit",
                                            style: TextStyle(
                                                color: AppColor.textColor,
                                                fontSize: 19,
                                                fontWeight: FontWeight.w500))
                                        : Container(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                                color: AppColor.textColor),
                                          ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  widget.editdcreen == false ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("already have an account! ",
                          style: TextStyle(
                              color: AppColor.textColor, fontSize: 18)),
                      InkWell(
                splashColor: Colors.transparent,
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute<bool>(
                                fullscreenDialog: true,
                                builder: (BuildContext context) => new SignIn(),
                              ),
                            );
                          },
                          child: Text("Sign In",
                              style: TextStyle(
                                  color: AppColor.textColor,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold))),
                    ],
                  ):SizedBox.shrink(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
