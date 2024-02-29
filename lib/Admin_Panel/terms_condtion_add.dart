import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geomed_assist/constants/Appcolors.dart';

class term_conditions_add extends StatefulWidget {
  final bool edit;
  final String? conditions;
  final DocumentReference? reference;
  const term_conditions_add({super.key, required this.edit, this.conditions, this.reference});

  @override
  State<term_conditions_add> createState() => _term_conditions_addState();
}

class _term_conditions_addState extends State<term_conditions_add> {
  final TextEditingController terms_conditions = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      widget.conditions != null ?  terms_conditions.text = widget.conditions! : null;
    });
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
          "Terms & Conditions",
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
                    Text("Terms & Conditions",
                        style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: terms_conditions,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (terms_conditions.text == '') {
                      return 'This is a required field';
                    }
                  },
                  cursorColor: AppColor.primaryColor,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w400),
                  minLines: 23,
                  maxLines: 24,
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
                    hintText: "Write here...",
                    hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.8),
                        fontSize: 17,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                splashColor: Colors.transparent,
                    onTap: () async {
                        bool? validation = formKey.currentState?.validate();
                        if (validation == true) {
                          setState(() {
                            isLoading = !isLoading;
                          });
                          Map<String, String?> mapdata = {
                            'terms_conditions': terms_conditions.text,
                          };
                          widget.reference == null ?
                          await FirebaseFirestore.instance
                              .collection("Terms_Conditions")
                              .doc()
                              .set(mapdata) 
                          :await widget.reference!.update(mapdata);
                          terms_conditions.clear();
                          setState(() {
                            isLoading = !isLoading;
                          });
                          Navigator.pop(context);
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
                          widget.reference == null
                              ? "Add Terms & Conditions"
                              : "Edit Terms & Conditions",
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
