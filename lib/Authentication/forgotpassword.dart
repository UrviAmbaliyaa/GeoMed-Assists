import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Authentication/sign_in.dart';
import 'package:geomed_assist/Authentication/sign_up.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/customTextField.dart';

import '../constants/constantWidgets.dart';

class forgotpassword extends StatefulWidget {
  const forgotpassword({super.key});

  @override
  State<forgotpassword> createState() => _forgotpasswordState();
}

class _forgotpasswordState extends State<forgotpassword> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = true;
  String email = '';
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
                height: width * 0.7,
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
                            Text("Forgot Password",
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
                          ],
                        ),
                      ),
                      InkWell(
                splashColor: Colors.transparent,
                        onTap: () {
                          var validate = formKey.currentState!.validate();
                          if (validate) {
                            email = emailController.text;
                            constWidget().showSnackbar("Kindly update your password using the link sent to ${email}.", context);
                            emailController.clear();
                          }
                        },
                        child: Container(
                          height: width * 0.13,
                          alignment: Alignment.center,
                          child: Text("Change",
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
              Expanded(child: Text("")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("already have an account! ",
                      style:
                          TextStyle(color: AppColor.textColor, fontSize: 18)),
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
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
