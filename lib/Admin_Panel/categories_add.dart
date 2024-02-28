import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/Admin_Panel/inputField_admin.dart';
import 'package:geomed_assist/Firebase/firebaseAuthentications.dart';
import 'package:geomed_assist/Models/categoryModel.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/ImagePicker.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';

class addCategories extends StatefulWidget {
  final bool edit;
  final categoryModel? categories;

  const addCategories({super.key, required this.edit, this.categories});

  @override
  State<addCategories> createState() => _addCategoriesState();
}

class _addCategoriesState extends State<addCategories> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController description = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    imagepath = null;
  }

  initalizeData() async {
    setState(() {
      nameController.text = widget.categories!.name;
      description.text = widget.categories!.description;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initalizeData();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation:3,
        primary: true,
        leadingWidth: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          widget.edit == false ? 'ADD DISEASES' : "EDIT DISEASES",
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30, top: 10),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Upload Image ",
                        style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 10),
                InkWell(
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
                    width: double.infinity,
                    height: width * 0.5,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: AppColor.greycolor, width: 2)),
                    child: imagepath == null
                        ? widget.edit && widget.categories!.imageUrl.isNotEmpty
                            ? Image.network(widget.categories!.imageUrl,
                                fit: BoxFit.cover)
                            : Icon(
                                Icons.camera_alt_outlined,
                                size: 40,
                                color: AppColor.greycolor,
                              )
                        : Image.file(File(imagepath!), fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text("Diseases Name",
                        style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.w500)),
                  ],
                ),
                inputField_admin(
                  autofillHint: [AutofillHints.name],
                  contoller: nameController,
                  hintTest: 'Enter Name',
                  keybordType: TextInputType.name,
                  password: false,
                  passwordvisiblity: false,
                  sufixIcon: SizedBox.shrink(),
                  validation: (value) {
                    if (nameController.text == '') {
                      return 'This is a required field';
                    }
                  },
                  readOnly: false,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Description ",
                        style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: description,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (description.text == '') {
                      return 'This is a required field';
                    }
                  },
                  cursorColor: AppColor.primaryColor,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w400),
                  minLines: 8,
                  maxLines: 10,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.only(
                        top: 13, bottom: 13, left: 13, right: 2),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Colors.deepPurple, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.5), width: 2),
                        borderRadius: BorderRadius.circular(15)),
                    hintText: "About Diseases...",
                    hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.8),
                        fontSize: 17,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                    onTap: () async {
                      if (imagepath != null || widget.edit) {
                        bool? validation = formKey.currentState?.validate();
                        if (validation == true) {
                          setState(() {
                            isLoading = !isLoading;
                          });
                          var imagepathFB = widget.edit && imagepath == null
                              ? widget.categories!.imageUrl
                              : await firebase_auth()
                                  .uploadImage(File(imagepath!), product: true);
                          Map<String, String?> mapdata = {
                            'name': nameController.text,
                            'description': description.text,
                            'imageUrl': imagepathFB,
                          };
                         widget.edit ?
                             await widget.categories!.refereance.update(mapdata)
                             : await FirebaseFirestore.instance
                              .collection("category")
                              .doc()
                              .set(mapdata);
                          nameController.clear();
                          setState(() {
                            isLoading = !isLoading;
                          });
                          Navigator.pop(context);
                        }
                      } else {
                        constWidget().showSnackbar(
                            "Diseases Pick is required.", context);
                      }
                    },
                    child: Container(
                      height: width * 0.13,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.deepPurple.withOpacity(0.45)),
                      child: !isLoading
                          ? Text(
                              widget.edit == false
                                  ? "Add Diseases"
                                  : "Edit Diseases",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500))
                          : Container(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
