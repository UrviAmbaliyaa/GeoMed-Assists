import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geomed_assist/Firebase/firebaseAuthentications.dart';
import 'package:geomed_assist/Firebase/firebase_quaries.dart';
import 'package:geomed_assist/Models/categoryModel.dart';
import 'package:geomed_assist/Models/product.dart';
import 'package:geomed_assist/Store_flow/bottomNavigationBar_Shop.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/ImagePicker.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/customTextField.dart';
import 'package:geomed_assist/constants/dataFile.dart';

class addProduct extends StatefulWidget {
  final bool edit;
  final Product? product;

  const addProduct({super.key, required this.edit, this.product});

  @override
  State<addProduct> createState() => _addProductState();
}

class _addProductState extends State<addProduct> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categorylController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  List<categoryModel>? categories = [];
  // List<String> catList =
  //     Datas().category.map((e) => e['name'].toString()).toList();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    imagepath = null;
  }

  initalizeData() {
    !widget.edit
        ? setState(() {
            categorylController.text = categories!.first.name;
          })
        : setState(() {
            nameController.text = widget.product!.name;
            categorylController.text = categories!.where((element) => element.refereance == widget.product!.category).first.name;
            priceController.text = widget.product!.price.toString();
            aboutController.text = widget.product!.description;
          });
  }

  getCategories() async {
    List<categoryModel>? categories = [];
    Stream<List<categoryModel>?> datas = await Firebase_Quires().getCategory();
    await for (List<categoryModel>? event in datas) {
      setState(() {
        categories = event;
      });
    }
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
      backgroundColor: AppColor.backgroundColor,
      appBar: constWidget().appbar(context,
          Name: widget.edit == false ? 'Add Product' : "Edit Product",
          backbutton: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30, top: 20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
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
                        ? widget.edit && widget.product!.image.isNotEmpty
                            ? Image.network(widget.product!.image,
                                fit: BoxFit.cover)
                            : Icon(
                                Icons.camera_alt_outlined,
                                size: 40,
                                color: AppColor.greycolor,
                              )
                        : Image.file(File(imagepath!), fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Text("Name",
                        style:
                            TextStyle(fontSize: 18, color: AppColor.textColor)),
                  ],
                ),
                customeTextFormField(
                  autofillHint: [AutofillHints.name],
                  contoller: nameController,
                  hintTest: 'Product name',
                  keybordType: TextInputType.name,
                  password: false,
                  passwordvisiblity: false,
                  sufixIcon: SizedBox.shrink(),
                  validation: (value) {
                    if (nameController.text == '') {
                      return 'This is a required field';
                    }
                  },
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Diseases",
                        style:
                            TextStyle(fontSize: 18, color: AppColor.textColor)),
                  ],
                ),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  onChanged: (value) {
                    setState(() {
                      categorylController.text = value.toString();
                    });
                  },
                  value: categorylController.text,
                  validator: (value) {
                    print("value ----->$value");
                    if (value == null) {
                      return "Diseases is required.";
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                        top: 13, bottom: 13, left: 13, right: 2),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: AppColor.purplecolor, width: 1)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    fillColor: AppColor.inputTextfill,
                    filled: true,
                    hintText: "Select Diseases",
                    hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.8),
                        fontSize: 17,
                        fontWeight: FontWeight.w400),
                  ),
                  style: TextStyle(color: AppColor.textColor),
                  dropdownColor: AppColor.backgroundColor.withOpacity(0.8),
                  items: categories!.map((e) => e.name.toString()).toList().map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Price",
                        style:
                            TextStyle(fontSize: 18, color: AppColor.textColor)),
                  ],
                ),
                customeTextFormField(
                  autofillHint: [AutofillHints.telephoneNumber],
                  contoller: priceController,
                  hintTest: '300\$',
                  keybordType: TextInputType.phone,
                  password: false,
                  passwordvisiblity: false,
                  sufixIcon: SizedBox.shrink(),
                  validation: (value) {
                    if (priceController.text == '') {
                      return 'This is a required field';
                    }
                  },
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("About ",
                        style:
                            TextStyle(fontSize: 18, color: AppColor.textColor)),
                  ],
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: aboutController,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (aboutController.text == '') {
                      return 'This is a required field';
                    }
                  },
                  cursorColor: AppColor.primaryColor,
                  style: TextStyle(
                      color: AppColor.textColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w400),
                  minLines: 4,
                  maxLines: 5,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.only(
                        top: 13, bottom: 13, left: 13, right: 2),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: AppColor.purplecolor, width: 1)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    fillColor: AppColor.inputTextfill,
                    filled: true,
                    hintText: "About Product...",
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
                              ? widget.product!.image
                              : await firebase_auth()
                                  .uploadImage(File(imagepath!), product: true);
                          await Firebase_Quires().crudOperations(
                              available: true,
                              categoryReferance: categories!.where((element) => element.name == categorylController.text).first.refereance,
                              crudType: widget.edit ? "update" : "add",
                              image: imagepathFB!,
                              description: aboutController.text,
                              name: nameController.text,
                              price: priceController.text,
                              productID: widget.edit
                                  ? widget.product!.referenace.id
                                  : "0");
                          nameController.clear();
                          categorylController.clear();
                          priceController.clear();
                          aboutController.clear();
                          setState(() {
                            isLoading = !isLoading;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      shop_bottomNavigationbar()));
                        }
                      } else {
                        constWidget()
                            .showSnackbar("Product Pick is required.", context);
                      }
                    },
                    child: Container(
                      height: width * 0.13,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.primaryColor),
                      child: !isLoading
                          ? Text(
                              widget.edit == false
                                  ? "Add Product"
                                  : "Edit Product",
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
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
