import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geomed_assist/Authentication/sign_in.dart';
import 'package:geomed_assist/Doctor_flow/bottomsheet_doctor.dart';
import 'package:geomed_assist/Firebase/firebaseAuthentications.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/ImagePicker.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:geomed_assist/constants/customTextField.dart';

class SignUpAsDoctor extends StatefulWidget {
  final bool editdcreen;

  const SignUpAsDoctor({super.key, required this.editdcreen});

  @override
  State<SignUpAsDoctor> createState() => _SignUpAsDoctorState();
}

class _SignUpAsDoctorState extends State<SignUpAsDoctor> {
  @override
  TextEditingController emailController = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController aboutUscontroller = TextEditingController();
  TextEditingController experiancecontroller = TextEditingController();
  TextEditingController degreececontroller = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool passwordvisiblity = false;
  bool confirmpasswordvisiblity = false;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  TimeOfDay? breckStartTime;
  TimeOfDay? breackEndendTime;
  bool isLoading = false;
  RegExp emailRegExp = RegExp(r"^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$");

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != startTime) {
      setState(() {
        startTime = pickedTime;
      });
    }
  }

  Future<void> _selectBrackStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != startTime) {
      setState(() {
        breckStartTime = pickedTime;
      });
    }
  }
  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: endTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != endTime) {
      setState(() {
        endTime = pickedTime;
      });
    }
  }
  Future<void> _selectbreackEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: endTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != endTime) {
      setState(() {
        breackEndendTime = pickedTime;
      });
    }
  }


  Future<void> getAddressLatLng() async {
    try {
      setState(() {
        isLoading = true;
      });
      List<Location> locations =
          await locationFromAddress(addressController.text);
      Location location = locations.first;
      var networkImagepath = imagepath != null
          ? await firebase_auth().uploadImage(File(imagepath!))
          : currentUserDocument!.imagePath;
      // Do something with the latitude and longitude
      var mapdata = {
        "type": "Doctore",
        "name": namecontroller.text,
        "email": emailController.text,
        "address": addressController.text,
        "degree": degreececontroller.text,
        "exp": experiancecontroller.text,
        "about_us": aboutUscontroller.text,
        "latLong": location.latitude,
        "longitude": location.longitude,
        "cantact": contactNumberController.text,
        "zipCode": zipCodeController.text,
        "imagePath": networkImagepath,
        "startTime": "${startTime!.hour}:${startTime!.minute}",
        "breckstartTime": "${breckStartTime!.hour}:${breckStartTime!.minute}",
        "endtime":"${endTime!.hour}:${endTime!.minute}",
        "breckendTime":"${breackEndendTime!.hour}:${breackEndendTime!.minute}",
        "approve" : widget.editdcreen? widget.editdcreen : "Pending"
      };
      !widget.editdcreen? mapdata.addAll({"favoriteReference": [],"availableSlot": [],"create": DateTime.now()}):null;
      !widget.editdcreen
          ? await firebase_auth().signUpWithEmailAndPassword(
              emailController.text, password.text, mapdata, context)
          : await firebase_auth().updateData(
              reference: currentUserDocument!.reference, jsondata: mapdata);
      widget.editdcreen == false
          ? Navigator.of(context, rootNavigator: true).push(
        CupertinoPageRoute<bool>(
          fullscreenDialog: true,
          builder: (BuildContext context) => new SignIn(),
        ),
      )
          :Navigator.push(context,MaterialPageRoute(builder: (context) => bottomSheet_doctor()));
    } catch (e) {
      print("Error getting LatLng: $e");
    }
  }

  initalizeData() {
    setState(() {
      emailController.text = currentUserDocument!.email;
      namecontroller.text = currentUserDocument!.name;
      password.text = "123456";
      confirmpassword.text = "123456";
      experiancecontroller.text = currentUserDocument!.exp!;
      degreececontroller.text = currentUserDocument!.degree!;
      addressController.text = currentUserDocument!.address!;
      aboutUscontroller.text = currentUserDocument!.aboutUs!;
      zipCodeController.text = currentUserDocument!.zipCode!;
      contactNumberController.text = currentUserDocument!.contact!;
      List<String> parts = currentUserDocument!.startTime!.split(":");
      startTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      List<String> parts2 = currentUserDocument!.endTime!.split(":");
      endTime = TimeOfDay(hour: int.parse(parts2[0]), minute: int.parse(parts2[1]));
      List<String> parts3 = currentUserDocument!.breckstartTime!.split(":");
      breckStartTime = TimeOfDay(hour: int.parse(parts3[0]), minute: int.parse(parts3[1]));
      List<String> parts4 = currentUserDocument!.breckendTime!.split(":");
      breackEndendTime = TimeOfDay(hour: int.parse(parts4[0]), minute: int.parse(parts4[1]));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.editdcreen ? initalizeData() : null;
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
          widget.editdcreen == false
              ? Container(
                  width: double.infinity,
                  height: width * 0.4,
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    "assets/logo/Logo.png",
                    color: Colors.white,
                    height: 130,
                  ),
                )
              : SizedBox.shrink(),
          Container(
            width: width,
            height: height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height:
                        widget.editdcreen == false ? width * 0.4 : width * 0.1,
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
                                      Text(
                                          widget.editdcreen == false
                                              ? "Sign up As Doctor"
                                              : "Edit Profile",
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
                                              ? !widget.editdcreen
                                                  ? Icon(
                                                      Icons.camera_alt_outlined,
                                                      color: AppColor.textColor
                                                          .withOpacity(0.5))
                                                  : Image.network(
                                                      currentUserDocument!
                                                          .imagePath!,
                                                      fit: BoxFit.cover)
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
                                     !widget.editdcreen ? Column(
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
                                       ],
                                     ):SizedBox.shrink(),
                                      Row(
                                        children: [
                                          Text("Degree",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColor.textColor)),
                                        ],
                                      ),
                                      customeTextFormField(
                                        autofillHint: [
                                          AutofillHints.fullStreetAddress
                                        ],
                                        contoller: degreececontroller,
                                        hintTest: 'Degree',
                                        keybordType: TextInputType.text,
                                        password: false,
                                        passwordvisiblity: false,
                                        sufixIcon: SizedBox.shrink(),
                                        validation: (value) {
                                          if (degreececontroller.text == '') {
                                            return 'This is a required field';
                                          }
                                        },
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Text("Experiance",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColor.textColor)),
                                        ],
                                      ),
                                      customeTextFormField(
                                        autofillHint: [AutofillHints.name],
                                        contoller: experiancecontroller,
                                        hintTest: 'Experiance',
                                        keybordType:
                                            TextInputType.streetAddress,
                                        password: false,
                                        passwordvisiblity: false,
                                        sufixIcon: SizedBox.shrink(),
                                        validation: (value) {
                                          if (experiancecontroller.text == '') {
                                            return 'This is a required field';
                                          }
                                        },
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Text("Address",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColor.textColor)),
                                        ],
                                      ),
                                      customeTextFormField(
                                        autofillHint: [
                                          AutofillHints.fullStreetAddress
                                        ],
                                        contoller: addressController,
                                        hintTest: 'Address',
                                        keybordType:
                                            TextInputType.streetAddress,
                                        password: false,
                                        passwordvisiblity: false,
                                        sufixIcon: SizedBox.shrink(),
                                        validation: (value) {
                                          if (addressController.text == '') {
                                            return 'This is a required field';
                                          }
                                        },
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Text("Zip Code",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColor.textColor)),
                                        ],
                                      ),
                                      customeTextFormField(
                                        autofillHint: [],
                                        contoller: zipCodeController,
                                        hintTest: 'Enter Zip Code',
                                        keybordType: TextInputType.number,
                                        password: false,
                                        passwordvisiblity: false,
                                        sufixIcon: SizedBox.shrink(),
                                        validation: (value) {
                                          if (zipCodeController.text ==
                                              '') {
                                            return 'This is a required field';
                                          } else if (zipCodeController
                                              .text
                                              .trim()
                                              .length <
                                              5) {
                                            return 'Zip code length should be grater than 5.';
                                          }
                                        },
                                      ),
                                      SizedBox(height: 15),
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
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Text("Working Times",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColor.textColor)),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,

                                            children: [
                                              SizedBox(
                                                height: 45,
                                                child: ElevatedButton(
                                                  onPressed: () => _selectStartTime(context),
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStatePropertyAll(AppColor.inputTextfill),
                                                    shape: MaterialStatePropertyAll(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10)
                                                      ),
                                                    )
                                                  ),
                                                  child: Text(startTime == null ? 'Start Time':"${startTime!.hour}:${startTime!.minute}",style: TextStyle(
                                                      color: startTime != null ? AppColor.textColor : Colors.grey.withOpacity(0.8),
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.w400)),
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Text("Start Time",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: AppColor.textColor))
                                            ],
                                          ),
                                          SizedBox(width: 8),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: Text("to",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: AppColor.textColor)),
                                          ),
                                          SizedBox(width: 5),
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 45,
                                                child: ElevatedButton(
                                                  onPressed: () => _selectBrackStartTime(context),
                                                  style: ButtonStyle(
                                                      backgroundColor: MaterialStatePropertyAll(AppColor.inputTextfill),
                                                      shape: MaterialStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10)
                                                        ),
                                                      )
                                                  ),
                                                  child: Text(breckStartTime == null ? 'Break start Time':"${breckStartTime!.hour}:${breckStartTime!.minute} ",style: TextStyle(
                                                      color: breckStartTime != null ? AppColor.textColor : Colors.grey.withOpacity(0.8),
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.w400),),
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Text("Break Start Time",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: AppColor.textColor))
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 45,
                                                child: ElevatedButton(
                                                  onPressed: () => _selectbreackEndTime(context),
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStatePropertyAll(AppColor.inputTextfill),
                                                    shape: MaterialStatePropertyAll(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10)
                                                      ),
                                                    )
                                                  ),
                                                  child: Text(breackEndendTime == null ? 'Break End Time':"${breackEndendTime!.hour}:${breackEndendTime!.minute}",style: TextStyle(
                                                      color: breackEndendTime != null ? AppColor.textColor : Colors.grey.withOpacity(0.8),
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.w400)),
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Text("Break End Time",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: AppColor.textColor))
                                            ],
                                          ),
                                          SizedBox(width: 13),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: Text("to",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: AppColor.textColor)),
                                          ),
                                          SizedBox(width: 15),
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 45,
                                                child: ElevatedButton(
                                                  onPressed: () => _selectEndTime(context),
                                                  style: ButtonStyle(
                                                      backgroundColor: MaterialStatePropertyAll(AppColor.inputTextfill),
                                                      shape: MaterialStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10)
                                                        ),
                                                      )
                                                  ),
                                                  child: Text(endTime == null ? 'End Time':"${endTime!.hour}:${endTime!.minute} ",style: TextStyle(
                                                      color: endTime != null ? AppColor.textColor : Colors.grey.withOpacity(0.8),
                                                      fontSize: 17,
                                                      fontWeight: FontWeight.w400),),
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Text("End Time",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: AppColor.textColor))
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Text("About us",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColor.textColor)),
                                        ],
                                      ),
                                      customeTextFormField(
                                        autofillHint: [],
                                        contoller: aboutUscontroller,
                                        hintTest: 'About us',
                                        keybordType: TextInputType.text,
                                        password: false,
                                        passwordvisiblity: false,
                                        sufixIcon: SizedBox.shrink(),
                                        validation: (value) {
                                          if (aboutUscontroller.text == '') {
                                            return 'This is a required field';
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                splashColor: Colors.transparent,
                                  onTap: () {
                                    if (widget.editdcreen || imagepath != null) {
                                      var validate =
                                          formKey.currentState!.validate();
                                      if (validate) {
                                        if(startTime != null && endTime != null && breackEndendTime != null && breckStartTime != null){
                                          getAddressLatLng();
                                        }else{
                                          constWidget().showSnackbar(
                                              "Please select Working times", context);
                                        }

                                      }
                                    } else {
                                      constWidget().showSnackbar(
                                          "Profile Pick is required.", context);
                                    }
                                  },
                                  child: Container(
                                    height: width * 0.13,
                                    alignment: Alignment.center,
                                    child: !isLoading
                                        ? Text(
                                            widget.editdcreen == false
                                                ? "Sign up"
                                                : "Edit",
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
                  widget.editdcreen == false
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("already have an account! ",
                                style: TextStyle(
                                    color: AppColor.textColor, fontSize: 18)),
                            InkWell(
                splashColor: Colors.transparent,
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(
                                    CupertinoPageRoute<bool>(
                                      fullscreenDialog: true,
                                      builder: (BuildContext context) =>
                                          new SignIn(),
                                    ),
                                  );
                                },
                                child: Text("Sign In",
                                    style: TextStyle(
                                        color: AppColor.textColor,
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold))),
                          ],
                        )
                      : SizedBox.shrink(),
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
