import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Authentication/forgotpassword.dart';
import 'package:geomed_assist/Authentication/sign_up.dart';
import 'package:geomed_assist/Authentication/signupAs.dart';
import 'package:geomed_assist/Doctor_flow/HomeScreen_doctore.dart';
import 'package:geomed_assist/Doctor_flow/bottomsheet_doctor.dart';
import 'package:geomed_assist/Firebase/firebaseAuthentications.dart';
import 'package:geomed_assist/Store_flow/bottomNavigationBar_Shop.dart';
import 'package:geomed_assist/User_flow/BottonTabbar.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:geomed_assist/constants/customTextField.dart';
import 'package:hive/hive.dart';

import '../User_flow/HomePage.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool passwordvisiblity = false;
  bool isLoading = false;
  RegExp emailRegExp = RegExp(r"^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$");

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColor.purplecolor,
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: width * 0.65,
                alignment: Alignment.bottomCenter,
                child: Image.asset("assets/logo/Logo.png", color: Colors.white),
              ),
              Form(
                key: formKey,
                child: Container(
                  margin: EdgeInsets.only(left: 25, right: 25, top: 60),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColor.backgroundColor)),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Sign In",
                                style: TextStyle(
                                    fontSize: 30, color: AppColor.textColor)),
                            SizedBox(height: 23),
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
                              keybordType: TextInputType.visiblePassword,
                              password: true,
                              passwordvisiblity: passwordvisiblity,
                              sufixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      passwordvisiblity = !passwordvisiblity;
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
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          var validate = formKey.currentState!.validate();
                          if (validate) {
                            setState(() {
                              isLoading = !isLoading;
                            });
                            var signUn = await firebase_auth().signInWithEmailAndPassword(emailController.text, password.text);
                            if (signUn) {
                              emailController.clear();
                              password.clear();
                              var Screens;
                              switch (currentUserDocument!.type) {
                                case "User":
                                  Screens = bottomTabBar();
                                case "ShopKeeper":
                                  Screens = shop_bottomNavigationbar();
                                case "Doctore":
                                  Screens = bottomSheet_doctor();
                              }
                              Navigator.of(context, rootNavigator: true).push(
                                CupertinoPageRoute<bool>(
                                  fullscreenDialog: true,
                                  builder: (BuildContext context) =>
                                      Screens,
                                ),
                              );
                            } else {
                              constWidget().showSnackbar(
                                  "Invalide Authentication Id and Password, Please Enter right Authentication Id and Password",
                                  context);
                            }
                            setState(() {
                              isLoading = !isLoading;
                            });
                          }
                        },
                        child: Container(
                          height: width * 0.13,
                          alignment: Alignment.center,
                          child: Text("Sign in",
                              style: TextStyle(
                                  color: AppColor.textColor,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                  child: InkWell(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute<bool>(
                      fullscreenDialog: true,
                      builder: (BuildContext context) => new forgotpassword(),
                    ),
                  );
                },
                child: Text("Forgot Password?",
                    style: TextStyle(
                        color: AppColor.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have any Account? ",
                      style:
                          TextStyle(color: AppColor.textColor, fontSize: 18)),
                  InkWell(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute<bool>(
                            fullscreenDialog: true,
                            builder: (BuildContext context) => new signUpAS(),
                          ),
                        );
                      },
                      child: Text("Sign Up",
                          style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: 19,
                              fontWeight: FontWeight.bold))),
                ],
              ),
              SizedBox(height: 40)
            ],
          ),
        ),
      ),
    );
  }
}
