import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Authentication/SignUpAsDoctor.dart';
import 'package:geomed_assist/Authentication/SignUpAsShopkeeper.dart';
import 'package:geomed_assist/Authentication/sign_up.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/ImagePicker.dart';

class signUpAS extends StatefulWidget {
  const signUpAS({super.key});

  @override
  State<signUpAS> createState() => _signUpASState();
}

class _signUpASState extends State<signUpAS> {
  List signUpAs = [
    "Sign up As User",
    "Sign up As Shop keeper",
    "Sign up As Doctor"
  ];
  List signUpScreeen = [SignUp(editdcreen: false), SignUpAsShopkeeper(editdcreen: false), SignUpAsDoctor(editdcreen: false,)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.purplecolor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              child: Image.asset("assets/logo/Logo.png", color: Colors.white),
            ),
            ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 20),
              padding: EdgeInsets.all(30),
              shrinkWrap: true,
              itemCount: signUpAs.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      imagepath = null;
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute<bool>(
                          fullscreenDialog: true,
                          builder: (BuildContext context) =>
                              signUpScreeen[index],
                        ),
                      );
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.backgroundColor),
                    alignment: Alignment.center,
                    child: Text(signUpAs[index],
                        style: TextStyle(
                            color: AppColor.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
