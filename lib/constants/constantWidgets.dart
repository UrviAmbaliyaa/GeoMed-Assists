import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Authentication/sign_in.dart';
import 'package:geomed_assist/Firebase/firebaseAuthentications.dart';
import 'package:geomed_assist/constants/Appcolors.dart';

class constWidget {
  showSnackbar(String message, context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppColor.textColor,
        content: Text(
          message,
          style: TextStyle(color: AppColor.purplecolor),
        )));
  }

  Logout(context) async {
    firebase_auth().SignOut();
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute<bool>(
        fullscreenDialog: true,
        builder: (BuildContext context) => new SignIn(),
      ),
    );
  }

  appbar(context, {required String Name, required bool backbutton}) {
    return AppBar(
      backgroundColor: AppColor.backgroundColor,
      elevation: 0,
      primary: true,
      leadingWidth: 70,
      automaticallyImplyLeading: false,
      leading: backbutton
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
        Name,
        style: TextStyle(
            color: AppColor.textColor,
            fontSize: 18,
            fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }

  circularProgressInd({required bool nodatafound}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        nodatafound
            ? Text("No Data Found",
                style: TextStyle(
                    color: AppColor.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500))
            : Container(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  color: AppColor.primaryColor,
                ),
              ),
      ],
    );
  }
}
